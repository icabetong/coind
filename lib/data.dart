import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CyptoData extends StatefulWidget {
  const CyptoData({Key? key}) : super(key: key);

  @override
  State<CyptoData> createState() => _CryptoData();
}

class _CryptoData extends State<CyptoData> {
  late Future<Crypto> crypto;

  Future<Crypto> fetch() async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.coingecko.com/api/v3/coins/smooth-love-potion?localization=false'));

      if (response.statusCode == 200) {
        return Crypto.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('failed');
      }
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    crypto = fetch();
  }

  @override
  Widget build(BuildContext context) {
    bool isScreenWide = MediaQuery.of(context).size.width >= 800;

    return FutureBuilder<Crypto>(
        future: crypto,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(snapshot.data!.name.toUpperCase(),
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0,
                      color: Colors.white70
                    )
                  ),
                Text('${snapshot.data!.currentPrices['php']?.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.headline2?.copyWith(
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    )
                  ),
                Container(
                  margin: const EdgeInsets.only(top: 16.0),
                  child: Column(
                    children: [
                      InformationRow(
                        header: "Highest 24h", 
                        info: 'P ${snapshot.data!.highest24h['php']?.toStringAsFixed(2)}'
                      ),
                      InformationRow(
                        header: "Lowest 24h", 
                        info: 'P ${snapshot.data!.lowest24h['php']?.toStringAsFixed(2)}'
                      ),
                      InformationRow(
                        header: "Market Cap", 
                        info: 'P ${snapshot.data!.marketCap['php']}'
                      ),
                      InformationRow(
                        header: "All-Time Low", 
                        info: 'P ${snapshot.data!.allTimeLow['php'].toStringAsFixed(2)}'
                      ),
                      InformationRow(
                        header: "All-Time High", 
                        info: 'P ${snapshot.data!.allTimeHigh['php'].toStringAsFixed(2)}'
                      ),
                    ],
                  ),
                )
              ]
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        });
  }
}

class InformationRow extends StatelessWidget {
  const InformationRow({Key? key, required this.header, required this.info})
      : super(key: key);

  final String header;
  final String info;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 4.0, bottom: 4.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(header.toUpperCase(),
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  ?.copyWith(color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.w500)),
          Text(info)
        ],
      )
    );
  }
}

class Crypto {
  final String id;
  final String symbol;
  final String name;
  final Map<String, double> currentPrices;
  final Map<String, dynamic> allTimeHigh;
  final Map<String, double> allTimeHighChange;
  final Map<String, String> allTimeHighDate;
  final Map<String, dynamic> allTimeLow;
  final Map<String, double> allTimeLowChange;
  final Map<String, String> allTimeLowDate;
  final Map<String, int> marketCap;
  final int marketCapRank;
  final Map<String, int> totalVolume;
  final Map<String, double> highest24h;
  final Map<String, double> lowest24h;
  final double priceChange24h;

  Crypto(
      {required this.id,
      required this.symbol,
      required this.name,
      required this.currentPrices,
      required this.allTimeHigh,
      required this.allTimeHighChange,
      required this.allTimeHighDate,
      required this.allTimeLow,
      required this.allTimeLowChange,
      required this.allTimeLowDate,
      required this.marketCap,
      required this.marketCapRank,
      required this.totalVolume,
      required this.highest24h,
      required this.lowest24h,
      required this.priceChange24h});

  factory Crypto.fromJson(Map<String, dynamic> json) {
    return Crypto(
        id: json['id'],
        symbol: json['symbol'],
        name: json['name'],
        currentPrices:
            Map<String, double>.from(json['market_data']['current_price']),
        allTimeHigh: Map<String, dynamic>.from(json['market_data']['ath']),
        allTimeHighChange: Map<String, double>.from(
            json['market_data']['ath_change_percentage']),
        allTimeHighDate:
            Map<String, String>.from(json['market_data']['ath_date']),
        allTimeLow: Map<String, double>.from(json['market_data']['atl']),
        allTimeLowChange: Map<String, double>.from(
            json['market_data']['atl_change_percentage']),
        allTimeLowDate:
            Map<String, String>.from(json['market_data']['atl_date']),
        marketCap: Map<String, int>.from(json['market_data']['market_cap']),
        marketCapRank: json['market_data']['market_cap_rank'],
        totalVolume: Map<String, int>.from(json['market_data']['total_volume']),
        highest24h: Map<String, double>.from(json['market_data']['high_24h']),
        lowest24h: Map<String, double>.from(json['market_data']['low_24h']),
        priceChange24h: json['market_data']['price_change_24h']);
  }
}
