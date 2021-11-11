import 'package:coind/domain/coin_data.dart';
import 'package:coind/repository/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:coind/repository/preferences.dart';
import 'package:coind/widgets/crypto_data.dart';

class FavouritesRoute extends StatefulWidget {
  const FavouritesRoute({Key? key}) : super(key: key);

  @override
  _FavourtiesRouteState createState() => _FavourtiesRouteState();
}

class _FavourtiesRouteState extends State<FavouritesRoute> {
  final SharedPreferencesHelper _helper = SharedPreferencesHelper();
  late Future<UserPreferences> preferences;

  @override
  void initState() {
    super.initState();
    preferences = _helper.getPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserPreferences>(
      future: preferences,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<String> coins = snapshot.data!.coins;

          return DefaultTabController(
              length: coins.length,
              child: Scaffold(
                  appBar: AppBar(
                    title: Text(Translations.of(context)!.navigation_favorites),
                    bottom: TabBar(
                      tabs: coins.map((coin) {
                        String name =
                            coin.substring(coin.indexOf(':') + 1, coin.length);
                        return Tab(
                          text: name.toUpperCase(),
                        );
                      }).toList(),
                      isScrollable: true,
                    ),
                  ),
                  body: TabBarView(
                    children: coins.map((coin) {
                      String id = coin.substring(0, coin.indexOf(':'));

                      return CryptoDataTab(
                        coinId: id,
                        preferences: snapshot.data!,
                      );
                    }).toList(),
                  )));
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class CryptoDataTab extends StatelessWidget {
  const CryptoDataTab(
      {Key? key, required this.coinId, required this.preferences})
      : super(key: key);

  final String coinId;
  final UserPreferences preferences;

  @override
  Widget build(BuildContext context) {
    Future<Coin> coin = Store.fetchCoinData(coinId);
    return FutureBuilder<Coin>(
        future: coin,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return CryptoDataWidget(
                coin: snapshot.data!, preferences: preferences, coinId: coinId);
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          return const Center(child: CircularProgressIndicator());
        });
  }
}
