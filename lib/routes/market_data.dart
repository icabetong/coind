import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:coind/domain/market_data.dart';
import 'package:coind/widgets/data_container.dart';

class MarketDataRoute extends StatelessWidget {
  const MarketDataRoute(
      {Key? key, required this.userCurrency, required this.marketData})
      : super(key: key);

  final String userCurrency;
  final MarketData marketData;

  String formatAsDate(String? date) {
    if (date == null) return "";
    DateTime? dateTime = DateTime.tryParse(date);

    if (dateTime == null) return date;

    return DateFormat("M/d/yy").format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    NumberFormat currencyFormat =
        NumberFormat.currency(symbol: userCurrency.toUpperCase());
    NumberFormat shortCurrencyFormat =
        NumberFormat.compactCurrency(symbol: userCurrency.toUpperCase());
    NumberFormat percentFormat = NumberFormat.percentPattern();
    DateFormat dateFormat = DateFormat("MMM d yyyy-hh:mm a");
    return Scaffold(
      appBar:
          AppBar(title: Text(Translations.of(context)!.navigation_market_data)),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  OneLineDataContainer(
                      header: Translations.of(context)!.trading_volume,
                      data: shortCurrencyFormat
                          .format(marketData.totalVolume[userCurrency])),
                  OneLineDataContainer(
                      header: Translations.of(context)!.total_supply,
                      data: marketData.totalSupply.toStringAsFixed(0)),
                  OneLineDataContainer(
                      header: Translations.of(context)!.max_supply,
                      data: marketData.maxSupply == 0
                          ? Translations.of(context)!.infinity
                          : marketData.maxSupply.toStringAsFixed(0)),
                  OneLineDataContainer(
                      header: Translations.of(context)!.circulating_supply,
                      data: marketData.circulatingSupply.toStringAsFixed(0)),
                  ThreeDataContainer(
                    header: Translations.of(context)!.all_time_high,
                    mainData: currencyFormat
                        .format(marketData.allTimeHigh[userCurrency]),
                    siblingData: percentFormat
                        .format(marketData.allTimeHighChange[userCurrency]),
                    supportingData:
                        formatAsDate(marketData.allTimeHighDate[userCurrency]!),
                  ),
                  ThreeDataContainer(
                    header: Translations.of(context)!.all_time_low,
                    mainData: currencyFormat
                        .format(marketData.allTimeLow[userCurrency]),
                    siblingData: percentFormat
                        .format(marketData.allTimeLowChange[userCurrency]),
                    supportingData:
                        formatAsDate(marketData.allTimeLowDate[userCurrency]!),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
              alignment: Alignment.centerLeft,
              child: Text(Translations.of(context)!.price_change,
                  style: const TextStyle(fontWeight: FontWeight.w500)),
            ),
            GridView.count(
              padding: const EdgeInsets.all(16.0),
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              children: <Widget>[
                TwoLineDataCard(
                    header: Translations.of(context)!.price_change_1h,
                    mainData: marketData
                        .priceChangePercentage1hInCurrency[userCurrency]
                        .toString(),
                    supportingData: Translations.of(context)!.no_data),
                TwoLineDataCard(
                    header: Translations.of(context)!.price_change_24h,
                    mainData: marketData
                        .priceChangePercentage24hInCurrency[userCurrency]
                        .toString(),
                    supportingData: percentFormat
                        .format(marketData.priceChangePercentage24h)),
                TwoLineDataCard(
                    header: Translations.of(context)!.price_change_7d,
                    mainData: marketData
                        .priceChangePercentage7dInCurrency[userCurrency]
                        .toString(),
                    supportingData: percentFormat
                        .format(marketData.priceChangePercentage7d)),
                TwoLineDataCard(
                    header: Translations.of(context)!.price_change_14d,
                    mainData: marketData
                        .priceChangePercentage14dInCurrency[userCurrency]
                        .toString(),
                    supportingData: percentFormat
                        .format(marketData.priceChangePercentage14d)),
                TwoLineDataCard(
                    header: Translations.of(context)!.price_change_30d,
                    mainData: marketData
                        .priceChangePercentage30dInCurrency[userCurrency]
                        .toString(),
                    supportingData: percentFormat
                        .format(marketData.priceChangePercentage30d)),
                TwoLineDataCard(
                    header: Translations.of(context)!.price_change_60d,
                    mainData: marketData
                        .priceChangePercentage60dInCurrency[userCurrency]
                        .toString(),
                    supportingData: percentFormat
                        .format(marketData.priceChangePercentage60d)),
                TwoLineDataCard(
                    header: Translations.of(context)!.price_change_200d,
                    mainData: marketData
                        .priceChangePercentage200dInCurrency[userCurrency]
                        .toString(),
                    supportingData: percentFormat
                        .format(marketData.priceChangePercentage200d)),
                TwoLineDataCard(
                    header: Translations.of(context)!.price_change_1y,
                    mainData: marketData
                        .priceChangePercentage1yInCurrency[userCurrency]
                        .toString(),
                    supportingData: percentFormat
                        .format(marketData.priceChangePercentage1y)),
              ],
            ),
            if (marketData.getLastUpdatedDate() != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                    Translations.of(context)!.last_updated(
                        dateFormat.format(marketData.getLastUpdatedDate()!)),
                    style: const TextStyle(color: Colors.white70)),
              )
          ],
        ),
      ),
    );
  }
}
