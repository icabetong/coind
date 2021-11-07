import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:coind/domain/market_graph_data.dart';
import 'package:coind/domain/store.dart';

class CoinPriceGraph extends StatefulWidget {
  const CoinPriceGraph(
      {Key? key, required this.userCurrency, required this.source})
      : super(key: key);

  final String userCurrency;
  final String source;

  @override
  State<CoinPriceGraph> createState() => _CoinPriceGraph();
}

class _CoinPriceGraph extends State<CoinPriceGraph> {
  late Future<MarketChart> chart;

  @override
  void initState() {
    super.initState();
    chart =
        Store.fetchMarketChart('smooth-love-potion', widget.userCurrency, 2);
  }

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat("h:mm aa");
    NumberFormat currencyFormat =
        NumberFormat.currency(symbol: widget.userCurrency.toUpperCase());

    return FutureBuilder<MarketChart>(
        future: chart,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<dynamic> items = [];
            switch (widget.source) {
              case "prices":
                items = snapshot.data!.prices;
                break;
              case "market-caps":
                items = snapshot.data!.marketCaps;
                break;
              case "total-volume":
                items = snapshot.data!.totalVolume;
                break;
              default:
                items = snapshot.data!.prices;
            }

            Map<double, double> data = MarketChart.convert(items);
            double lowestPrice = MarketChart.findLowestValue(data);
            double highestPrice = MarketChart.findHighestValue(data);
            double earliestDate = MarketChart.findLowestKey(data);
            double furthestDate = MarketChart.findHighestKey(data);

            return LineChart(
              LineChartData(
                lineTouchData: LineTouchData(touchTooltipData:
                    LineTouchTooltipData(getTooltipItems: (values) {
                  return values.map((e) {
                    return LineTooltipItem(
                        currencyFormat.format(e.y.toDouble()),
                        const TextStyle(color: Colors.white));
                  }).toList();
                })),
                borderData: FlBorderData(
                    border: Border.all(color: Colors.white, width: 0)),
                gridData: FlGridData(
                    drawHorizontalLine: false, drawVerticalLine: false),
                titlesData: FlTitlesData(
                  topTitles: SideTitles(showTitles: false),
                  rightTitles: SideTitles(showTitles: false),
                  bottomTitles: SideTitles(
                    showTitles: true,
                    rotateAngle: 90,
                    getTitles: (value) {
                      DateTime date =
                          DateTime.fromMillisecondsSinceEpoch(value.toInt());
                      return dateFormat.format(date);
                    },
                  ),
                  leftTitles: SideTitles(
                    showTitles: true,
                    interval: 0.5,
                    getTitles: (value) {
                      return value.toDouble().toStringAsFixed(1);
                    },
                  ),
                ),
                minX: earliestDate,
                maxX: furthestDate,
                minY: lowestPrice,
                maxY: highestPrice,
                lineBarsData: [
                  LineChartBarData(
                      colors: [Theme.of(context).colorScheme.secondary],
                      dotData: FlDotData(show: false),
                      isCurved: true,
                      spots: data.entries
                          .map((e) => FlSpot(e.key, e.value))
                          .toList())
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Text(Translations.of(context)!.error_fetch_data);
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}

class ChartContainer extends StatefulWidget {
  final String currency;

  const ChartContainer({Key? key, required this.currency}) : super(key: key);

  @override
  State<ChartContainer> createState() => _ChartContainerState();
}

class _ChartContainerState extends State<ChartContainer> {
  String dataSource = "prices";

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        height: MediaQuery.of(context).size.width * 0.95 * 0.65,
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
                child: Container(
              margin: const EdgeInsets.symmetric(vertical: 24.0),
              padding: const EdgeInsets.all(4.0),
              child: CoinPriceGraph(
                  userCurrency: widget.currency, source: dataSource),
            ))
          ],
        ),
      ),
    );
  }
}
