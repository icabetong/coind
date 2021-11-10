import 'package:intl/intl.dart';

String formatCurrency(num? currency, {String? symbol}) {
  return NumberFormat.compactCurrency(symbol: symbol?.toUpperCase())
      .format(currency);
}

String formatLong(num? number) {
  return NumberFormat.compactLong().format(number);
}

String formatPercent(num? percent) {
  return NumberFormat.percentPattern().format(percent);
}

String formatDateString(String? timestamp, {String? pattern}) {
  if (timestamp == null) return "";
  DateTime? dateTime = DateTime.tryParse(timestamp);

  if (dateTime == null) return timestamp;

  return formatDate(dateTime);
}

String formatDate(DateTime timestamp, {String? pattern}) {
  return DateFormat(pattern ?? "M/d/yyyy").format(timestamp);
}
