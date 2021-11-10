package io.github.icabetong.coind

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

class DataWidget: HomeWidgetProvider() {

    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, widgetData: SharedPreferences) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.layout_widget).apply {
                val symbol = widgetData.getString("symbol", null)
                val value = widgetData.getString("value", null)
                val lastUpdated = widgetData.getString("lastUpdated", null)
                
                setTextViewText(R.id.symbolTextView, symbol ?: context.getString(R.string.widget_n_a))
                setTextViewText(R.id.valueTextView, value ?: context.getString(R.string.widget_no_data))
                setTextViewText(R.id.lastUpdatedTextView, lastUpdated ?: context.getString(R.string.widget_last_updated_no_date))

            }

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}