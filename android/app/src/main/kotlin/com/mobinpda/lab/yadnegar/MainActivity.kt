package com.mobinpda.lab.yadnegar

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channelName = "com.mobinpda.lab.yadnegar/widget"
    private var channel: MethodChannel? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
        channel?.invokeMethod("refreshProjection", null)
        deliverWidgetIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        deliverWidgetIntent(intent)
    }

    private fun deliverWidgetIntent(intent: Intent?) {
        val taskId = intent?.getStringExtra(EXTRA_WIDGET_TASK_ID)?.trim().orEmpty()
        if (taskId.isNotEmpty()) {
            channel?.invokeMethod("openTask", taskId)
        }
    }

    companion object {
        const val EXTRA_WIDGET_TASK_ID = "yadnegar_widget_task_id"
    }
}
