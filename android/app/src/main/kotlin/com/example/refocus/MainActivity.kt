package com.example.refocus

import android.app.AppOpsManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Build
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val METHOD_CHANNEL = "com.example.refocus/method"
    private val EVENT_CHANNEL = "com.example.refocus/event"

    private var eventSink: EventChannel.EventSink? = null
    private var limitReachedReceiver: BroadcastReceiver? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Setup MethodChannel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, METHOD_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "checkUsagePermission" -> {
                    val granted = isUsagePermissionGranted()
                    if (!granted) {
                        val intent = Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS)
                        startActivity(intent)
                    }
                    result.success(granted)
                }
                "checkOverlayPermission" -> {
                    val granted = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                        Settings.canDrawOverlays(this)
                    } else {
                        true
                    }
                    if (!granted) {
                        val intent = Intent(
                            Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                            android.net.Uri.parse("package:$packageName")
                        )
                        startActivity(intent)
                    }
                    result.success(granted)
                }
                "startMonitoring" -> {
                    val packages = call.argument<List<String>>("packages") ?: emptyList()
                    val timeLimit = call.argument<Int>("timeLimitInMinutes") ?: 15
                    val intent = Intent(this, AppMonitorService::class.java).apply {
                        putStringArrayListExtra("packages", ArrayList(packages))
                        putExtra("timeLimitInMinutes", timeLimit)
                    }
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        startForegroundService(intent)
                    } else {
                        startService(intent)
                    }
                    result.success(true)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }

        // Setup EventChannel
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    eventSink = events
                    limitReachedReceiver = object : BroadcastReceiver() {
                        override fun onReceive(context: Context?, intent: Intent?) {
                            val pkg = intent?.getStringExtra("packageName") ?: ""
                            eventSink?.success(pkg)
                        }
                    }
                    val filter = IntentFilter("com.example.refocus.LIMIT_REACHED")
                    if (Build.VERSION.SDK_INT >= 33) { // 33 represents TIRAMISU
                        registerReceiver(limitReachedReceiver, filter, 2) // 2 represents RECEIVER_EXPORTED
                    } else {
                        registerReceiver(limitReachedReceiver, filter)
                    }
                }

                override fun onCancel(arguments: Any?) {
                    limitReachedReceiver?.let {
                        unregisterReceiver(it)
                    }
                    limitReachedReceiver = null
                    eventSink = null
                }
            }
        )
    }

    private fun isUsagePermissionGranted(): Boolean {
        val appOps = getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
        val mode = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            appOps.unsafeCheckOpNoThrow(
                AppOpsManager.OPSTR_GET_USAGE_STATS,
                android.os.Process.myUid(),
                packageName
            )
        } else {
            @Suppress("DEPRECATION")
            appOps.checkOpNoThrow(
                AppOpsManager.OPSTR_GET_USAGE_STATS,
                android.os.Process.myUid(),
                packageName
            )
        }
        return mode == AppOpsManager.MODE_ALLOWED
    }
}
