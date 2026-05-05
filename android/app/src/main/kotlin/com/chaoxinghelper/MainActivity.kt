package com.chaoxinghelper

import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.view.View
import android.view.ViewGroup
import android.webkit.WebSettings
import android.webkit.WebView
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.chaoxinghelper/webview"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // 同意百度定位 SDK 隐私政策
        try {
            val locationClientClass = Class.forName("com.baidu.location.LocationClient")
            val setAgreePrivacyMethod = locationClientClass.getMethod("setAgreePrivacy", Boolean::class.javaPrimitiveType)
            setAgreePrivacyMethod.invoke(null, true)
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "enableMixedContent" -> {
                    Handler(Looper.getMainLooper()).post {
                        enableMixedContentForAllWebViews()
                    }
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun enableMixedContentForAllWebViews() {
        try {
            val webViews = findAllWebViews(window.decorView)
            for (webView in webViews) {
                val settings = webView.settings
                settings.mixedContentMode = WebSettings.MIXED_CONTENT_ALWAYS_ALLOW
                android.util.Log.d("MainActivity", "Enabled mixed content for WebView: \${webView}")
            }
            if (webViews.isEmpty()) {
                android.util.Log.d("MainActivity", "No WebView found yet, will retry")
                Handler(Looper.getMainLooper()).postDelayed({ enableMixedContentForAllWebViews() }, 500)
            }
        } catch (e: Exception) {
            android.util.Log.e("MainActivity", "Failed to enable mixed content", e)
        }
    }

    private fun findAllWebViews(root: View): List<WebView> {
        val webViews = mutableListOf<WebView>()
        if (root is WebView) {
            webViews.add(root)
        }
        if (root is ViewGroup) {
            for (i in 0 until root.childCount) {
                webViews.addAll(findAllWebViews(root.getChildAt(i)))
            }
        }
        return webViews
    }

    companion object {
        init {
            WebView.setWebContentsDebuggingEnabled(true)
        }
    }
}