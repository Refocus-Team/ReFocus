package com.example.refocus

import android.app.AppOpsManager
import android.app.usage.UsageStatsManager
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
import java.util.Calendar
import java.util.HashMap

class MainActivity : FlutterActivity() {
    private val METHOD_CHANNEL = "com.example.refocus/method"
    private val EVENT_CHANNEL = "com.example.refocus/event"
    private val USAGE_STATS_CHANNEL = "com.example.refocus/usage_stats"

    private var eventSink: EventChannel.EventSink? = null
    private var usageStatsSink: EventChannel.EventSink? = null
    private var limitReachedReceiver: BroadcastReceiver? = null
    private var usageStatsReceiver: BroadcastReceiver? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

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
                    val timeLimitsRaw = call.argument<Map<String, Int>>("timeLimits") ?: emptyMap()
                    val timeLimits = HashMap<String, Int>(timeLimitsRaw)
                    val intent = Intent(this, AppMonitorService::class.java).apply {
                        putStringArrayListExtra("packages", ArrayList(packages))
                        putExtra("timeLimits", timeLimits)
                    }
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        startForegroundService(intent)
                    } else {
                        startService(intent)
                    }
                    result.success(true)
                }
                "getUsageStats" -> {
                    val stats = getCurrentUsageStats()
                    result.success(stats)
                }
                "stopMonitoring" -> {
                    val intent = Intent(this, AppMonitorService::class.java)
                    stopService(intent)
                    result.success(true)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }

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
                    if (Build.VERSION.SDK_INT >= 33) {
                        registerReceiver(limitReachedReceiver, filter, 2)
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

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, USAGE_STATS_CHANNEL).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    usageStatsSink = events
                    usageStatsReceiver = object : BroadcastReceiver() {
                        @Suppress("DEPRECATION")
                        override fun onReceive(context: Context?, intent: Intent?) {
                            val stats = intent?.getSerializableExtra("stats") as? HashMap<String, Long>
                            if (stats != null) {
                                usageStatsSink?.success(stats)
                            }
                        }
                    }
                    val filter = IntentFilter("com.example.refocus.USAGE_STATS_UPDATE")
                    if (Build.VERSION.SDK_INT >= 33) {
                        registerReceiver(usageStatsReceiver, filter, 2)
                    } else {
                        registerReceiver(usageStatsReceiver, filter)
                    }
                }

                override fun onCancel(arguments: Any?) {
                    usageStatsReceiver?.let {
                        unregisterReceiver(it)
                    }
                    usageStatsReceiver = null
                    usageStatsSink = null
                }
            }
        )
    }

    fun sendUsageStatsUpdate(stats: Map<String, Long>) {
        usageStatsSink?.success(stats)
    }

    private fun getCurrentUsageStats(): Map<String, Long> {
        val usageStatsManager = getSystemService(Context.USAGE_STATS_SERVICE) as? UsageStatsManager ?: return emptyMap()
        val calendar = Calendar.getInstance()
        val endTime = calendar.timeInMillis
        calendar.set(Calendar.HOUR_OF_DAY, 0)
        calendar.set(Calendar.MINUTE, 0)
        calendar.set(Calendar.SECOND, 0)
        calendar.set(Calendar.MILLISECOND, 0)
        val startTime = calendar.timeInMillis
        val usageStats = usageStatsManager.queryUsageStats(
            UsageStatsManager.INTERVAL_DAILY,
            startTime,
            endTime
        ) ?: return emptyMap()
        val result = mutableMapOf<String, Long>()
        for (stat in usageStats) {
            val minutes = stat.totalTimeInForeground / 1000 / 60
            if (minutes > 0) {
                result[stat.packageName ?: ""] = minutes
            }
        }
        return result
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
