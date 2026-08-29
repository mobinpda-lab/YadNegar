package com.mobinpda.lab.yadnegar

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.view.View
import android.widget.RemoteViews
import org.json.JSONObject
import java.util.Calendar
import java.util.Date

class YadNegarWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(context: Context, manager: AppWidgetManager, ids: IntArray) {
        ids.forEach { update(context, it) }
    }

    companion object {
        fun updateAll(context: Context) {
            val manager = AppWidgetManager.getInstance(context)
            val ids = manager.getAppWidgetIds(ComponentName(context, YadNegarWidgetProvider::class.java))
            ids.forEach { update(context, it) }
        }

        fun update(context: Context, widgetId: Int) {
            val manager = AppWidgetManager.getInstance(context)
            val views = RemoteViews(context.packageName, R.layout.yadnegar_widget)
            val prefs = context.getSharedPreferences(YadNegarWidgetConfigureActivity.PREFS, Context.MODE_PRIVATE)
            val mode = prefs.getString("time_filter_$widgetId", "today")
            val count = prefs.getInt("item_count_$widgetId", 6).coerceIn(3, 15)
            val label = when (mode) {
                "week" -> "هفته جاری"
                "all" -> "همه کارها"
                else -> "امروز"
            }
            views.setTextViewText(R.id.widget_header, "یادنگار · $label")

            val projectionRaw = context.getSharedPreferences(MainActivity.PROJECTION_PREFS, Context.MODE_PRIVATE)
                .getString(MainActivity.PROJECTION_JSON, null)
            val tasks = mutableListOf<Pair<String, String>>()
            if (!projectionRaw.isNullOrBlank()) {
                runCatching {
                    val items = JSONObject(projectionRaw).optJSONArray("items") ?: return@runCatching
                    for (index in 0 until items.length()) {
                        val item = items.optJSONObject(index) ?: continue
                        if (!matchesTime(item, mode)) continue
                        val id = item.optString("id").trim()
                        val text = item.optString("text").trim()
                        if (id.isNotEmpty() && text.isNotEmpty()) tasks.add(id to text)
                        if (tasks.size >= count) break
                    }
                }
            }

            if (tasks.isEmpty()) {
                views.setViewVisibility(R.id.widget_tasks, View.GONE)
                views.setViewVisibility(R.id.widget_empty, View.VISIBLE)
                views.setTextViewText(R.id.widget_empty, "کاری برای $label نیست")
            } else {
                views.setViewVisibility(R.id.widget_tasks, View.VISIBLE)
                views.setViewVisibility(R.id.widget_empty, View.GONE)
                views.setTextViewText(R.id.widget_tasks, tasks.joinToString("\n") { "• ${it.second}" })
                val firstTask = Intent(context, MainActivity::class.java).apply {
                    putExtra(MainActivity.EXTRA_WIDGET_TASK_ID, tasks.first().first)
                    flags = Intent.FLAG_ACTIVITY_SINGLE_TOP or Intent.FLAG_ACTIVITY_CLEAR_TOP
                }
                views.setOnClickPendingIntent(
                    R.id.widget_tasks,
                    PendingIntent.getActivity(
                        context,
                        widgetId + 10000,
                        firstTask,
                        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
                    ),
                )
            }

            val openApp = Intent(context, MainActivity::class.java)
            views.setOnClickPendingIntent(
                R.id.widget_header,
                PendingIntent.getActivity(
                    context,
                    widgetId,
                    openApp,
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
                ),
            )
            manager.updateAppWidget(widgetId, views)
        }

        private fun matchesTime(item: JSONObject, mode: String?): Boolean {
            if (mode == "all") return true
            val raw = item.optString("nextActionAt").ifBlank { item.optString("timelineAt") }
            val instant = runCatching { Date.from(java.time.Instant.parse(raw)) }.getOrNull() ?: return false
            val target = Calendar.getInstance().apply { time = instant }
            val today = Calendar.getInstance()
            if (mode == "today") {
                return target.get(Calendar.ERA) == today.get(Calendar.ERA) &&
                    target.get(Calendar.YEAR) == today.get(Calendar.YEAR) &&
                    target.get(Calendar.DAY_OF_YEAR) == today.get(Calendar.DAY_OF_YEAR)
            }
            val firstDay = today.clone() as Calendar
            firstDay.firstDayOfWeek = Calendar.SATURDAY
            firstDay.set(Calendar.DAY_OF_WEEK, Calendar.SATURDAY)
            firstDay.set(Calendar.HOUR_OF_DAY, 0)
            firstDay.set(Calendar.MINUTE, 0)
            firstDay.set(Calendar.SECOND, 0)
            firstDay.set(Calendar.MILLISECOND, 0)
            val lastDay = firstDay.clone() as Calendar
            lastDay.add(Calendar.DAY_OF_YEAR, 7)
            return !target.before(firstDay) && target.before(lastDay)
        }
    }
}
