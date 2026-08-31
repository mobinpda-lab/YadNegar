package com.mobinpda.lab.yadnegar

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.view.View
import android.widget.RemoteViews
import android.widget.RemoteViewsService
import org.json.JSONArray

class YadNegarWidgetRemoteViewsService : RemoteViewsService() {
    override fun onGetViewFactory(intent: Intent): RemoteViewsFactory {
        return Factory(applicationContext, intent.getIntExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, AppWidgetManager.INVALID_APPWIDGET_ID))
    }

    private class Factory(
        private val context: Context,
        private val widgetId: Int,
    ) : RemoteViewsFactory {
        private var items: List<Row> = emptyList()

        override fun onCreate() = reload()
        override fun onDataSetChanged() = reload()
        override fun onDestroy() { items = emptyList() }
        override fun getCount(): Int = items.size
        override fun getLoadingView(): RemoteViews? = null
        override fun getViewTypeCount(): Int = 1
        override fun getItemId(position: Int): Long = items[position].id.hashCode().toLong()
        override fun hasStableIds(): Boolean = true

        override fun getViewAt(position: Int): RemoteViews? {
            if (position !in items.indices) return null
            val item = items[position]
            return RemoteViews(context.packageName, R.layout.yadnegar_widget_row).apply {
                setTextViewText(R.id.widget_row_title, item.text)
                setTextViewText(R.id.widget_row_time, item.whenText)
                setViewVisibility(R.id.widget_row_time, if (item.whenText.isBlank()) View.GONE else View.VISIBLE)
                setOnClickFillInIntent(
                    R.id.widget_row_title,
                    Intent().putExtra(MainActivity.EXTRA_WIDGET_TASK_ID, item.id),
                )
                setOnClickFillInIntent(
                    R.id.widget_row_time,
                    Intent().putExtra(MainActivity.EXTRA_WIDGET_TASK_ID, item.id),
                )
            }
        }

        private fun reload() {
            val prefs = context.getSharedPreferences(YadNegarWidgetConfigureActivity.PREFS, Context.MODE_PRIVATE)
            val raw = prefs.getString("render_tasks_$widgetId", "[]").orEmpty()
            items = runCatching {
                val array = JSONArray(raw)
                buildList {
                    for (index in 0 until array.length()) {
                        val item = array.optJSONObject(index) ?: continue
                        val id = item.optString("id").trim()
                        val text = item.optString("text").trim()
                        if (id.isEmpty() || text.isEmpty()) continue
                        add(Row(id, text, item.optString("whenText").trim()))
                    }
                }
            }.getOrDefault(emptyList())
        }

        private data class Row(val id: String, val text: String, val whenText: String)
    }
}
