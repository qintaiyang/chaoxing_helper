import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../app_dependencies.dart';

class HomeworkWebViewPage extends StatefulWidget {
  final String workId;
  final String courseId;
  final String classId;
  final String cpi;
  final String enc;
  final String answerId;
  final String taskUrl;

  const HomeworkWebViewPage({
    super.key,
    required this.workId,
    required this.courseId,
    required this.classId,
    required this.cpi,
    required this.enc,
    required this.answerId,
    required this.taskUrl,
  });

  @override
  State<HomeworkWebViewPage> createState() => _HomeworkWebViewPageState();
}

class _HomeworkWebViewPageState extends State<HomeworkWebViewPage> {
  late final WebViewController _controller;
  bool _controllerReady = false;
  bool _loading = true;
  bool _hasError = false;
  String _errorMessage = '';
  bool _isLoginPage = false;

  final AudioRecorder _audioRecorder = AudioRecorder();
  bool _isRecording = false;
  String? _recordingPath;

  static const _browserUa =
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36';

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  bool _isLoginPageUrl(String url) {
    return url.contains('passport2.chaoxing.com') ||
        url.contains('passport.chaoxing.com') ||
        (url.contains('login') && url.contains('chaoxing.com'));
  }

  Future<void> _checkLoginPage() async {
    try {
      final currentUrl = await _controller.currentUrl();
      if (currentUrl != null && _isLoginPageUrl(currentUrl)) {
        debugPrint('检测到登录页面: $currentUrl');
        if (mounted) {
          setState(() {
            _isLoginPage = true;
            _loading = false;
          });
        }
      } else {
        if (mounted && _isLoginPage) {
          setState(() {
            _isLoginPage = false;
          });
        }
      }
    } catch (e) {
      debugPrint('检查登录页面失败: $e');
    }
  }

  Future<void> _initWebView() async {
    if (Platform.isAndroid) {
      try {
        const platform = MethodChannel('com.chaoxinghelper/webview');
        await platform.invokeMethod('enableMixedContent');
        debugPrint('Android 混合内容模式已启用');
      } catch (e) {
        debugPrint('启用混合内容模式失败: $e');
      }
    }

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent(_browserUa)
      ..addJavaScriptChannel(
        'NativeBridge',
        onMessageReceived: (JavaScriptMessage message) {
          _handleNativeMessage(message.message);
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) async {
            debugPrint('WebView 开始加载: $url');
            if (mounted) {
              setState(() {
                _loading = true;
                _hasError = false;
              });
            }
          },
          onPageFinished: (url) async {
            debugPrint('WebView 加载完成: $url');

            await _injectViewport();
            await _injectChaoxingMobileStyles();
            await _injectCookiesViaJs();
            await _setupFileInputInterceptor();
            await _checkLoginPage();

            if (mounted) {
              setState(() {
                _loading = false;
              });
            }
          },
          onWebResourceError: (error) {
            debugPrint(
              'WebView 资源错误: ${error.description} (${error.errorCode}), url=${error.url}',
            );
            if (mounted) {
              setState(() {
                _loading = false;
                _hasError = true;
                _errorMessage = '${error.description} (${error.errorCode})';
              });
            }
          },
          onNavigationRequest: (request) {
            debugPrint('WebView 导航请求: ${request.url}');
            return NavigationDecision.navigate;
          },
        ),
      );

    try {
      if (mounted) {
        setState(() {
          _controllerReady = true;
        });
      }

      // 在加载页面前先设置全局Cookie
      await _setupNativeCookies();

      final workUrl = _buildWorkUrl();
      debugPrint('WebView 加载作业URL: $workUrl');
      await _controller.loadRequest(Uri.parse(workUrl));
    } catch (e) {
      debugPrint('WebView 初始化异常: $e');
      if (mounted) {
        setState(() {
          _loading = false;
          _hasError = true;
          _errorMessage = '初始化失败: $e';
        });
      }
    }
  }

  Future<void> _setupNativeCookies() async {
    try {
      final cookieManager = AppDependencies.instance.cookieManager;
      final sessionIdResult = AppDependencies.instance.accountRepo
          .getCurrentSessionId();

      sessionIdResult.fold(
        (failure) => debugPrint('获取Session ID失败: ${failure.message}'),
        (userId) async {
          if (userId == null || userId.isEmpty) {
            debugPrint('User ID为空，无法设置Cookie');
            return;
          }

          final cookieJar = cookieManager.getCurrentUserCookieJar(userId);
          if (cookieJar == null) {
            debugPrint('CookieJar为null，用户 $userId');
            return;
          }

          final hosts = [
            '.chaoxing.com',
            'www.chaoxing.com',
            'passport2.chaoxing.com',
            'mooc1.chaoxing.com',
            'mooc1-1.chaoxing.com',
            'mooc1-api.chaoxing.com',
            'mooc2-ans.chaoxing.com',
            'i.chaoxing.com',
            'learn.chaoxing.com',
            'photo.chaoxing.com',
            'im.chaoxing.com',
            'sso.chaoxing.com',
            'passport2-api.chaoxing.com',
            'mobilelearn.chaoxing.com',
          ];

          final allCookies = <String, Cookie>{};

          for (final host in hosts) {
            try {
              final uri = Uri.parse('https://$host');
              final cookies = await cookieJar.loadForRequest(uri);
              for (final c in cookies) {
                final key = '${c.name}@${c.domain ?? host}';
                allCookies.putIfAbsent(key, () => c);
              }
            } catch (e) {
              debugPrint('加载 $host 的Cookie失败: $e');
            }
          }

          await _setCookiesNative(allCookies.values.toList());
          debugPrint('通过原生API注入了 ${allCookies.length} 个Cookie');
        },
      );
    } catch (e) {
      debugPrint('设置Cookie失败: $e');
    }
  }

  Future<void> _setCookiesNative(List<Cookie> cookies) async {
    final cookieManager = WebViewCookieManager();
    for (final cookie in cookies) {
      final domain = cookie.domain ?? '.chaoxing.com';
      final path = cookie.path ?? '/';
      try {
        await cookieManager.setCookie(
          WebViewCookie(
            name: cookie.name,
            value: cookie.value,
            domain: domain.startsWith('.') ? domain : '.$domain',
            path: path,
          ),
        );
      } catch (e) {
        debugPrint('设置Cookie失败 ${cookie.name}: $e');
      }
    }
  }

  Future<void> _injectViewport() async {
    await _controller.runJavaScript('''
      var meta = document.createElement('meta');
      meta.setAttribute('name', 'viewport');
      meta.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no');
      document.getElementsByTagName('head')[0].appendChild(meta);
      
      var style = document.createElement('style');
      style.textContent = '* { max-width: 100% !important; box-sizing: border-box !important; }';
      document.head.appendChild(style);
    ''');
  }

  Future<void> _injectChaoxingMobileStyles() async {
    await _controller.runJavaScript(r'''
      (function() {
        if (window.__chaoxingStylesInjected) return;
        window.__chaoxingStylesInjected = true;
        
        var style = document.createElement('style');
        style.id = '__chaoxing-mobile-styles';
        style.textContent = `
          .body-wrapper, .container, #container, .wrap { max-width: 100% !important; padding: 0 8px !important; margin: 0 auto !important; }
          .workHead, .workTitle, .questionBox, .TiMu { padding: 8px !important; margin: 8px 0 !important; }
          .optionItem, .answerOption, .num_option, .num_option_dx { padding: 12px 8px !important; margin: 4px 0 !important; }
          .fanyaMarking.TiMu { margin-bottom: 16px !important; border-radius: 8px !important; overflow: hidden !important; }
          .editorBtn, .uploadBtn { min-height: 44px !important; padding: 12px !important; }
          .submitBtn, #submitBtn, .btn_submit { min-height: 48px !important; font-size: 16px !important; border-radius: 8px !important; }
          .iframeContainer, .video-container { width: 100% !important; position: relative !important; padding-top: 56.25% !important; }
          .iframeContainer iframe, .video-container iframe { position: absolute !important; top: 0 !important; left: 0 !important; width: 100% !important; height: 100% !important; }
          .marking { position: relative !important; }
          .clearfix:after { content: "" !important; display: table !important; clear: both !important; }
          .hidden-xs { display: block !important; }
          .col-xs-12, .col-sm-12, .col-md-12 { width: 100% !important; float: none !important; }
          .row { margin-left: 0 !important; margin-right: 0 !important; }
          [class*="col-"] { padding-left: 8px !important; padding-right: 8px !important; }
        `;
        if (document.head) document.head.appendChild(style);
        else document.addEventListener('DOMContentLoaded', function() { if (!document.getElementById('__chaoxing-mobile-styles')) document.head.appendChild(style); });
      })();
    ''');
  }

  Future<void> _injectCookiesViaJs() async {
    try {
      final cookieManager = AppDependencies.instance.cookieManager;
      final sessionIdResult = AppDependencies.instance.accountRepo
          .getCurrentSessionId();

      sessionIdResult.fold(
        (failure) => debugPrint('获取Session ID失败: ${failure.message}'),
        (userId) async {
          if (userId == null || userId.isEmpty) {
            debugPrint('User ID为空，无法注入Cookie');
            return;
          }

          final cookieJar = cookieManager.getCurrentUserCookieJar(userId);
          if (cookieJar == null) {
            debugPrint('CookieJar为null，用户 $userId');
            return;
          }

          final hosts = [
            '.chaoxing.com',
            'www.chaoxing.com',
            'passport2.chaoxing.com',
            'mooc1.chaoxing.com',
            'mooc1-1.chaoxing.com',
            'mooc1-api.chaoxing.com',
            'mooc2-ans.chaoxing.com',
            'i.chaoxing.com',
            'learn.chaoxing.com',
            'photo.chaoxing.com',
            'im.chaoxing.com',
            'sso.chaoxing.com',
            'passport2-api.chaoxing.com',
            'mobilelearn.chaoxing.com',
          ];

          final allCookies = <String, Cookie>{};

          for (final host in hosts) {
            try {
              final uri = Uri.parse('https://$host');
              final cookies = await cookieJar.loadForRequest(uri);
              for (final c in cookies) {
                final key = '${c.name}@${c.domain ?? host}';
                allCookies.putIfAbsent(key, () => c);
              }
            } catch (e) {
              debugPrint('加载 $host 的Cookie失败: $e');
            }
          }

          final jsCode = _buildCookieInjectionJs(allCookies.values.toList());
          if (jsCode.isNotEmpty) {
            await _controller.runJavaScript(jsCode);
            debugPrint('通过JavaScript注入了 ${allCookies.length} 个Cookie');
          }
        },
      );
    } catch (e) {
      debugPrint('注入Cookie失败: $e');
    }
  }

  String _buildCookieInjectionJs(List<Cookie> cookies) {
    if (cookies.isEmpty) return '';

    final cookieStrings = <String>[];
    for (final cookie in cookies) {
      final name = cookie.name.replaceAll("'", "\\'");
      final value = cookie.value.replaceAll("'", "\\'");
      final domain = cookie.domain ?? '.chaoxing.com';
      final path = cookie.path ?? '/';
      cookieStrings.add(
        "document.cookie = '$name=$value; domain=$domain; path=$path; Secure; SameSite=None';",
      );
    }

    return cookieStrings.join('\n');
  }

  Future<void> _setupFileInputInterceptor() async {
    try {
      await _controller.runJavaScript('''
        (function() {
          if (window.__fileInterceptorSetup) return;
          window.__fileInterceptorSetup = true;

          function findFileInput(el) {
            if (!el) return null;
            if (el.tagName === 'INPUT' && el.type === 'file') return el;
            var input = el.querySelector ? el.querySelector('input[type="file"]') : null;
            if (input) return input;
            var parent = el.parentElement;
            for (var i = 0; i < 5 && parent; i++) {
              input = parent.querySelector ? parent.querySelector('input[type="file"]') : null;
              if (input) return input;
              parent = parent.parentElement;
            }
            return null;
          }

          function isUploadBtn(el) {
            if (!el) return false;
            var text = (el.innerText || el.textContent || '').trim();
            var cls = (el.className || '').toLowerCase();
            var id = (el.id || '').toLowerCase();
            if (text.indexOf('上传') >= 0 || text.indexOf('选择文件') >= 0 || text.indexOf('附件') >= 0) return true;
            if (cls.indexOf('upload') >= 0 || cls.indexOf('file') >= 0 || cls.indexOf('attach') >= 0) return true;
            if (id.indexOf('upload') >= 0 || id.indexOf('file') >= 0) return true;
            return false;
          }

          function isUEditorUploadBtn(el) {
            if (!el) return null;
            var parent = el;
            for (var i = 0; i < 8 && parent; i++) {
              var pCls = (parent.className || '');
              if (pCls.indexOf('edui-for-attachment_new') >= 0) return 'attachment_new';
              if (pCls.indexOf('edui-for-tpupload') >= 0) return 'tpupload';
              if (pCls.indexOf('edui-for-insertimage') >= 0) return 'insertimage';
              if (pCls.indexOf('edui-for-recording') >= 0) return 'recording';
              if (pCls.indexOf('edui-for-audio') >= 0) return 'audio';
              parent = parent.parentElement;
            }
            return null;
          }

          document.addEventListener('click', function(e) {
            var target = e.target;
            
            var ueditorType = isUEditorUploadBtn(target);
            if (ueditorType) {
              e.preventDefault();
              e.stopPropagation();
              e.stopImmediatePropagation();
              
              console.log('[FileInterceptor] UEditor upload button clicked:', ueditorType);
              
              if (ueditorType === 'recording') {
                console.log('[FileInterceptor] Launch recording interface');
                NativeBridge.postMessage(JSON.stringify({
                  type: 'startRecording'
                }));
                return;
              }
              
              var accept = '*/*';
              var multiple = true;
              if (ueditorType === 'tpupload') {
                accept = 'image/*';
                multiple = false;
              } else if (ueditorType === 'audio') {
                accept = 'audio/*,.mp3,.wav,.m4a,.aac,.ogg,.wma';
                multiple = false;
              }
              
              window.__lastUEditorType = ueditorType;
              
              NativeBridge.postMessage(JSON.stringify({
                type: 'pickFile',
                accept: accept,
                extensions: [],
                multiple: multiple,
                ueditorType: ueditorType
              }));
              return;
            }
          
            var fileInput = findFileInput(target);
            if (fileInput) {
              e.preventDefault();
              e.stopPropagation();

              var accept = fileInput.getAttribute('accept') || '';
              var extensions = accept.split(',').map(function(s) {
                return s.trim().replace('.', '').replace('/*', '');
              }).filter(function(s) { return s.length > 0; });

              window.__lastFileInput = fileInput;

              NativeBridge.postMessage(JSON.stringify({
                type: 'pickFile',
                accept: accept,
                extensions: extensions,
                multiple: fileInput.multiple
              }));
              return;
            }
            if (isUploadBtn(target)) {
              var nearbyInput = target.parentElement ? target.parentElement.querySelector('input[type="file"]') : null;
              if (!nearbyInput) {
                nearbyInput = document.querySelector('input[type="file"]');
              }
              if (nearbyInput) {
                e.preventDefault();
                e.stopPropagation();

                var accept2 = nearbyInput.getAttribute('accept') || '';
                var extensions2 = accept2.split(',').map(function(s) {
                  return s.trim().replace('.', '').replace('/*', '');
                }).filter(function(s) { return s.length > 0; });

                window.__lastFileInput = nearbyInput;

                NativeBridge.postMessage(JSON.stringify({
                  type: 'pickFile',
                  accept: accept2,
                  extensions: extensions2,
                  multiple: nearbyInput.multiple
                }));
              }
            }
          }, true);

          window.setNativeFileToInput = function(filePath, fileName) {
            var input = window.__lastFileInput || document.querySelector('input[type="file"]');
            if (input) {
              input.setAttribute('data-native-file-path', filePath);
              input.setAttribute('data-native-file-name', fileName);
              var event = new Event('change', { bubbles: true });
              input.dispatchEvent(event);
              console.log('[FileInterceptor] set file to input:', fileName);
            } else {
              console.log('[FileInterceptor] no file input found');
            }
          };

          window.handleUEditorFileUpload = function(filePath, fileName, fileSize, ueditorType) {
            console.log('[FileInterceptor] UEditor file upload:', fileName, ueditorType);
            
            var uploadUrl = 'https://mooc1.chaoxing.com/upload-ans/ueditorupload/attachment?uploadtype=work';
            if (ueditorType === 'insertimage') {
              uploadUrl = 'https://mooc1.chaoxing.com/upload-ans/ueditorupload/upload?uploadtype=image';
            } else if (ueditorType === 'recording') {
              uploadUrl = 'https://mooc1.chaoxing.com/upload-ans/upload/uploadNew?uploadtype=work';
            } else if (ueditorType === 'audio') {
              uploadUrl = 'https://mooc1.chaoxing.com/upload-ans/ueditorupload/attachment?uploadtype=work';
            }
            
            var win = window.parent.document.getElementById('uploadEnc') ? window.parent : window;
            var uploadEnc = win.document.getElementById('uploadEnc') ? win.document.getElementById('uploadEnc').value : '';
            var uploadTimeStamp = win.document.getElementById('uploadTimeStamp') ? win.document.getElementById('uploadTimeStamp').value : '';
            var uid = win.document.getElementById('userId') ? win.document.getElementById('userId').value : '';
            
            if (uploadEnc && uploadTimeStamp && uid) {
              uploadUrl += '&source=1&enc2=' + encodeURIComponent(uploadEnc) + '&t=' + encodeURIComponent(uploadTimeStamp) + '&uid=' + encodeURIComponent(uid);
              console.log('[FileInterceptor] Auth params added');
            } else {
              console.log('[FileInterceptor] Warning: missing auth params');
            }
            
            console.log('[FileInterceptor] Upload URL:', uploadUrl);
            
            NativeBridge.postMessage(JSON.stringify({
              type: 'uploadFile',
              filePath: filePath,
              fileName: fileName,
              fileSize: fileSize,
              uploadUrl: uploadUrl,
              ueditorType: ueditorType
            }));
          };

          window.insertFileToUEditor = function(fileUrl, fileName, fileType, objectId) {
            try {
              if (typeof UE !== 'undefined' && UE.getEditor) {
                var editors = UE.instants;
                for (var key in editors) {
                  var editor = editors[key];
                  if (editor && editor.execCommand) {
                    if (fileType === 'image') {
                      var oid = objectId || fileUrl.split('objectId=').pop().split('&')[0];
                      var html = '<p><img src="https://mooc1.chaoxing.com/ananas/status/' + oid + '" alt="' + fileName + '" style="max-width:100%;height:auto;" /></p>';
                      editor.execCommand('inserthtml', html);
                    } else if (fileType === 'recording' || fileType === 'audio') {
                      var oid = objectId || fileUrl.split('/').pop();
                      var html = '<p><iframe data="' + oid + '" height="62px" width="auto" frameborder="0" allowtransparency="true" style="background-color:transparent;border-radius: 3px;overflow: hidden;z-index: 0;" scrolling="no" src="https://mooc1.chaoxing.com/ananas/common-modules/audioplay/audioplay.html?objectid=' + oid + '" name="' + fileName + '" class="ans-insertaudio-module" module="_insertaudio">[音频]</iframe></p>';
                      editor.execCommand('inserthtml', html);
                    } else {
                      var html = '<a href="' + fileUrl + '" target="_blank">' + fileName + '</a>';
                      editor.execCommand('inserthtml', html);
                    }
                    console.log('[FileInterceptor] File inserted to UEditor:', fileName, fileType);
                    return true;
                  }
                }
              }
            } catch (e) {
              console.log('[FileInterceptor] insertFileToUEditor error:', e);
            }
            return false;
          };

          console.log('[FileInterceptor] file input interceptor ready');
        })();
      ''');
      debugPrint('文件输入拦截器已设置');
    } catch (e) {
      debugPrint('文件输入拦截器设置失败: $e');
    }
  }

  void _handleNativeMessage(String message) async {
    try {
      final data = jsonDecode(message) as Map<String, dynamic>;
      debugPrint('JS消息: $message');

      switch (data['type']) {
        case 'startRecording':
          await _startRecording();
          break;
        case 'pickFile':
          await _pickAndSendFile(data);
          break;
        case 'uploadFile':
          await _uploadFile(data);
          break;
        case 'uploadProgress':
          final progress = data['progress'] as num?;
          if (progress != null && progress > 0.9) {
            debugPrint('上传进度: ${(progress * 100).toStringAsFixed(1)}%');
          }
          break;
        case 'uploadComplete':
          final url = data['url'] as String?;
          final fileName = data['fileName'] as String?;
          debugPrint('文件上传完成并插入: $fileName -> $url');
          break;
        case 'uploadFailed':
          debugPrint('文件上传失败: ${data['message']}');
          break;
        case 'filePicked':
          final filePath = data['filePath'] as String?;
          final fileName = data['fileName'] as String?;
          if (filePath != null && fileName != null) {
            debugPrint('通知JS设置文件到input: $fileName');
            final safePath = filePath
                .replaceAll('\\\\', '/')
                .replaceAll("'", "\\'");
            final safeName = fileName.replaceAll("'", "\\'");
            await _controller.runJavaScript('''
              if (window.setNativeFileToInput) {
                window.setNativeFileToInput('$safePath', '$safeName');
              }
            ''');
          }
          break;
        default:
          debugPrint('未知消息类型: ${data['type']}');
      }
    } catch (e) {
      debugPrint('处理JS消息异常: $e');
    }
  }

  Future<void> _pickAndSendFile(Map<String, dynamic> data) async {
    try {
      final allowedExtensions = (data['extensions'] as List?)
          ?.map((e) => e.toString())
          .toList();
      final FileType fileType =
          allowedExtensions != null && allowedExtensions.isNotEmpty
          ? FileType.custom
          : FileType.any;
      final ueditorType = data['ueditorType'] as String?;

      debugPrint(
        '调用原生文件选择器, 类型: $fileType, 扩展名: $allowedExtensions, ueditorType: $ueditorType',
      );

      FilePickerResult? result;
      try {
        result = await FilePicker.platform.pickFiles(
          type: fileType,
          allowedExtensions: allowedExtensions,
        );
      } catch (e, s) {
        debugPrint('FilePicker 调用异常: $e');
        debugPrint('Stack: $s');
        await _controller.runJavaScript('''
          NativeBridge.postMessage(JSON.stringify({
            type: 'filePickError',
            error: 'FilePicker error: ${e.toString().replaceAll("'", "\\'")}'
          }));
        ''');
        return;
      }

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        final String? rawPath = file.path;
        if (rawPath == null) {
          debugPrint('文件路径为空');
          return;
        }
        final safePath = rawPath.replaceAll('\\\\', '/');
        final int fileSize = file.size;
        debugPrint('用户选择文件: ${file.name} ($fileSize bytes)');

        if (ueditorType != null) {
          final safeJsPath = safePath.replaceAll("'", "\\'");
          final safeJsName = file.name.replaceAll("'", "\\'");
          final js =
              '''
            (function() {
              if (window.handleUEditorFileUpload) {
                window.handleUEditorFileUpload('$safeJsPath', '$safeJsName', $fileSize, '$ueditorType');
              }
            })();
          ''';
          await _controller.runJavaScript(js);
        } else {
          final safeJsPath = safePath.replaceAll("'", "\\'");
          final safeJsName = file.name.replaceAll("'", "\\'");
          final js =
              '''
            (function() {
              if (window.setNativeFileToInput) {
                window.setNativeFileToInput('$safeJsPath', '$safeJsName');
              }
              NativeBridge.postMessage(JSON.stringify({
                type: 'filePicked',
                fileName: '$safeJsName',
                filePath: '$safeJsPath',
                fileSize: $fileSize,
                fileType: '${file.extension ?? ''}'
              }));
            })();
          ''';
          await _controller.runJavaScript(js);
        }
      } else {
        debugPrint('用户取消选择文件');
      }
    } catch (e, s) {
      debugPrint('文件选择异常: $e');
      debugPrint('Stack: $s');
    }
  }

  Future<void> _uploadFile(Map<String, dynamic> data) async {
    final filePath = data['filePath'] as String?;
    final uploadUrl = data['uploadUrl'] as String?;
    final fileName = data['fileName'] as String?;
    final ueditorType = data['ueditorType'] as String?;

    if (filePath == null) {
      debugPrint('文件路径为空');
      return;
    }

    debugPrint('开始上传文件: $fileName ($filePath), ueditorType: $ueditorType');

    try {
      final file = File(filePath);
      if (!await file.exists()) {
        debugPrint('文件不存在: $filePath');
        return;
      }

      if (uploadUrl != null && uploadUrl.isNotEmpty) {
        debugPrint('使用上传URL: $uploadUrl');

        await _uploadFileToUEditor(file, uploadUrl, ueditorType, (
          progress,
        ) async {
          await _controller.runJavaScript('''
              NativeBridge.postMessage(JSON.stringify({
                type: 'uploadProgress',
                progress: $progress
              }));
            ''');
        });
      }
    } catch (e) {
      debugPrint('上传异常: $e');
    }
  }

  Future<Map<String, dynamic>?> _uploadFileToUEditor(
    File file,
    String uploadUrl,
    String? ueditorType,
    void Function(double progress) onProgress, {
    String fieldName = 'upfile',
  }) async {
    final dioClient = AppDependencies.instance.dioClient;
    final dio = dioClient.dio;

    final origFileName = file.path.split(Platform.pathSeparator).last;

    debugPrint('上传字段: $fieldName, 类型: $ueditorType');

    try {
      final response = await dio.post(
        uploadUrl,
        data: FormData.fromMap({
          fieldName: await MultipartFile.fromFile(
            file.path,
            filename: origFileName,
          ),
        }),
        onSendProgress: (sent, total) {
          final progress = total > 0 ? sent / total : 0.0;
          onProgress(progress);
        },
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        final rawType = responseData.runtimeType.toString();
        debugPrint('上传响应 type=$rawType data=$responseData');

        Map<String, dynamic> data;
        if (responseData is Map) {
          data = Map<String, dynamic>.from(responseData);
        } else if (responseData is String) {
          try {
            data = jsonDecode(responseData) as Map<String, dynamic>;
          } catch (e) {
            debugPrint('JSON解析失败: $e');
            return {'success': false};
          }
        } else {
          debugPrint('未知响应类型: $rawType');
          return {'success': false};
        }

        final state = data['state']?.toString() ?? '';

        if (state == 'false' ||
            state == 'FAIL' ||
            state == '上传失败' ||
            state == 'no permission') {
          debugPrint('上传失败，state=$state');
          return {'success': false, 'state': state};
        }

        var fileUrl = (data['url'] ?? '').toString();
        final originalName = (data['original'] ?? data['title'] ?? origFileName)
            .toString();
        final objectId =
            (data['objectIdEnc'] ?? data['objectid'] ?? data['objectId'] ?? '')
                .toString();

        final isImage =
            ueditorType == 'insertimage' ||
            originalName.toLowerCase().contains(
              RegExp(r'\.(jpg|png|gif|jpeg|bmp)$'),
            );
        final isAudio = ueditorType == 'recording' || ueditorType == 'audio';

        String fileTypeStr;
        if (isAudio) {
          fileTypeStr = ueditorType!;
        } else if (isImage) {
          fileTypeStr = 'image';
        } else {
          fileTypeStr = 'file';
        }

        if (fileUrl.startsWith('/')) {
          fileUrl = 'https://mooc1.chaoxing.com$fileUrl';
        }

        if (objectId.isNotEmpty && isImage) {
          fileUrl =
              'https://mooc1.chaoxing.com/ueditorupload/read?objectId=$objectId';
          debugPrint('使用超星read接口避免CDN重定向: $fileUrl');
        }

        debugPrint(
          '插入编辑器: url=$fileUrl, name=$originalName, type=$fileTypeStr, oid=$objectId',
        );

        final safeUrl = fileUrl.replaceAll("'", "\\'");
        final safeName = originalName.replaceAll("'", "\\'");
        final safeType = fileTypeStr.replaceAll("'", "\\'");
        final safeOid = objectId.replaceAll("'", "\\'");

        await _controller.runJavaScript('''
          (function() {
            if (window.insertFileToUEditor) {
              window.insertFileToUEditor('$safeUrl', '$safeName', '$safeType', '$safeOid');
            }
            NativeBridge.postMessage(JSON.stringify({
              type: 'uploadComplete',
              url: '$safeUrl',
              fileName: '$safeName'
            }));
          })();
        ''');

        return {'success': true, 'url': fileUrl, 'original': originalName};
      }
      return {'success': false};
    } catch (e) {
      debugPrint('HTTP上传失败: $e');
      rethrow;
    }
  }

  Future<void> _startRecording() async {
    try {
      final status = await Permission.microphone.request();
      if (!status.isGranted) {
        debugPrint('麦克风权限被拒绝');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('需要麦克风权限才能录音'),
              duration: Duration(seconds: 2),
            ),
          );
        }
        return;
      }

      final tempDir = await getTemporaryDirectory();
      _recordingPath =
          '${tempDir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.mp3';

      debugPrint('开始录音，保存到: $_recordingPath');

      await _audioRecorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: _recordingPath!,
      );

      setState(() {
        _isRecording = true;
      });

      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => StatefulBuilder(
            builder: (ctx, setDialogState) => AlertDialog(
              title: const Row(
                children: [
                  Icon(Icons.mic, color: Colors.red),
                  SizedBox(width: 8),
                  Text('正在录音'),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('点击"完成"结束录音并上传'),
                  const SizedBox(height: 16),
                  const Text(
                    '● 录音中...',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  StreamBuilder<RecordState>(
                    stream: _audioRecorder.onStateChanged(),
                    builder: (context, snapshot) {
                      final isRecording = snapshot.data == RecordState.record;
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        setDialogState(() {});
                      });
                      return Text(
                        isRecording ? '● 录音中...' : '○ 已停止',
                        style: TextStyle(
                          color: isRecording ? Colors.red : Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    _stopAndUploadRecording();
                  },
                  child: const Text(
                    '完成',
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint('录音启动失败: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('录音启动失败: $e'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _stopAndUploadRecording() async {
    try {
      if (_isRecording) {
        final path = await _audioRecorder.stop();
        setState(() {
          _isRecording = false;
        });

        final actualPath = path ?? _recordingPath;
        if (actualPath != null && File(actualPath).existsSync()) {
          debugPrint('录音完成: $actualPath');

          final file = File(actualPath);

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('录音完成，正在上传...'),
                duration: Duration(seconds: 2),
              ),
            );
          }

          final uploadUrl = await _buildRecordingUploadUrlWithAuth();
          debugPrint('录音上传 URL: $uploadUrl');

          final result = await _uploadFileToUEditor(
            file,
            uploadUrl,
            'recording',
            (progress) {
              debugPrint('录音上传进度: ${(progress * 100).toStringAsFixed(1)}%');
            },
            fieldName: 'file',
          );

          if (result != null && result['success'] == true) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('✅ 录音已上传并插入'),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          } else {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('❌ 录音上传失败'),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          }
        }
      }
    } catch (e) {
      debugPrint('录音上传失败: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('上传失败: $e'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<String> _buildRecordingUploadUrlWithAuth() async {
    try {
      final result = await _controller.runJavaScriptReturningResult('''
        (function() {
          var topWin = top.window || parent.window;
          var uid = topWin["uid"] || "";
          var currentTime = topWin["currentTime"] || "";
          var uploadEnc = topWin["uploadEnc"] || "";
          var uploadType = topWin["uploadType"] || "work";
          return JSON.stringify({enc2: uploadEnc, t: currentTime, uid: uid, uploadType: uploadType});
        })();
      ''');

      String enc2 = '';
      String t = '';
      String uid = '';
      String uploadType = 'work';

      try {
        var resultStr = result.toString();
        resultStr = resultStr.trim();
        if (resultStr.startsWith('"') && resultStr.endsWith('"')) {
          resultStr = resultStr.substring(1, resultStr.length - 1);
          resultStr = resultStr.replaceAll('\\"', '"');
        }
        debugPrint('JS返回认证参数: $resultStr');

        final data = jsonDecode(resultStr);
        enc2 = data['enc2'] ?? '';
        t = data['t'] ?? '';
        uid = data['uid'] ?? '';
        uploadType = data['uploadType'] ?? 'work';

        debugPrint(
          '解析认证参数: enc2=${enc2.length > 10 ? enc2.substring(0, 10) : enc2}..., t=$t, uid=$uid, uploadType=$uploadType',
        );
      } catch (e) {
        debugPrint('解析认证参数失败: $e');
      }

      var uploadUrl = 'https://mooc1.chaoxing.com/upload-ans/upload/uploadNew';

      if (enc2.isNotEmpty && t.isNotEmpty && uid.isNotEmpty) {
        uploadUrl +=
            '?t=${Uri.encodeComponent(t)}&enc2=${Uri.encodeComponent(enc2)}&userId=${Uri.encodeComponent(uid)}&uploadtype=${Uri.encodeComponent(uploadType)}';
        debugPrint('录音上传认证参数已添加');
      } else {
        debugPrint('录音上传缺少认证参数');
      }

      debugPrint('录音上传 URL: $uploadUrl');
      return uploadUrl;
    } catch (e) {
      debugPrint('构建录音上传 URL 失败: $e');
      return 'https://mooc1.chaoxing.com/upload-ans/upload/uploadNew';
    }
  }

  String _buildWorkUrl() {
    if (widget.taskUrl.isNotEmpty) {
      return widget.taskUrl;
    }

    const baseUrl = 'https://mooc2-ans.chaoxing.com/mooc2-ans/work/list';
    final params = <String, String>{
      'courseId': widget.courseId,
      'classId': widget.classId,
      'cpi': widget.cpi,
      'workId': widget.workId,
      'enc': widget.enc,
    };

    if (widget.answerId.isNotEmpty) {
      params['answerId'] = widget.answerId;
    }

    final queryString = params.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');

    return '$baseUrl?$queryString';
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('作业作答'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _controller.reload();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          if (_controllerReady)
            WebViewWidget(controller: _controller)
          else
            const Center(child: CircularProgressIndicator()),
          if (_loading)
            Container(
              color: Colors.white,
              child: const Center(child: CircularProgressIndicator()),
            ),
          if (_hasError)
            Container(
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    Text(_errorMessage),
                    const SizedBox(height: 16),
                    FilledButton.tonal(
                      onPressed: () {
                        setState(() {
                          _hasError = false;
                          _loading = true;
                        });
                        _initWebView();
                      },
                      child: const Text('重试'),
                    ),
                  ],
                ),
              ),
            ),
          if (_isLoginPage)
            Container(
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      size: 64,
                      color: Colors.orange,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '请重新打开该页面',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
