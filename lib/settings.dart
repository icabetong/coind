import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data.dart';

class SettingsRoute extends StatefulWidget {
  const SettingsRoute({Key? key}) : super(key: key);

  @override
  _SettingsRouteState createState() => _SettingsRouteState();
}

class _SettingsRouteState extends State<SettingsRoute> {
  SharedPreferencesHelper helper = SharedPreferencesHelper();
  String currency = "usd";

  @override
  void initState() {
    super.initState();
    helper.getCurrency().then((c) {
      setState(() {
        currency = c ?? "usd";
      });
    });
  }

  void _navigateToCurrencySelection(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CurrenciesScreen(currency: currency)));

    helper.setCurrency(result);
    setState(() {
      currency = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(Translations.of(context)!.navigation_settings),
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back))),
      body: SettingsList(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        sections: [
          SettingsSection(
            title: Translations.of(context)!.settings_group_localization,
            tiles: [
              SettingsTile(
                title: Translations.of(context)!.settings_currency,
                subtitle: currencyNames[currency],
                leading: const Icon(Icons.attach_money),
                onPressed: (BuildContext context) {
                  _navigateToCurrencySelection(context);
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}

class CurrenciesScreen extends StatefulWidget {
  final String currency;

  const CurrenciesScreen({Key? key, required this.currency}) : super(key: key);

  @override
  _CurrenciesScreenState createState() => _CurrenciesScreenState();
}

class _CurrenciesScreenState extends State<CurrenciesScreen> {
  SharedPreferencesHelper helper = SharedPreferencesHelper();
  int currencyIndex = 0;

  @override
  void initState() {
    super.initState();
    currencyIndex = currencies.indexOf(widget.currency);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(Translations.of(context)!.select_currency)),
        body: SettingsList(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          sections: [
            SettingsSection(
                tiles: currencies
                    .asMap()
                    .entries
                    .map((e) => SettingsTile(
                          title: currencyNames[e.value] ?? "",
                          leading: trailingWidget(e.key),
                          onPressed: (BuildContext context) {
                            change(context, e.key);
                          },
                        ))
                    .toList())
          ],
        ));
  }

  Widget trailingWidget(int index) {
    return (index == currencyIndex)
        ? const Icon(Icons.check, color: Colors.white)
        : const Icon(null);
  }

  void change(BuildContext context, int index) {
    setState(() {
      currencyIndex = index;
    });
    Navigator.pop(context, currencies[index]);
  }
}

class SharedPreferencesHelper {
  late SharedPreferences sharedPreferences;

  Future<String?> getCurrency() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String? t = sharedPreferences.getString("currency");
    return t;
  }

  Future<void> setCurrency(String currency) async {
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("currency", currency);
  }
}
