import 'package:coind/domain/coin_data.dart';
import 'package:coind/repository/store.dart';
import 'package:coind/widgets/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:coind/repository/preferences.dart';
import 'package:coind/widgets/crypto_data.dart';

class CryptoRouteArguments {
  final String id;

  CryptoRouteArguments({required this.id});
}

class CryptoRoute extends StatefulWidget {
  static const routeName = "/crypto";

  const CryptoRoute({Key? key}) : super(key: key);

  @override
  State<CryptoRoute> createState() => _CryptoRouteState();
}

class _CryptoRouteState extends State<CryptoRoute> {
  SharedPreferencesHelper helper = SharedPreferencesHelper();
  UserPreferences preferences = UserPreferences.getDefault();

  late Future<Coin> coin;

  @override
  void initState() {
    super.initState();
    final args =
        ModalRoute.of(context)!.settings.arguments as CryptoRouteArguments;
    setState(() {
      helper.getPreferences().then((value) {
        preferences = value;
        coin = Store.fetchCoinData(args.id);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(Translations.of(context)!.app_name)),
        body: FutureBuilder<Coin>(
            future: coin,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return CryptoDataWidget(
                  coin: snapshot.data!,
                  coinId: snapshot.data!.id,
                  preferences: preferences,
                );
              } else if (snapshot.hasError) {
                return const ErrorState();
              }
              return const Center(child: CircularProgressIndicator());
            }));
  }
}
