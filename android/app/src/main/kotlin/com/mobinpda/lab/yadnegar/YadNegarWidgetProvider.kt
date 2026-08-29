package com.mobinpda.lab.yadnegar

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews

class YadNegarWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(context: Context, manager: AppWidgetManager, ids: IntArray) {
        ids.forEach { update(context, it) }
    }

    companion object {
        fun update(context: Context, widgetId: Int) {
            val manager = AppWidgetManager.getInstance(context)
            val views = RemoteViews(context.packageName, R.layout.yadnegar_widget)
            val prefs = context.getSharedPreferences(
                YadNegarWidgetConfigureActivity.PREFS,
                Context.MODE_PRIVATE,
            )
            val mode = prefs.getString("time_filter_$widgetId", "today")
            val label = when (mode) {
                "week" -> "هفته جاری"
                "all" -> "همه کارها"
                else -> "امروز"
            }
            views.setTextViewText(R.id.widget_header, "یادنگار · $label")
            val openApp = Intent(context, MainActivity::class.java)
            val pendingIntent = PendingIntent.getActivity(
                context,
                widgetId,
                openApp,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
            )
            views.setOnClickPendingIntent(R.id.widget_header, pendingIntent)
            manager.updateAppWidget(widgetId, views)
        }
    }
}
