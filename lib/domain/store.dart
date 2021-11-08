import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:coind/domain/coin_data.dart';
import 'package:coind/domain/market.dart';
import 'package:coind/domain/market_graph_data.dart';

class Store {
  static const endPoint = "https://api.coingecko.com/api/v3/coins";

  static Future<List<Market>> fetchCoins(
      {String currency = 'usd',
      String desc = 'market_cap_desc',
      int count = 50,
      int page = 1}) async {
    final response = await http.get(Uri.parse(
        '$endPoint/markets?vs_currency=$currency&order=$desc&per_page=$count&page=$page&sparkline=false'));

    if (response.statusCode == 200) {
      Iterable data = jsonDecode(response.body);
      return data.map((market) {
        return Market.fromJson(market);
      }).toList();
    } else {
      return Future.error(response.statusCode.toString());
    }
  }

  static Future<Coin> fetchCoinData(
    String id, {
    bool localization = false,
    bool tickers = false,
    bool marketData = true,
    bool communityData = false,
    bool developerData = false,
    bool sparkline = false,
  }) async {
    final response = await http.get(Uri.parse(
        '$endPoint/$id?localization=$localization\$tickers=$tickers\$community_data=$communityData\$developer_data=$developerData\$sparkline=$sparkline'));

    if (response.statusCode == 200) {
      return Coin.fromJson(jsonDecode(response.body));
    } else {
      return Future.error(response.statusCode.toString());
    }
  }

  static Future<MarketChart> fetchMarketChart(
      String id, String currency, int days) async {
    final response = await http.get(Uri.parse(
        '$endPoint/$id/market_chart?vs_currency=$currency&days=$days'));

    if (response.statusCode == 200) {
      return MarketChart.fromJson(jsonDecode(response.body));
    } else {
      return Future.error(response.statusCode.toString());
    }
  }
}
