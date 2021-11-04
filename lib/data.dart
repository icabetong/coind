import 'dart:async';
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CyptoData extends StatefulWidget {
  const CyptoData({Key? key}) : super(key: key);

  @override
  State<CyptoData> createState() => _CryptoData();
}

class _CryptoData extends State<CyptoData> {
  late Future<Crypto> crypto;

  String formatAsDate(String date) {
    DateTime? dateTime = DateTime.tryParse(date);

    if (dateTime == null) return date;

    return DateFormat("M/d/yy").format(dateTime);
  }

  Future<Crypto> fetch() async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.coingecko.com/api/v3/coins/smooth-love-potion?localization=false'));

      if (response.statusCode == 200) {
        return Crypto.fromJson(jsonDecode(response.body));
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
        FutureBuilder<Crypto>(
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
                            InformationRow(
                                header: "Highest 24h",
                                info:
                                    'P ${snapshot.data!.highest24h['php']?.toStringAsFixed(2)}'),
                            InformationRow(
                                header: "Lowest 24h",
                                info:
                                    'P ${snapshot.data!.lowest24h['php']?.toStringAsFixed(2)}'),
                            InformationRow(
                                header: "Market Cap",
                                info: 'P ${snapshot.data!.marketCap['php']}'),
                            InformationRow(
                                header: "All-Time Low",
                                info:
                                    'P ${snapshot.data!.allTimeLow['php'].toStringAsFixed(2)}'),
                            InformationRow(
                                header: "All-Time High",
                                info:
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
                style: Theme.of(context).textTheme.bodyText2?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.w500)),
            Text(info)
          ],
        ));
  }
}

class Crypto {
  final String id;
  final String symbol;
  final String name;
  final String lastUpdated;
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
  final Map<String, double> highest7d;
  final Map<String, double> lowest7d;
  final double priceChange24h;

  Crypto(
      {required this.id,
      required this.symbol,
      required this.name,
      required this.lastUpdated,
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
      required this.highest7d,
      required this.lowest7d,
      required this.priceChange24h});

  factory Crypto.fromJson(Map<String, dynamic> json) {
    return Crypto(
        id: json['id'],
        symbol: json['symbol'],
        name: json['name'],
        lastUpdated: json['last_updated'],
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
        highest7d: Map<String, double>.from(json['market_data']['high_7d']),
        lowest7d: Map<String, double>.from(json['market_data']['low_7d']),
        priceChange24h: json['market_data']['price_change_24h']);
  }
}

class MarketData {
  final List<dynamic> prices;
  final List<dynamic> marketCaps;
  final List<dynamic> totalVolume;

  MarketData(
      {required this.prices,
      required this.marketCaps,
      required this.totalVolume});

  factory MarketData.fromJson(Map<String, dynamic> json) {
    return MarketData(
        prices: List<dynamic>.from(json['prices']),
        marketCaps: List<dynamic>.from(json['market_caps']),
        totalVolume: List<dynamic>.from(json['total_volumes']));
  }
}

var currencies = [
  "aed",
  "ars",
  "aud",
  "bch",
  "bdt",
  "bhd",
  "bmd",
  "bnb",
  "brl",
  "btc",
  "cad",
  "chf",
  "clp",
  "cny",
  "czk",
  "dkk",
  "dot",
  "eos",
  "eth",
  "eur",
  "gbp",
  "hkd",
  "idr",
  "inr",
  "jpy",
  "krw",
  "kwd",
  "lkr",
  "ltc",
  "mmk",
  "mxn",
  "myr",
  "ngn",
  "nok",
  "nzd",
  "php",
  "pkr",
  "pln",
  "rub",
  "sar",
  "sek",
  "sgd",
  "thb",
  "try",
  "twd",
  "uah",
  "usd",
  "xag",
  "xau",
  "xdr",
  "xlm",
  "xrp",
  "yfi",
  "zar",
  "bits",
  "link",
  "sats"
];

var currencyNames = {
  "aed": "United Arab Emirates Dirham",
  "ars": "Argenine Peso",
  "aud": "Australian Dollar",
  "bch": "Bitcoin Cash",
  "bdt": "Bangladeshi Taka",
  "bhd": "Bahraini Dinar",
  "bmd": "Bermudan Dollar",
  "bnb": "Binance Coin",
  "brl": "Brazilian Real",
  "btc": "Bitcoin",
  "cad": "Canadian Dollar",
  "chf": "Swiss Franc",
  "clp": "Chilean Peso",
  "cny": "Chinese Yuan",
  "czk": "Czech Koruna",
  "dkk": "Danish Krone",
  "dot": "Polkadot",
  "eos": "EOS",
  "eth": "Ethereum",
  "eur": "Euro",
  "gbp": "British Pound",
  "hkd": "Hong-",
  "huf": "Hong Kong Dollar",
  "idr": "Indonesian Rupiah",
  "ils": "Israeli New Shekel",
  "inr": "Indian Rupee",
  "jpy": "Japanese Yen",
  "krw": "South Korean",
  "kwd": "Kuwaiti Dinar",
  "lkr": "Sri Lankan Rupee",
  "ltc": "Litecoin",
  "mmk": "Myanmar Kyat",
  "mxn": "Mexican Peso",
  "myr": "Malaysian Ringgit",
  "ngn": "Nigerian Naira",
  "nok": "Norwegian Krone",
  "nzd": "New Zealand Dollar",
  "php": "Philippine Peso",
  "pkr": "Pakistani Rupee",
  "pln": "Polish złoty",
  "rub": "Russian Ruble",
  "sar": "Saudi Riyal",
  "sek": "Swedish Krona",
  "sgd": "Singapore Dollar",
  "thb": "Thai Baht",
  "try": "Turkish Lira",
  "twd": "New Taiwan Dollar",
  "uah": "Ukrainian hryvnia",
  "usd": "United States Dollar",
  "vef": "Venezuelan Bolívar",
  "vnd": "Vietnamese dong",
  "xag": "Silver",
  "xau": "Gold",
  "xdr": "Special Drawing Rights",
  "xlm": "Stellar Lumens",
  "xrp": "Ripple",
  "yfi": "Yearn.finance",
  "zar": "South African Rand",
  "bits": "Bit",
  "link": "Chainlink",
  "sats": "Satoshi"
};
