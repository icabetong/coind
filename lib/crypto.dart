import 'dart:async';
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'data.dart';

class CryptoDataContainer extends StatefulWidget {
  const CryptoDataContainer({Key? key}) : super(key: key);

  @override
  State<CryptoDataContainer> createState() => _CryptoDataContainer();
}

class _CryptoDataContainer extends State<CryptoDataContainer> {
  late Future<Coin> crypto;

  String formatAsDate(String date) {
    DateTime? dateTime = DateTime.tryParse(date);

    if (dateTime == null) return date;

    return DateFormat("M/d/yy").format(dateTime);
  }

  Future<Coin> fetch() async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.coingecko.com/api/v3/coins/smooth-love-potion?localization=false'));

      if (response.statusCode == 200) {
        return Coin.fromJson(jsonDecode(response.body));
      } else {
        return Future.error(response.statusCode.toString());
      }
    } catch (error) {
      return Future.error(error);
    }
  }

  @override
  void initState() {
    super.initState();
    crypto = fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        FutureBuilder<Coin>(
            future: crypto,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(snapshot.data!.name.toUpperCase(),
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.0,
                                  color: Colors.white70)),
                      Text(
                          '${snapshot.data!.currentPrices['php']?.toStringAsFixed(2)}',
                          style:
                              Theme.of(context).textTheme.headline2?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  )),
                      Container(
                        margin: const EdgeInsets.only(top: 16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TwoLineDataContainer(
                                header: Translations.of(context)!
                                    .data_all_time_high,
                                subheader: formatAsDate(snapshot
                                    .data!.allTimeHighDate['php']
                                    .toString()),
                                data:
                                    'P ${snapshot.data!.allTimeHigh['php'].toStringAsFixed(2)}'),
                            TwoLineDataContainer(
                                header:
                                    Translations.of(context)!.data_all_time_low,
                                subheader: formatAsDate(snapshot
                                    .data!.allTimeLowDate['php']
                                    .toString()),
                                data:
                                    'P ${snapshot.data!.allTimeLow['php'].toStringAsFixed(2)}'),
                            OneLineDataContainer(
                                header: "Highest 24h",
                                data:
                                    'P ${snapshot.data!.highest24h['php']?.toStringAsFixed(2)}'),
                            OneLineDataContainer(
                                header: "Lowest 24h",
                                data:
                                    'P ${snapshot.data!.lowest24h['php']?.toStringAsFixed(2)}'),
                            OneLineDataContainer(
                                header: "Market Cap",
                                data: 'P ${snapshot.data!.marketCap['php']}'),
                            OneLineDataContainer(
                                header: "All-Time Low",
                                data:
                                    'P ${snapshot.data!.allTimeLow['php'].toStringAsFixed(2)}'),
                            OneLineDataContainer(
                                header: "All-Time High",
                                data:
                                    'P ${snapshot.data!.allTimeHigh['php'].toStringAsFixed(2)}'),
                          ],
                        ),
                      )
                    ]);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const CircularProgressIndicator();
            }),
      ],
    );
  }
}

class TwoLineDataContainer extends StatelessWidget {
  const TwoLineDataContainer(
      {Key? key,
      required this.header,
      required this.subheader,
      required this.data})
      : super(key: key);

  final String header;
  final String subheader;
  final String data;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(header.toUpperCase(),
            style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.w500)),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(data,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              )),
          Text(subheader, style: Theme.of(context).textTheme.overline)
        ])
      ],
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
    return Container(
        margin: const EdgeInsets.only(top: 4.0, bottom: 4.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(header.toUpperCase(),
                style: Theme.of(context).textTheme.bodyText2?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.w500)),
            Text(data)
          ],
        ));
  }
}
