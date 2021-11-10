import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:coind/domain/coin_data.dart';
import 'package:coind/domain/market_data.dart';
import 'package:coind/domain/market_graph_data.dart';
import 'package:coind/l10n/formatters.dart';
import 'package:coind/repository/store.dart';
import 'package:coind/repository/preferences.dart';
import 'package:coind/routes/market_data.dart';
import 'package:coind/widgets/data_container.dart';
import 'package:coind/widgets/graphs.dart';

class CryptoDataWidget extends StatefulWidget {
  const CryptoDataWidget(
      {Key? key,
      required this.coin,
      required this.preferences,
      required this.coinId})
      : super(key: key);

  final Coin coin;
  final String coinId;
  final UserPreferences preferences;

  @override
  State<CryptoDataWidget> createState() => _CryptoDataWidgetState();
}

class _CryptoDataWidgetState extends State<CryptoDataWidget> {
  int dataSourceIndex = 0;
  late Future<MarketChart> chart;

  @override
  void initState() {
    super.initState();
    chart = Store.fetchMarketChart(widget.coinId, widget.preferences.currency,
        widget.preferences.daysInterval);
  }

  void _navigateToMarketData(BuildContext context, MarketData marketData) {
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => MarketDataRoute(
                userCurrency: widget.preferences.currency,
                marketData: marketData)));
  }

  @override
  Widget build(BuildContext context) {
    String currency = widget.preferences.currency;
    DateFormat dateFormat = DateFormat("M d yyyy, h:mm a");

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
                  formatCurrency(
                      widget.coin.marketData
                          ?.currentPrice[widget.preferences.currency],
                      symbol: currency),
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
                              currency: widget.preferences.currency,
                              dataSource: snapshot.data!.prices));
                    } else if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                      //return Text(Translations.of(context)!.error_fetch_data);
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
                        data: formatCurrency(
                            widget.coin.marketData
                                ?.marketCap[widget.preferences.currency],
                            symbol: currency)),
                    OneLineDataContainer(
                        header: Translations.of(context)!.market_cap_rank,
                        data:
                            widget.coin.marketData?.marketCapRank.toString() ??
                                Translations.of(context)!.no_data),
                    OneLineDataContainer(
                        header: Translations.of(context)!.highest_24h,
                        data: formatCurrency(
                            widget.coin.marketData
                                ?.highest24h[widget.preferences.currency],
                            symbol: currency)),
                    OneLineDataContainer(
                        header: Translations.of(context)!.lowest_24h,
                        data: formatCurrency(
                            widget.coin.marketData
                                ?.lowest24h[widget.preferences.currency],
                            symbol: currency)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        TextButton(
                            onPressed: () {
                              _navigateToMarketData(
                                  context, widget.coin.marketData!);
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
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
                        header: Translations.of(context)!.websites,
                        data: widget.coin.links?.getWebsites() ?? []),
                    InformationWithChip(
                        header: Translations.of(context)!.forums,
                        data: widget.coin.links?.getForumsAndChats() ?? []),
                    Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(Translations.of(context)!.communities,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.0,
                                  )),
                              Row(
                                children: [
                                  if (widget.coin.links?.twitterName
                                          ?.isNotEmpty ==
                                      true)
                                    IconButton(
                                      icon: const FaIcon(
                                          FontAwesomeIcons.twitter),
                                      onPressed: () async {
                                        String url =
                                            'https://www.twitter.com/${widget.coin.links?.twitterName}';

                                        await canLaunch(url)
                                            ? launch(url)
                                            : ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        Translations.of(
                                                                context)!
                                                            .error_generic)));
                                      },
                                    ),
                                  if (widget.coin.links?.facebookUsername
                                          ?.isNotEmpty ==
                                      true)
                                    IconButton(
                                      icon: const FaIcon(
                                          FontAwesomeIcons.facebook),
                                      onPressed: () async {
                                        String url =
                                            'https://www.facebook.com/${widget.coin.links?.facebookUsername}';

                                        await canLaunch(url)
                                            ? launch(url)
                                            : ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        Translations.of(
                                                                context)!
                                                            .error_generic)));
                                      },
                                    ),
                                  if (widget.coin.links?.telegramChannelId
                                          ?.isNotEmpty ==
                                      true)
                                    IconButton(
                                      icon: const FaIcon(
                                          FontAwesomeIcons.telegramPlane),
                                      onPressed: () async {
                                        String url =
                                            'https://www.t.me/${widget.coin.links?.telegramChannelId}';

                                        await canLaunch(url)
                                            ? launch(url)
                                            : ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                content: Text(
                                                    Translations.of(context)!
                                                        .error_generic),
                                              ));
                                      },
                                    ),
                                  if (widget.coin.links?.subredditUrl
                                          ?.isNotEmpty ==
                                      true)
                                    IconButton(
                                      icon: const FaIcon(
                                          FontAwesomeIcons.redditAlien),
                                      onPressed: () async {
                                        String url =
                                            '${widget.coin.links?.subredditUrl!}';

                                        await canLaunch(url)
                                            ? launch(url)
                                            : ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        Translations.of(
                                                                context)!
                                                            .error_generic)));
                                      },
                                    ),
                                  if (widget.coin.links?.bitcoinTalkThreadId !=
                                      0)
                                    IconButton(
                                        icon: const FaIcon(
                                            FontAwesomeIcons.bitcoin),
                                        onPressed: () async {})
                                ],
                              )
                            ])),
                    if (widget.coin.lastUpdated != null)
                      Container(
                        alignment: Alignment.centerRight,
                        margin: const EdgeInsets.only(top: 24),
                        child: Text(
                            Translations.of(context)!.last_updated(
                                formatDate(widget.coin.lastUpdated!)),
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
