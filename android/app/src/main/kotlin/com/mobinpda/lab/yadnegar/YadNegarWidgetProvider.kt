package com.mobinpda.lab.yadnegar

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.view.View
import android.widget.RemoteViews
import org.json.JSONArray
import org.json.JSONObject
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Date
import java.util.Locale
import java.util.TimeZone

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
            val projectId = prefs.getString("project_filter_$widgetId", "").orEmpty()
            val categoryId = prefs.getString("category_filter_$widgetId", "").orEmpty()
            val tagId = prefs.getString("tag_filter_$widgetId", "").orEmpty()
            val count = prefs.getInt("item_count_$widgetId", 6).coerceIn(3, 15)
            val label = when (mode) {
                "week" -> "هفته جاری"
                "all" -> "همه کارها"
                else -> "امروز"
            }
            views.setTextViewText(R.id.widget_header, "یادنگار · $label")

            val projectionRaw = context.getSharedPreferences(MainActivity.PROJECTION_PREFS, Context.MODE_PRIVATE)
                .getString(MainActivity.PROJECTION_JSON, null)
            val tasks = mutableListOf<WidgetTask>()
            if (!projectionRaw.isNullOrBlank()) {
                runCatching {
                    val items = JSONObject(projectionRaw).optJSONArray("items") ?: return@runCatching
                    for (index in 0 until items.length()) {
                        val item = items.optJSONObject(index) ?: continue
                        if (!matchesTime(item, mode)) continue
                        if (!matchesTaxonomy(item, projectId, categoryId, tagId)) continue
                        val id = item.optString("id").trim()
                        val text = item.optString("text").trim()
                        val rawDate = item.optString("nextActionAt").ifBlank { item.optString("timelineAt") }
                        val whenText = parseIsoDate(rawDate)?.let(::formatPersianDateTime).orEmpty()
                        if (id.isNotEmpty() && text.isNotEmpty()) {
                            tasks.add(WidgetTask(id, text, whenText))
                        }
                        if (tasks.size >= count) break
                    }
                }
            }

            val renderRows = JSONArray()
            tasks.forEach { task ->
                renderRows.put(
                    JSONObject()
                        .put("id", task.id)
                        .put("text", task.text)
                        .put("whenText", task.whenText),
                )
            }
            prefs.edit().putString("render_tasks_$widgetId", renderRows.toString()).apply()

            val serviceIntent = Intent(context, YadNegarWidgetRemoteViewsService::class.java).apply {
                putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, widgetId)
                data = Uri.parse("yadnegar://widget/$widgetId/tasks")
            }
            views.setRemoteAdapter(R.id.widget_tasks, serviceIntent)
            views.setEmptyView(R.id.widget_tasks, R.id.widget_empty)

            val taskTemplate = Intent(context, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_SINGLE_TOP or Intent.FLAG_ACTIVITY_CLEAR_TOP
            }
            views.setPendingIntentTemplate(
                R.id.widget_tasks,
                PendingIntent.getActivity(
                    context,
                    widgetId + 10000,
                    taskTemplate,
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE,
                ),
            )

            if (tasks.isEmpty()) {
                views.setViewVisibility(R.id.widget_tasks, View.GONE)
                views.setViewVisibility(R.id.widget_empty, View.VISIBLE)
                views.setTextViewText(R.id.widget_empty, "کاری برای $label نیست")
            } else {
                views.setViewVisibility(R.id.widget_tasks, View.VISIBLE)
                views.setViewVisibility(R.id.widget_empty, View.GONE)
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
            manager.notifyAppWidgetViewDataChanged(widgetId, R.id.widget_tasks)
        }

        private fun matchesTaxonomy(item: JSONObject, projectId: String, categoryId: String, tagId: String): Boolean {
            if (projectId.isNotEmpty() && item.optString("projectId") != projectId) return false
            if (categoryId.isNotEmpty() && item.optString("categoryId") != categoryId) return false
            if (tagId.isNotEmpty()) {
                val tags = item.optJSONArray("tagIds") ?: return false
                var found = false
                for (index in 0 until tags.length()) {
                    if (tags.optString(index) == tagId) {
                        found = true
                        break
                    }
                }
                if (!found) return false
            }
            return true
        }

        private fun matchesTime(item: JSONObject, mode: String?): Boolean {
            if (mode == "all") return true
            val raw = item.optString("nextActionAt").ifBlank { item.optString("timelineAt") }
            val instant = parseIsoDate(raw) ?: return false
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

        private fun parseIsoDate(raw: String): Date? {
            if (raw.isBlank()) return null
            val normalized = raw.replace(Regex("([+-]\\d{2}):(\\d{2})$"), "$1$2")
            val patterns = listOf(
                "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'",
                "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",
                "yyyy-MM-dd'T'HH:mm:ss'Z'",
                "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ",
                "yyyy-MM-dd'T'HH:mm:ss.SSSZ",
                "yyyy-MM-dd'T'HH:mm:ssZ",
            )
            for (pattern in patterns) {
                val parsed = runCatching {
                    SimpleDateFormat(pattern, Locale.US).apply {
                        isLenient = false
                        timeZone = TimeZone.getTimeZone("UTC")
                    }.parse(normalized)
                }.getOrNull()
                if (parsed != null) return parsed
            }
            return null
        }

        private fun formatPersianDateTime(date: Date): String {
            val calendar = Calendar.getInstance().apply { time = date }
            val (jy, jm, jd) = gregorianToJalali(
                calendar.get(Calendar.YEAR),
                calendar.get(Calendar.MONTH) + 1,
                calendar.get(Calendar.DAY_OF_MONTH),
            )
            val hour = calendar.get(Calendar.HOUR_OF_DAY).toString().padStart(2, '0')
            val minute = calendar.get(Calendar.MINUTE).toString().padStart(2, '0')
            val text = "%04d/%02d/%02d %s:%s".format(Locale.US, jy, jm, jd, hour, minute)
            return toPersianDigits(text)
        }

        private fun gregorianToJalali(gyInput: Int, gm: Int, gd: Int): Triple<Int, Int, Int> {
            var gy = gyInput - 1600
            val gdm = intArrayOf(0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334)
            var days = 365 * gy + (gy + 3) / 4 - (gy + 99) / 100 + (gy + 399) / 400
            days += gdm[gm - 1] + gd - 1
            if (gm > 2 && ((gyInput % 4 == 0 && gyInput % 100 != 0) || gyInput % 400 == 0)) days += 1

            var jDays = days - 79
            val jNp = jDays / 12053
            jDays %= 12053
            var jy = 979 + 33 * jNp + 4 * (jDays / 1461)
            jDays %= 1461
            if (jDays >= 366) {
                jy += (jDays - 1) / 365
                jDays = (jDays - 1) % 365
            }
            val jm: Int
            val jd: Int
            if (jDays < 186) {
                jm = 1 + jDays / 31
                jd = 1 + jDays % 31
            } else {
                jm = 7 + (jDays - 186) / 30
                jd = 1 + (jDays - 186) % 30
            }
            return Triple(jy, jm, jd)
        }

        private fun toPersianDigits(value: String): String {
            val latin = "0123456789"
            val persian = "۰۱۲۳۴۵۶۷۸۹"
            return value.map { digit ->
                val index = latin.indexOf(digit)
                if (index >= 0) persian[index] else digit
            }.joinToString("")
        }

        private data class WidgetTask(val id: String, val text: String, val whenText: String)
    }
}
