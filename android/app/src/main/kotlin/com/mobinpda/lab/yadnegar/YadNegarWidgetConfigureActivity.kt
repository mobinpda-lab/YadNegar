package com.mobinpda.lab.yadnegar

import android.app.Activity
import android.appwidget.AppWidgetManager
import android.content.Intent
import android.graphics.Color
import android.os.Bundle
import android.view.Gravity
import android.view.ViewGroup
import android.widget.Button
import android.widget.LinearLayout
import android.widget.RadioButton
import android.widget.RadioGroup
import android.widget.SeekBar
import android.widget.TextView

class YadNegarWidgetConfigureActivity : Activity() {
    private var appWidgetId = AppWidgetManager.INVALID_APPWIDGET_ID

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setResult(RESULT_CANCELED)
        appWidgetId = intent?.extras?.getInt(
            AppWidgetManager.EXTRA_APPWIDGET_ID,
            AppWidgetManager.INVALID_APPWIDGET_ID,
        ) ?: AppWidgetManager.INVALID_APPWIDGET_ID
        if (appWidgetId == AppWidgetManager.INVALID_APPWIDGET_ID) {
            finish()
            return
        }

        val density = resources.displayMetrics.density
        val root = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            layoutDirection = LinearLayout.LAYOUT_DIRECTION_RTL
            setPadding((20 * density).toInt(), (24 * density).toInt(), (20 * density).toInt(), (20 * density).toInt())
            setBackgroundColor(Color.WHITE)
        }
        root.addView(TextView(this).apply {
            text = "تنظیمات ویجت یادنگار"
            textSize = 22f
            setTextColor(Color.BLACK)
            gravity = Gravity.RIGHT
        })
        root.addView(TextView(this).apply {
            text = "نمایش کارها بر اساس زمان"
            textSize = 15f
            setTextColor(Color.DKGRAY)
            setPadding(0, (20 * density).toInt(), 0, (8 * density).toInt())
        })

        val timeGroup = RadioGroup(this).apply { orientation = RadioGroup.VERTICAL }
        val today = RadioButton(this).apply { text = "امروز"; id = 1001 }
        val week = RadioButton(this).apply { text = "هفته جاری"; id = 1002 }
        val all = RadioButton(this).apply { text = "همه"; id = 1003 }
        timeGroup.addView(today)
        timeGroup.addView(week)
        timeGroup.addView(all)
        today.isChecked = true
        root.addView(timeGroup)

        val countLabel = TextView(this).apply {
            text = "تعداد کارهای قابل نمایش: ۶"
            textSize = 15f
            setTextColor(Color.DKGRAY)
            setPadding(0, (18 * density).toInt(), 0, (6 * density).toInt())
        }
        root.addView(countLabel)
        val countSeek = SeekBar(this).apply {
            max = 12
            progress = 3
            setOnSeekBarChangeListener(object : SeekBar.OnSeekBarChangeListener {
                override fun onProgressChanged(seekBar: SeekBar?, progress: Int, fromUser: Boolean) {
                    countLabel.text = "تعداد کارهای قابل نمایش: ${progress + 3}"
                }
                override fun onStartTrackingTouch(seekBar: SeekBar?) = Unit
                override fun onStopTrackingTouch(seekBar: SeekBar?) = Unit
            })
        }
        root.addView(countSeek)

        root.addView(TextView(this).apply {
            text = "فیلتر پروژه، دسته‌بندی و تگ پس از همگام‌سازی داده‌های همان کارها در این صفحه فعال می‌شود."
            textSize = 13f
            setTextColor(Color.GRAY)
            setPadding(0, (16 * density).toInt(), 0, (16 * density).toInt())
        })

        root.addView(Button(this).apply {
            text = "ذخیره"
            setOnClickListener {
                val mode = when (timeGroup.checkedRadioButtonId) {
                    1002 -> "week"
                    1003 -> "all"
                    else -> "today"
                }
                getSharedPreferences(PREFS, MODE_PRIVATE).edit()
                    .putString("time_filter_$appWidgetId", mode)
                    .putInt("item_count_$appWidgetId", countSeek.progress + 3)
                    .apply()
                YadNegarWidgetProvider.update(this@YadNegarWidgetConfigureActivity, appWidgetId)
                setResult(
                    RESULT_OK,
                    Intent().putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId),
                )
                finish()
            }
        }, LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT))

        setContentView(root)
    }

    companion object {
        const val PREFS = "yadnegar_widget_preferences"
    }
}
