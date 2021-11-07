import 'dart:async';
import 'package:coind/widgets/states.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:coind/domain/coin_data.dart';
import 'package:coind/domain/market_data.dart';
import 'package:coind/domain/market_graph_data.dart';
import 'package:coind/domain/store.dart';
import 'package:coind/routes/market_data.dart';
import 'package:coind/routes/settings.dart';
import 'package:coind/widgets/data_container.dart';
import 'package:coind/widgets/graphs.dart';

class CryptoDataRoute extends StatefulWidget {
  const CryptoDataRoute({Key? key}) : super(key: key);

  @override
  State<CryptoDataRoute> createState() => _CryptoDataRoute();
}

class _CryptoDataRoute extends State<CryptoDataRoute> {
  SharedPreferencesHelper helper = SharedPreferencesHelper();

  String userCurrency = "usd";
  String cryptoId = "smooth-love-potion";
  late Future<Coin> crypto;

  void _prepare() {
    setState(() {
      crypto = Store.fetchCoinData(cryptoId);
      helper.getCurrency().then((c) {
        userCurrency = c ?? "usd";
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _prepare();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: Color.lerp(
          Theme.of(context).scaffoldBackgroundColor, Colors.black, 0.2),
      color: Theme.of(context).colorScheme.secondary,
      onRefresh: () async {
        _prepare();
      },
      child: FutureBuilder<Coin>(
          future: crypto,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return CryptoDataContainer(
                  coin: snapshot.data!, userCurrency: userCurrency);
            } else if (snapshot.hasError) {
              return const ErrorState();
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}

class CryptoDataContainer extends StatefulWidget {
  const CryptoDataContainer(
      {Key? key, required this.coin, required this.userCurrency})
      : super(key: key);

  final Coin coin;
  final String userCurrency;

  @override
  State<CryptoDataContainer> createState() => _CryptoDataContainerState();
}

class _CryptoDataContainerState extends State<CryptoDataContainer> {
  late Future<MarketChart> chart;

  @override
  void initState() {
    super.initState();
    chart = Store.fetchMarketChart("smooth-love-potion", "php", 2);
  }

  void _navigateToMarketData(BuildContext context, MarketData marketData) {
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => MarketDataRoute(
                userCurrency: widget.userCurrency, marketData: marketData)));
  }

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat("M d yyyy, h:mm a");
    NumberFormat currencyFormat =
        NumberFormat.currency(symbol: widget.userCurrency.toUpperCase());
    NumberFormat currencyShortFormat =
        NumberFormat.compactCurrency(symbol: widget.userCurrency.toUpperCase());

    return SingleChildScrollView(
      physics: const ScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(widget.coin.name.toUpperCase(),
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0,
                      color: Colors.white70)),
              Text(
                  currencyFormat.format(
                      widget.coin.marketData.currentPrice[widget.userCurrency]),
                  style: Theme.of(context).textTheme.headline3?.copyWith(
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      )),
              FutureBuilder<MarketChart>(
                  future: chart,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ChartContainer(
                          chart: CoinPriceGraph(
                              userCurrency: widget.userCurrency,
                              dataSource: snapshot.data!.prices));
                    } else if (snapshot.hasError) {
                      return Text(Translations.of(context)!.error_fetch_data);
                    }

                    return Container();
                  }),
              Container(
                margin: const EdgeInsets.only(top: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OneLineDataContainer(
                        header: Translations.of(context)!.market_cap,
                        data: currencyShortFormat.format(widget
                            .coin.marketData.marketCap[widget.userCurrency])),
                    OneLineDataContainer(
                        header: Translations.of(context)!.market_cap_rank,
                        data: widget.coin.marketData.marketCapRank.toString()),
                    OneLineDataContainer(
                        header: Translations.of(context)!.highest_24h,
                        data: currencyFormat.format(widget
                            .coin.marketData.highest24h[widget.userCurrency])),
                    OneLineDataContainer(
                        header: Translations.of(context)!.lowest_24h,
                        data: currencyFormat.format(widget
                            .coin.marketData.lowest24h[widget.userCurrency])),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        TextButton(
                            onPressed: () {
                              _navigateToMarketData(
                                  context, widget.coin.marketData);
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
                    if (widget.coin.description['en'] != null)
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
                          ExpandableText(
                            widget.coin.description['en']!,
                            maxLines: 4,
                            expandText: Translations.of(context)!.button_more,
                            collapseText: Translations.of(context)!.button_less,
                          )
                        ],
                      ),
                    InformationWithChip(
                        header: Translations.of(context)!.categories,
                        data: widget.coin.categories),
                    InformationWithChip(
                        header: Translations.of(context)!.communities,
                        data: widget.coin.links.getWebsites()),
                    if (widget.coin.lastUpdated != null)
                      Container(
                        alignment: Alignment.centerRight,
                        margin: const EdgeInsets.only(top: 24),
                        child: Text(
                            Translations.of(context)!.last_updated(
                                dateFormat.format(widget.coin.lastUpdated!)),
                            style: const TextStyle(color: Colors.white54)),
                      ),
                    Container(
                        alignment: Alignment.centerRight,
                        margin: const EdgeInsets.only(bottom: 16.0),
                        child: Text(Translations.of(context)!.data_provider))
                  ],
                ),
              )
            ]),
      ),
    );
  }
}
