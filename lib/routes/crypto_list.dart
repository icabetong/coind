import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:coind/domain/coin_data.dart';
import 'package:coind/domain/store.dart';

class CryptoListRoute extends StatefulWidget {
  const CryptoListRoute({Key? key}) : super(key: key);

  @override
  _CryptoListRouteState createState() => _CryptoListRouteState();
}

class _CryptoListRouteState extends State<CryptoListRoute> {
  late Future<List<Coin>> coins;

  @override
  void initState() {
    super.initState();
    coins = Store.fetchCoins();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(Translations.of(context)!.navigation_cryptocurrencies)),
        body: FutureBuilder<List<Coin>>(
          future: coins,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              ListView.builder(itemBuilder: (context, index) {
                return Text(snapshot.data![index].name);
              });
            } else if (snapshot.hasError) {
              Text(Translations.of(context)!.error_fetch_data);
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }
}
