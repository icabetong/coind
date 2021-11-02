import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CryptoDataCard extends StatefulWidget {
  const CryptoDataCard({Key? key}) : super(key: key);

  @override
  State<CryptoDataCard> createState() => _CryptoDataCard();
}

class _CryptoDataCard extends State<CryptoDataCard> {
  late Future<CryptoData> crypto;

  Future<CryptoData> fetch() async {
    final response = await http.get(
        Uri.parse('https://api.coingecko.com/api/v3/coins/smooth-love-potion'));

    if (response.statusCode == 200) {
      return CryptoData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('failed');
    }
  }

  @override
  void initState() {
    super.initState();
    crypto = fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: FutureBuilder<CryptoData>(
                future: crypto,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        Text(snapshot.data!.currentPrices['php'].toString(),
                            style: Theme.of(context).textTheme.headline4),
                        Text(snapshot.data!.name)
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return const CircularProgressIndicator();
                })));
  }
}

class CryptoData {
  final String id;
  final String symbol;
  final String name;
  final Map<String, double> currentPrices;

  CryptoData(
      {required this.id,
      required this.symbol,
      required this.name,
      required this.currentPrices});

  factory CryptoData.fromJson(Map<String, dynamic> json) {
    return CryptoData(
        id: json['id'],
        symbol: json['symbol'],
        name: json['name'],
        currentPrices:
            Map<String, double>.from(json['market_data']['current_price']));
  }
}
