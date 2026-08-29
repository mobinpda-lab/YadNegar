package com.mobinpda.lab.yadnegar

import android.content.Context
import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.json.JSONArray
import org.json.JSONObject

class MainActivity : FlutterActivity() {
    private val channelName = "com.mobinpda.lab.yadnegar/widget"
    private var channel: MethodChannel? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName).apply {
            setMethodCallHandler { call, result ->
                when (call.method) {
                    "writeProjection" -> {
                        val projection = call.arguments as? Map<*, *>
                        if (projection == null) {
                            result.error("invalid_projection", "Widget projection is missing.", null)
                            return@setMethodCallHandler
                        }
                        writeProjection(projection)
                        YadNegarWidgetProvider.updateAll(this@MainActivity)
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
        }
        channel?.invokeMethod("refreshProjection", null)
        deliverWidgetIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        deliverWidgetIntent(intent)
    }

    private fun writeProjection(projection: Map<*, *>) {
        val json = JSONObject()
        json.put("items", JSONArray(projection["items"] as? List<*> ?: emptyList<Any>()))
        json.put("projects", JSONArray(projection["projects"] as? List<*> ?: emptyList<Any>()))
        json.put("categories", JSONArray(projection["categories"] as? List<*> ?: emptyList<Any>()))
        json.put("tags", JSONArray(projection["tags"] as? List<*> ?: emptyList<Any>()))
        getSharedPreferences(PROJECTION_PREFS, Context.MODE_PRIVATE)
            .edit()
            .putString(PROJECTION_JSON, json.toString())
            .apply()
    }

    private fun deliverWidgetIntent(intent: Intent?) {
        val taskId = intent?.getStringExtra(EXTRA_WIDGET_TASK_ID)?.trim().orEmpty()
        if (taskId.isNotEmpty()) channel?.invokeMethod("openTask", taskId)
    }

    companion object {
        const val EXTRA_WIDGET_TASK_ID = "yadnegar_widget_task_id"
        const val PROJECTION_PREFS = "yadnegar_widget_projection"
        const val PROJECTION_JSON = "projection_json"
    }
}
