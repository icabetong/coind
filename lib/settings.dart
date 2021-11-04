import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsRoute extends StatefulWidget {
  const SettingsRoute({Key? key}) : super(key: key);

  @override
  _SettingsRouteState createState() => _SettingsRouteState();
}

class _SettingsRouteState extends State<SettingsRoute> {
  SharedPreferencesHelper helper = SharedPreferencesHelper();
  String currency = "php";

  @override
  void initState() {
    super.initState();
    helper.getCurrency().then((c) {
      setState(() {
        currency = c!;
      });
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
                subtitle: currency,
                leading: const Icon(Icons.attach_money),
                onPressed: (BuildContext context) {
                  Navigator.of(context).push(CupertinoPageRoute(
                      builder: (_) => CurrenciesScreen(
                            currency: currency,
                          )));
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
  var currencies = ['php', 'usd'];
  int currencyIndex = 0;

  @override
  void initState() {
    super.initState();
    currencyIndex = currencies.indexOf(widget.currency);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(Translations.of(context)!.app_name)),
        body: SettingsList(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          sections: [
            SettingsSection(tiles: [
              SettingsTile(
                title: "PHP",
                leading: trailingWidget(0),
                onPressed: (BuildContext context) {
                  change(0);
                },
              ),
              SettingsTile(
                title: "USD",
                leading: trailingWidget(1),
                onPressed: (BuildContext context) {
                  change(1);
                },
              )
            ])
          ],
        ));
  }

  Widget trailingWidget(int index) {
    return (index == currencyIndex)
        ? const Icon(Icons.check, color: Colors.white)
        : const Icon(null);
  }

  void change(int index) {
    setState(() {
      currencyIndex = index;
      helper.setCurrency(currencies[index]);
    });
  }
}

class SharedPreferencesHelper {
  late SharedPreferences sharedPreferences;

  Future<String?> getCurrency() async {
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.getString("currency");
  }

  Future<void> setCurrency(String currency) async {
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("currency", currency);
  }
}
