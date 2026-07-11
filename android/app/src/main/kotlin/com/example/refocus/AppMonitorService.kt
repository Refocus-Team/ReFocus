package com.example.refocus

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import java.util.HashMap
import android.app.usage.UsageStatsManager
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.provider.Settings
import android.util.Log
import android.view.Gravity
import android.view.MotionEvent
import android.view.View
import android.view.WindowManager
import android.widget.FrameLayout
import android.widget.ImageView
import java.util.Calendar

class AppMonitorService : Service() {
    private val handler = Handler(Looper.getMainLooper())
    private var targetPackages: List<String> = emptyList()
    private var timeLimits: Map<String, Int> = emptyMap()

    private var windowManager: WindowManager? = null
    private var floatingView: View? = null
    private var isFloatingViewAdded = false

    private val checkRunnable = object : Runnable {
        override fun run() {
            checkScreenTime()
            handler.postDelayed(this, 3000)
        }
    }

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
    }

    @Suppress("DEPRECATION")
    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        if (intent != null) {
            targetPackages = intent.getStringArrayListExtra("packages") ?: emptyList()
            val raw = intent.getSerializableExtra("timeLimits") as? HashMap<String, Int>
            timeLimits = raw ?: emptyMap()
        }

        startForegroundServiceNotification()
        handler.removeCallbacks(checkRunnable)
        handler.post(checkRunnable)

        return START_STICKY
    }

    override fun onDestroy() {
        handler.removeCallbacks(checkRunnable)
        hideFloatingWidget()
        super.onDestroy()
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    private fun getDailyUsageStats(): Map<String, Long> {
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

    private fun checkScreenTime() {
        val usageStatsManager = getSystemService(Context.USAGE_STATS_SERVICE) as? UsageStatsManager ?: return
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
        ) ?: return

        var isAnyTargetAppActive = false

        for (packageName in targetPackages) {
            var timeInForegroundMs = 0L
            for (stat in usageStats) {
                if (stat.packageName == packageName) {
                    timeInForegroundMs += stat.totalTimeInForeground
                }
            }
            val timeInMinutes = timeInForegroundMs / 1000 / 60
            val appLimit = timeLimits[packageName] ?: 15

            if (isAppInForeground(packageName)) {
                isAnyTargetAppActive = true

                if (timeInMinutes >= appLimit) {
                    handler.post { hideFloatingWidget() }
                    
                    val broadcastIntent = Intent("com.example.refocus.LIMIT_REACHED").apply {
                        putExtra("packageName", packageName)
                    }
                    sendBroadcast(broadcastIntent)

                    val launchIntent = Intent(this, MainActivity::class.java).apply {
                        addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                        addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP)
                    }
                    startActivity(launchIntent)
                    break
                }
            }
        }

        // Kirim usage stats update ke Flutter via broadcast
        val allStats = getDailyUsageStats()
        val statsMap = HashMap<String, Long>(allStats)
        val statsIntent = Intent("com.example.refocus.USAGE_STATS_UPDATE").apply {
            putExtra("stats", statsMap)
        }
        sendBroadcast(statsIntent)

        val hasOverlayPermission = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            Settings.canDrawOverlays(this)
        } else {
            true
        }

        if (isAnyTargetAppActive && hasOverlayPermission) {
            handler.post { showFloatingWidget() }
        } else {
            handler.post { hideFloatingWidget() }
        }
    }

    private fun isAppInForeground(packageName: String): Boolean {
        val usageStatsManager = getSystemService(Context.USAGE_STATS_SERVICE) as? UsageStatsManager ?: return false
        val time = System.currentTimeMillis()
        val stats = usageStatsManager.queryUsageStats(
            UsageStatsManager.INTERVAL_DAILY,
            time - 10000, // last 10 seconds
            time
        )
        if (stats != null && stats.isNotEmpty()) {
            var activeStat: android.app.usage.UsageStats? = null
            for (stat in stats) {
                if (activeStat == null || stat.lastTimeUsed > activeStat.lastTimeUsed) {
                    activeStat = stat
                }
            }
            return activeStat?.packageName == packageName
        }
        return false
    }

    private fun showFloatingWidget() {
        if (isFloatingViewAdded) return

        val context = this
        windowManager = getSystemService(Context.WINDOW_SERVICE) as WindowManager

        val imageView = ImageView(context).apply {
            val resId = resources.getIdentifier("floating_icon", "drawable", packageName)
            if (resId != 0) {
                setImageResource(resId)
            } else {
                setImageResource(android.R.drawable.ic_lock_idle_lock)
            }
            scaleType = ImageView.ScaleType.FIT_CENTER
        }

        val layout = FrameLayout(context).apply {
            addView(imageView)
        }

        floatingView = layout

        val density = resources.displayMetrics.density
        val size = (60 * density).toInt() // 60dp size

        val layoutType = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
        } else {
            @Suppress("DEPRECATION")
            WindowManager.LayoutParams.TYPE_PHONE
        }

        val params = WindowManager.LayoutParams(
            size,
            size,
            layoutType,
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS,
            android.graphics.PixelFormat.TRANSLUCENT
        ).apply {
            gravity = Gravity.TOP or Gravity.START
            x = 0
            y = (resources.displayMetrics.heightPixels * 0.3).toInt() // 30% from top
        }

        var initialX = 0
        var initialY = 0
        var initialTouchX = 0f
        var initialTouchY = 0f
        var lastTouchTime = System.currentTimeMillis()

        val fadeRunnable = Runnable {
            floatingView?.alpha = 0.5f
        }

        val resetFadeTimer = {
            floatingView?.alpha = 1.0f
            handler.removeCallbacks(fadeRunnable)
            handler.postDelayed(fadeRunnable, 3000)
        }

        resetFadeTimer()

        floatingView?.setOnTouchListener(object : View.OnTouchListener {
            override fun onTouch(v: View?, event: MotionEvent?): Boolean {
                if (event == null) return false
                resetFadeTimer()

                when (event.action) {
                    MotionEvent.ACTION_DOWN -> {
                        initialX = params.x
                        initialY = params.y
                        initialTouchX = event.rawX
                        initialTouchY = event.rawY
                        lastTouchTime = System.currentTimeMillis()
                        return true
                    }
                    MotionEvent.ACTION_MOVE -> {
                        params.x = initialX + (event.rawX - initialTouchX).toInt()
                        params.y = initialY + (event.rawY - initialTouchY).toInt()
                        windowManager?.updateViewLayout(floatingView, params)
                        return true
                    }
                    MotionEvent.ACTION_UP -> {
                        val diffX = event.rawX - initialTouchX
                        val diffY = event.rawY - initialTouchY
                        val duration = System.currentTimeMillis() - lastTouchTime

                        // Click action (On Tap)
                        if (Math.abs(diffX) < 10 && Math.abs(diffY) < 10 && duration < 200) {
                            hideFloatingWidget()
                            val launchIntent = Intent(context, MainActivity::class.java).apply {
                                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                                addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP)
                                addFlags(Intent.FLAG_ACTIVITY_REORDER_TO_FRONT)
                            }
                            startActivity(launchIntent)
                            return true
                        }

                        // Snap to Edge logic
                        val screenWidth = resources.displayMetrics.widthPixels
                        val middle = screenWidth / 2
                        val targetX = if (params.x + size / 2 < middle) {
                            0
                        } else {
                            screenWidth - size
                        }

                        params.x = targetX
                        windowManager?.updateViewLayout(floatingView, params)
                        return true
                    }
                }
                return false
            }
        })

        try {
            windowManager?.addView(floatingView, params)
            isFloatingViewAdded = true
        } catch (e: Exception) {
            Log.e("AppMonitorService", "Failed to add overlay view", e)
        }
    }

    private fun hideFloatingWidget() {
        if (isFloatingViewAdded && floatingView != null) {
            try {
                windowManager?.removeView(floatingView)
            } catch (e: Exception) {
                Log.e("AppMonitorService", "Failed to remove overlay view", e)
            }
            isFloatingViewAdded = false
            floatingView = null
        }
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                "AppMonitorServiceChannel",
                "ReFocus App Monitor",
                NotificationManager.IMPORTANCE_LOW
            )
            val manager = getSystemService(NotificationManager::class.java)
            manager?.createNotificationChannel(channel)
        }
    }

    private fun startForegroundServiceNotification() {
        val notificationIntent = Intent(this, MainActivity::class.java)
        val pendingIntent = PendingIntent.getActivity(
            this,
            0,
            notificationIntent,
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) PendingIntent.FLAG_IMMUTABLE else 0
        )

        val notificationBuilder = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Notification.Builder(this, "AppMonitorServiceChannel")
        } else {
            Notification.Builder(this)
        }

        val notification = notificationBuilder
            .setContentTitle("ReFocus Active")
            .setContentText("Monitoring screen time limits...")
            .setSmallIcon(android.R.drawable.ic_lock_idle_lock)
            .setContentIntent(pendingIntent)
            .build()

        startForeground(1, notification)
    }
}
