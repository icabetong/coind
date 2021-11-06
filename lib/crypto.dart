import 'dart:async';
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'data.dart';
import 'graphs.dart';
import 'settings.dart';

class CryptoDataRoute extends StatefulWidget {
  const CryptoDataRoute({Key? key}) : super(key: key);

  @override
  State<CryptoDataRoute> createState() => _CryptoDataRoute();
}

class _CryptoDataRoute extends State<CryptoDataRoute> {
  SharedPreferencesHelper helper = SharedPreferencesHelper();

  String userCurrency = "usd";
  late Future<Coin> crypto;

  Future<Coin> fetch() async {
    final response = await http.get(Uri.parse(
        'https://api.coingecko.com/api/v3/coins/smooth-love-potion?localization=false&tickers=false&community_data=false&developer_data=false'));

    if (response.statusCode == 200) {
      return Coin.fromJson(jsonDecode(response.body));
    } else {
      return Future.error(response.statusCode.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    crypto = fetch();
    helper.getCurrency().then((c) {
      userCurrency = c ?? "usd";
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: Color.lerp(
          Theme.of(context).scaffoldBackgroundColor, Colors.black, 0.2),
      color: Theme.of(context).colorScheme.secondary,
      onRefresh: () async {
        setState(() {
          crypto = fetch();
          helper.getCurrency().then((c) {
            userCurrency = c ?? "usd";
          });
        });
      },
      child: FutureBuilder<Coin>(
          future: crypto,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return CryptoDataContainer(
                  coin: snapshot.data!, userCurrency: userCurrency);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}

class CryptoDataContainer extends StatelessWidget {
  const CryptoDataContainer(
      {Key? key, required this.coin, required this.userCurrency})
      : super(key: key);

  final Coin coin;
  final String userCurrency;

  void _navigateToMarketData(BuildContext context, MarketData marketData) {
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => MarketDataRoute(
                userCurrency: userCurrency, marketData: marketData)));
  }

  @override
  Widget build(BuildContext context) {
    NumberFormat currencyFormat =
        NumberFormat.currency(symbol: userCurrency.toUpperCase());
    NumberFormat currencyShortFormat =
        NumberFormat.compactCurrency(symbol: userCurrency.toUpperCase());

    return SingleChildScrollView(
      physics: const ScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(coin.name.toUpperCase(),
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0,
                      color: Colors.white70)),
              Text(
                  currencyFormat
                      .format(coin.marketData.currentPrice[userCurrency]),
                  style: Theme.of(context).textTheme.headline3?.copyWith(
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      )),
              ChartContainer(
                  title: "Chart",
                  color: Theme.of(context).colorScheme.primary,
                  chart: CoinPriceGraph(
                    userCurrency: userCurrency,
                  )),
              Container(
                margin: const EdgeInsets.only(top: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OneLineDataContainer(
                        header: Translations.of(context)!.market_cap,
                        data: currencyShortFormat
                            .format(coin.marketData.marketCap[userCurrency])),
                    OneLineDataContainer(
                        header: Translations.of(context)!.market_cap_rank,
                        data: coin.marketData.marketCapRank.toString()),
                    OneLineDataContainer(
                        header: Translations.of(context)!.highest_24h,
                        data: currencyFormat
                            .format(coin.marketData.highest24h[userCurrency])),
                    OneLineDataContainer(
                        header: Translations.of(context)!.lowest_24h,
                        data: currencyFormat
                            .format(coin.marketData.lowest24h[userCurrency])),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        TextButton(
                            onPressed: () {
                              _navigateToMarketData(context, coin.marketData);
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                    Translations.of(context)!
                                        .button_view_market_data,
                                    style:
                                        const TextStyle(color: Colors.white)),
                                const Icon(Icons.chevron_right_outlined,
                                    color: Colors.white)
                              ],
                            )),
                      ],
                    ),
                    if (coin.description['en'] != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Text(Translations.of(context)!.description,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary)),
                          ),
                          Text(coin.description['en']!)
                        ],
                      )
                  ],
                ),
              )
            ]),
      ),
    );
  }
}

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
            )
          ],
        ),
      ),
    );
  }
}

class TwoLineDataCard extends StatelessWidget {
  const TwoLineDataCard(
      {Key? key,
      required this.header,
      required this.mainData,
      required this.supportingData})
      : super(key: key);

  final String header;
  final String mainData;
  final String supportingData;

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.all(0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                header.toUpperCase(),
                style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(mainData,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                        fontSize: 24.0)),
              ),
              Text(supportingData, style: const TextStyle(fontSize: 14.0))
            ],
          ),
        ));
  }
}

class ThreeDataContainer extends StatelessWidget {
  const ThreeDataContainer(
      {Key? key,
      required this.header,
      required this.mainData,
      required this.siblingData,
      required this.supportingData})
      : super(key: key);

  final String header;
  final String mainData;
  final String siblingData;
  final String supportingData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(header.toUpperCase(),
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.w500,
                fontSize: 14.0,
              )),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(mainData,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    )),
                Container(
                    margin: const EdgeInsets.only(left: 8.0),
                    child: Text(siblingData,
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 16.0)))
              ],
            ),
            Text(supportingData, style: const TextStyle(color: Colors.white))
          ])
        ],
      ),
    );
  }
}

class TwoLineDataContainer extends StatelessWidget {
  const TwoLineDataContainer(
      {Key? key,
      required this.header,
      required this.supportingData,
      required this.mainData})
      : super(key: key);

  final String header;
  final String supportingData;
  final String mainData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(header.toUpperCase(),
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.w500,
                fontSize: 14.0,
              )),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(mainData,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                )),
            Text(supportingData, style: Theme.of(context).textTheme.overline)
          ])
        ],
      ),
    );
  }
}

class OneLineDataContainer extends StatelessWidget {
  const OneLineDataContainer(
      {Key? key, required this.header, required this.data})
      : super(key: key);

  final String header;
  final String data;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(header.toUpperCase(),
                style: Theme.of(context).textTheme.bodyText2?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.w500,
                    fontSize: 14.0)),
            Text(data,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ))
          ],
        ));
  }
}
