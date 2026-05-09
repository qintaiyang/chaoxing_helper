package com.chaoxinghelper

import android.app.Dialog
import android.content.ComponentName
import android.content.Intent
import android.content.pm.ShortcutInfo
import android.content.pm.ShortcutManager
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Color
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.ColorDrawable
import android.graphics.drawable.Icon
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.view.View
import android.view.ViewGroup
import android.view.WindowManager
import android.webkit.WebSettings
import android.webkit.WebView
import android.widget.ImageView
import android.widget.LinearLayout
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import java.io.File

class MainActivity: FlutterActivity() {
    private val WEBVIEW_CHANNEL = "com.chaoxinghelper/webview"
    private val ICON_CHANNEL = "com.chaoxinghelper/icon_manager"
    private val shortcutId = "custom_launcher_shortcut"
    private var customSplashDialog: Dialog? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        showCustomSplash()
        try {
            val locationClientClass = Class.forName("com.baidu.location.LocationClient")
            val setAgreePrivacyMethod = locationClientClass.getMethod("setAgreePrivacy", Boolean::class.javaPrimitiveType)
            setAgreePrivacyMethod.invoke(null, true)
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    override fun onFlutterUiDisplayed() {
        dismissCustomSplash()
    }

    private fun showCustomSplash() {
        try {
            val splashFile = File(filesDir, "custom_splash_native/splash.png")
            if (!splashFile.exists()) return

            val dialog = Dialog(this, android.R.style.Theme_Black_NoTitleBar_Fullscreen)
            dialog.setContentView(R.layout.custom_splash)
            dialog.window?.apply {
                setLayout(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT)
                setBackgroundDrawable(ColorDrawable(Color.parseColor("#FF1B5E20")))
                addFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN)
            }
            dialog.setCancelable(false)

            val bitmap = BitmapFactory.decodeFile(splashFile.absolutePath)
            if (bitmap != null) {
                val imageView = dialog.findViewById<ImageView>(R.id.splash_image)
                imageView.setImageBitmap(bitmap)
                imageView.visibility = View.VISIBLE
                dialog.findViewById<LinearLayout>(R.id.splash_fallback)?.visibility = View.GONE
                dialog.window?.setBackgroundDrawable(ColorDrawable(Color.TRANSPARENT))
            }

            dialog.show()
            customSplashDialog = dialog
            android.util.Log.d("MainActivity", "自定义启动图已显示")
        } catch (e: Exception) {
            android.util.Log.e("MainActivity", "显示自定义启动图失败", e)
        }
    }

    private fun dismissCustomSplash() {
        try {
            customSplashDialog?.dismiss()
            customSplashDialog = null
            android.util.Log.d("MainActivity", "自定义启动图已关闭")
        } catch (e: Exception) {
            android.util.Log.e("MainActivity", "关闭自定义启动图失败", e)
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, WEBVIEW_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "enableMixedContent" -> {
                    Handler(Looper.getMainLooper()).post { enableMixedContentForAllWebViews() }
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, ICON_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "pinCustomIcon" -> {
                    val iconPath = call.argument<String>("iconPath") ?: ""
                    val iconName = call.argument<String>("iconName") ?: "超星"
                    if (iconPath.isNotEmpty()) {
                        try {
                            pinCustomShortcut(iconPath, iconName)
                            result.success(true)
                        } catch (e: Exception) {
                            result.error("PIN_ERROR", e.message, null)
                        }
                    } else {
                        result.error("EMPTY_PATH", "路径为空", null)
                    }
                }
                "restoreDefaultIcon" -> {
                    try {
                        removeCustomShortcut()
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("RESTORE_ERROR", e.message, null)
                    }
                }
                "getCurrentIcon" -> result.success(getCurrentIconType())
                "updateSplashImage" -> {
                    val splashPath = call.argument<String>("splashPath") ?: ""
                    if (splashPath.isNotEmpty()) {
                        try {
                            copySplashImage(splashPath)
                            result.success(true)
                        } catch (e: Exception) {
                            result.error("SPLASH_UPDATE_ERROR", e.message, null)
                        }
                    } else {
                        result.error("EMPTY_PATH", "路径为空", null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun pinCustomShortcut(iconPath: String, iconName: String) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) throw Exception("需要 Android 8.0+")
        val sm = getSystemService(ShortcutManager::class.java)
        if (!sm.isRequestPinShortcutSupported) throw Exception("桌面不支持")

        val bitmap = BitmapFactory.decodeFile(iconPath) ?: throw Exception("解码失败")
        val resized = Bitmap.createScaledBitmap(bitmap, 192, 192, true)
        if (resized != bitmap) bitmap.recycle()

        val comp = ComponentName(packageName, "com.chaoxinghelper.MainActivity")
        val intent = Intent(Intent.ACTION_MAIN).apply {
            addCategory(Intent.CATEGORY_LAUNCHER)
            component = comp
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_RESET_TASK_IF_NEEDED
        }

        val shortcut = ShortcutInfo.Builder(this, shortcutId)
            .setShortLabel(iconName).setLongLabel(iconName)
            .setIcon(Icon.createWithBitmap(resized))
            .setIntent(intent).build()

        removeExistingShortcut(sm)
        sm.requestPinShortcut(shortcut, null)
    }

    private fun removeCustomShortcut() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            removeExistingShortcut(getSystemService(ShortcutManager::class.java))
        }
    }

    private fun removeExistingShortcut(sm: ShortcutManager) {
        try { for (si in sm.pinnedShortcuts) { if (si.id == shortcutId) sm.disableShortcuts(listOf(shortcutId)) } } catch (_: Exception) {}
    }

    private fun getCurrentIconType(): String {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            try { for (si in getSystemService(ShortcutManager::class.java).pinnedShortcuts) { if (si.id == shortcutId) return "custom" } } catch (_: Exception) {}
        }
        return "default"
    }

    private fun copySplashImage(sourcePath: String) {
        val f = File(sourcePath)
        if (!f.exists()) throw Exception("文件不存在")
        val dir = File(filesDir, "custom_splash_native")
        if (!dir.exists()) dir.mkdirs()
        f.copyTo(File(dir, "splash.png"), overwrite = true)
    }

    private fun enableMixedContentForAllWebViews() {
        try {
            val wvs = findAllWebViews(window.decorView)
            for (wv in wvs) wv.settings.mixedContentMode = WebSettings.MIXED_CONTENT_ALWAYS_ALLOW
            if (wvs.isEmpty()) Handler(Looper.getMainLooper()).postDelayed({ enableMixedContentForAllWebViews() }, 500)
        } catch (_: Exception) {}
    }

    private fun findAllWebViews(root: View): List<WebView> {
        val list = mutableListOf<WebView>()
        if (root is WebView) list.add(root)
        if (root is ViewGroup) for (i in 0 until root.childCount) list.addAll(findAllWebViews(root.getChildAt(i)))
        return list
    }

    companion object {
        init { WebView.setWebContentsDebuggingEnabled(true) }
    }
}
