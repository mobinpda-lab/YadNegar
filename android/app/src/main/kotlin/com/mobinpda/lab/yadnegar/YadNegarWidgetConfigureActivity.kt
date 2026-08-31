package com.mobinpda.lab.yadnegar

import android.app.Activity
import android.appwidget.AppWidgetManager
import android.content.Intent
import android.graphics.Color
import android.os.Bundle
import android.view.Gravity
import android.view.ViewGroup
import android.widget.ArrayAdapter
import android.widget.Button
import android.widget.LinearLayout
import android.widget.RadioButton
import android.widget.RadioGroup
import android.widget.SeekBar
import android.widget.Spinner
import android.widget.TextView
import org.json.JSONObject

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

        val projectionRaw = getSharedPreferences(MainActivity.PROJECTION_PREFS, MODE_PRIVATE)
            .getString(MainActivity.PROJECTION_JSON, null)
        val projection = runCatching {
            if (projectionRaw.isNullOrBlank()) JSONObject() else JSONObject(projectionRaw)
        }.getOrElse { JSONObject() }

        val projectOptions = readOptions(projection, "projects", "همه پروژه‌ها")
        val categoryOptions = readOptions(projection, "categories", "همه دسته‌بندی‌ها")
        val tagOptions = readOptions(projection, "tags", "همه تگ‌ها")

        root.addView(sectionLabel("پروژه", density))
        val projectSpinner = createSpinner(projectOptions)
        root.addView(projectSpinner)

        root.addView(sectionLabel("دسته‌بندی", density))
        val categorySpinner = createSpinner(categoryOptions)
        root.addView(categorySpinner)

        root.addView(sectionLabel("تگ", density))
        val tagSpinner = createSpinner(tagOptions)
        root.addView(tagSpinner)

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
                    countLabel.text = "تعداد کارهای قابل نمایش: ${toPersianDigits((progress + 3).toString())}"
                }
                override fun onStartTrackingTouch(seekBar: SeekBar?) = Unit
                override fun onStopTrackingTouch(seekBar: SeekBar?) = Unit
            })
        }
        root.addView(countSeek)

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
                    .putString("project_filter_$appWidgetId", projectOptions[projectSpinner.selectedItemPosition].id)
                    .putString("category_filter_$appWidgetId", categoryOptions[categorySpinner.selectedItemPosition].id)
                    .putString("tag_filter_$appWidgetId", tagOptions[tagSpinner.selectedItemPosition].id)
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

    private fun sectionLabel(text: String, density: Float) = TextView(this).apply {
        this.text = text
        textSize = 14f
        setTextColor(Color.DKGRAY)
        setPadding(0, (14 * density).toInt(), 0, (4 * density).toInt())
    }

    private fun createSpinner(options: List<FilterOption>): Spinner = Spinner(this).apply {
        adapter = ArrayAdapter(
            this@YadNegarWidgetConfigureActivity,
            android.R.layout.simple_spinner_dropdown_item,
            options.map { it.title },
        )
    }

    private fun readOptions(projection: JSONObject, key: String, allTitle: String): List<FilterOption> {
        val options = mutableListOf(FilterOption("", allTitle))
        val items = projection.optJSONArray(key) ?: return options
        for (index in 0 until items.length()) {
            val item = items.optJSONObject(index) ?: continue
            val id = item.optString("id").trim()
            val title = item.optString("title").trim()
            if (id.isNotEmpty() && title.isNotEmpty()) options.add(FilterOption(id, title))
        }
        return options
    }

    private fun toPersianDigits(value: String): String {
        val latin = "0123456789"
        val persian = "۰۱۲۳۴۵۶۷۸۹"
        return value.map { digit ->
            val index = latin.indexOf(digit)
            if (index >= 0) persian[index] else digit
        }.joinToString("")
    }

    data class FilterOption(val id: String, val title: String)

    companion object {
        const val PREFS = "yadnegar_widget_preferences"
    }
}
