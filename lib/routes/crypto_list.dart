import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CryptoListRoute extends StatefulWidget {
  const CryptoListRoute({Key? key}) : super(key: key);

  @override
  _CryptoListRouteState createState() => _CryptoListRouteState();
}

class _CryptoListRouteState extends State<CryptoListRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(Translations.of(context)!.app_name)),
        body: Row());
  }
}
