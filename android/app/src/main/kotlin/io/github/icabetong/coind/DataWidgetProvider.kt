package io.github.icabetong.coind

import android.net.Uri
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

class DataWidgetProvider: HomeWidgetProvider() {

    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, widgetData: SharedPreferences) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.layout_widget).apply {
                val symbol = widgetData.getString("symbol", null)
                val value = widgetData.getString("value", null)
                val lastUpdated = widgetData.getString("lastUpdated", null)

                val lastUpdatedString = if (lastUpdated == null)
                    context.getString(R.string.widget_last_updated_no_date)
                else String.format(context.getString(R.string.widget_last_updated), lastUpdated)
                
                setTextViewText(R.id.symbolTextView, symbol ?: context.getString(R.string.widget_n_a))
                setTextViewText(R.id.valueTextView, value ?: context.getString(R.string.widget_no_data))
                setTextViewText(R.id.lastUpdatedTextView, lastUpdatedString)

                val pendingIntent = HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java)
                setOnClickPendingIntent(R.id.widgetContainer, pendingIntent);

                val backgroundIntent = HomeWidgetBackgroundIntent.getBroadcast(context, Uri.parse("coindWidget://triggerRefresh"));
                setOnClickPendingIntent(R.id.triggerRefreshButton, backgroundIntent);
            }

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}