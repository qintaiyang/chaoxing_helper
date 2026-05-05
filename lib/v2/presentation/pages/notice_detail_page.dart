import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../domain/entities/user_notice.dart';
import '../pages/homework_webview_page.dart';
import '../pages/exam_webview_page.dart';

class UserNoticeDetailPage extends StatefulWidget {
  final UserNotice notice;

  const UserNoticeDetailPage({super.key, required this.notice});

  @override
  State<UserNoticeDetailPage> createState() => _UserNoticeDetailPageState();
}

class _UserNoticeDetailPageState extends State<UserNoticeDetailPage> {
  late WebViewController _webViewController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() => _isLoading = true);
          },
          onPageFinished: (String url) {
            setState(() => _isLoading = false);
          },
        ),
      )
      ..loadHtmlString(_buildHtmlContent());
  }

  UserNoticeAttachment? _getWorkAttachment() {
    for (final attachment in widget.notice.attachments) {
      if (attachment.isHomework || attachment.isExam) {
        return attachment;
      }
    }
    return null;
  }

  void _openHomework(UserNoticeAttachment attachment) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeworkWebViewPage(
          workId: attachment.examOrWorkId,
          courseId: attachment.courseId,
          classId: attachment.clazzId,
          cpi: '',
          enc: '',
          answerId: '',
          taskUrl: attachment.url,
        ),
      ),
    );
  }

  void _openExam(UserNoticeAttachment attachment) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExamWebViewPage(
          courseId: attachment.courseId,
          classId: attachment.clazzId,
          cpi: '',
          examId: attachment.examOrWorkId,
          examTitle: attachment.title,
        ),
      ),
    );
  }

  String _buildHtmlContent() {
    final content = widget.notice.rtfContent.isNotEmpty
        ? widget.notice.rtfContent
        : _escapeHtml(widget.notice.content);

    return '''
    <!DOCTYPE html>
    <html>
    <head>
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <style>
        body {
          font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
          padding: 16px;
          margin: 0;
          line-height: 1.6;
          color: #1D2129;
        }
        .header {
          padding-bottom: 16px;
          border-bottom: 1px solid #E5E6EB;
          margin-bottom: 16px;
        }
        .title {
          font-size: 20px;
          font-weight: 600;
          margin-bottom: 8px;
        }
        .meta {
          font-size: 12px;
          color: #86909C;
        }
        .content {
          font-size: 16px;
        }
        .content img {
          max-width: 100%;
          height: auto;
        }
      </style>
    </head>
    <body>
      <div class="header">
        <div class="title">${_escapeHtml(widget.notice.title)}</div>
        <div class="meta">
          ${_escapeHtml(widget.notice.createrName)} · ${_escapeHtml(widget.notice.getTimeDescription())}
        </div>
      </div>
      <div class="content">
        $content
      </div>
    </body>
    </html>
    ''';
  }

  static String _escapeHtml(String input) {
    return input
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#39;');
  }

  @override
  Widget build(BuildContext context) {
    final workAttachment = _getWorkAttachment();
    final isHomework = workAttachment?.isHomework ?? false;
    final isExam = workAttachment?.isExam ?? false;

    String buttonText;
    if (isHomework) {
      buttonText = '前往作答';
    } else if (isExam) {
      buttonText = '开始考试';
    } else {
      buttonText = '查看附件';
    }

    IconData buttonIcon;
    if (isHomework) {
      buttonIcon = Icons.assignment;
    } else if (isExam) {
      buttonIcon = Icons.menu_book;
    } else {
      buttonIcon = Icons.attach_file;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('通知详情'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(child: WebViewWidget(controller: _webViewController)),
                if (workAttachment != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      top: false,
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (isHomework) {
                              _openHomework(workAttachment);
                            } else if (isExam) {
                              _openExam(workAttachment);
                            } else {
                              _openAttachment(context, workAttachment);
                            }
                          },
                          icon: Icon(buttonIcon),
                          label: Text(buttonText),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }

  void _openAttachment(BuildContext context, UserNoticeAttachment attachment) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('附件详情'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('标题: ${attachment.title}'),
            const SizedBox(height: 8),
            Text('大小: ${attachment.size}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }
}
