import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:coind/routes/crypto_data.dart';
import 'package:coind/routes/settings.dart';

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

  @override
  void initState() {
    super.initState();
    setState(() {
      helper.getPreferences().then((value) {
        preferences = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as CryptoRouteArguments;

    return Scaffold(
        appBar: AppBar(title: Text(Translations.of(context)!.app_name)),
        body: CryptoDataRoute(cryptoId: args.id));
  }
}
