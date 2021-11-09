import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:coind/domain/locales_static.dart';

class SettingsRoute extends StatefulWidget {
  const SettingsRoute({Key? key}) : super(key: key);

  @override
  _SettingsRouteState createState() => _SettingsRouteState();
}

class _SettingsRouteState extends State<SettingsRoute> {
  SharedPreferencesHelper helper = SharedPreferencesHelper();
  UserPreferences preferences = UserPreferences.getDefault();
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    helper.getPreferences().then((p) {
      setState(() {
        preferences = p;
        controller = TextEditingController.fromValue(
            TextEditingValue(text: preferences.daysInterval.toString()));
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void save(UserPreferences preferences) {
    setState(() {
      this.preferences = preferences;
    });
  }

  _showDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title:
                  Text(Translations.of(context)!.settings_graph_data_interval),
              content: TextField(
                autofocus: true,
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: Translations.of(context)!.field_days_interval),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(Translations.of(context)!.button_cancel),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: Text(Translations.of(context)!.button_save),
                  onPressed: () {
                    Navigator.pop(context, controller.text);
                  },
                )
              ]);
        });
  }

  void _navigateToCurrencySelection(BuildContext context) async {
    final result = await Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) =>
                CurrenciesScreen(currency: preferences.currency)));

    preferences.currency = result;
    save(preferences);
    helper.setCurrency(result);
  }

  void _navigateToLangugeSelection(BuildContext context) async {
    final result = await Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) =>
                LanguagesScreen(language: preferences.language)));
    preferences.language = result;
    save(preferences);
    helper.setLanguage(result);
    Translations.delegate.load(Locale(preferences.language));
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
              title: Translations.of(context)!.settings_group_data,
              tiles: [
                SettingsTile(
                  title: Translations.of(context)!.settings_graph_data_interval,
                  subtitle: Translations.of(context)!
                      .settings_graph_data_interval_summary(
                          preferences.daysInterval),
                  leading: const Icon(Icons.timeline_outlined),
                  onPressed: (BuildContext context) async {
                    String? result = await _showDialog(context);
                    if (result != null) {
                      int days = int.parse(result);
                      helper.setDaysInterval(days);
                    }
                  },
                )
              ]),
          SettingsSection(
            title: Translations.of(context)!.settings_group_region,
            tiles: [
              SettingsTile(
                title: Translations.of(context)!.settings_currency,
                subtitle: currencyNames[preferences.currency],
                leading: const Icon(Icons.attach_money),
                onPressed: (BuildContext context) {
                  _navigateToCurrencySelection(context);
                },
              ),
              SettingsTile(
                title: Translations.of(context)!.settings_language,
                subtitle: languageNames[preferences.language],
                leading: const Icon(Icons.language_outlined),
                onPressed: (BuildContext context) {
                  _navigateToLangugeSelection(context);
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
  String currentCurrency = "";

  @override
  void initState() {
    super.initState();
    currentCurrency = widget.currency;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(Translations.of(context)!.select_currency),
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context, currentCurrency);
              },
              child: const Icon(Icons.arrow_back)),
        ),
        body: ListView(
          children: currencies
              .map((currency) => ListTile(
                    title: Text(currencyNames[currency] ?? ""),
                    leading: trailingWidget(currency),
                    onTap: () {
                      change(context, currency);
                    },
                  ))
              .toList(),
        ));
  }

  Widget trailingWidget(String currency) {
    return (currentCurrency == currency)
        ? const Icon(Icons.check, color: Colors.white)
        : const Icon(null);
  }

  void change(BuildContext context, String currency) {
    setState(() {
      currentCurrency = currency;
    });
    Navigator.pop(context, currency);
  }
}

class LanguagesScreen extends StatefulWidget {
  final String language;

  const LanguagesScreen({Key? key, required this.language}) : super(key: key);

  @override
  _LanguagesScreenState createState() => _LanguagesScreenState();
}

class _LanguagesScreenState extends State<LanguagesScreen> {
  String currentLanguage = "";

  @override
  void initState() {
    super.initState();
    currentLanguage = widget.language;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(Translations.of(context)!.select_language),
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context, currentLanguage);
              },
              child: const Icon(Icons.arrow_back)),
        ),
        body: ListView(
            children: languages
                .map((language) => ListTile(
                    title: Text(languageNames[language] ?? ""),
                    leading: trailingWidget(language),
                    onTap: () {
                      change(context, language);
                    }))
                .toList()));
  }

  Widget trailingWidget(String language) {
    return (currentLanguage == language)
        ? const Icon(Icons.check, color: Colors.white)
        : const Icon(null);
  }

  void change(BuildContext context, String language) {
    setState(() {
      currentLanguage = language;
    });
    Navigator.pop(context, language);
  }
}

class UserPreferences {
  List<String> coins;
  String currency;
  String language;
  int daysInterval;

  UserPreferences(
      {this.currency = 'php',
      this.language = 'en',
      this.daysInterval = 2,
      this.coins = const ['smooth-love-potion']});

  static UserPreferences getDefault() {
    return UserPreferences();
  }
}

class SharedPreferencesHelper {
  late SharedPreferences sharedPreferences;

  Future<UserPreferences> getPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
    UserPreferences userPreferences = UserPreferences();
    userPreferences.currency = sharedPreferences.getString("currency") ?? "usd";
    userPreferences.language = sharedPreferences.getString("language") ?? "en";
    userPreferences.daysInterval =
        sharedPreferences.getInt("daysInterval") ?? 2;
    userPreferences.coins =
        sharedPreferences.getStringList("coins") ?? ['smooth-love-potion'];
    return userPreferences;
  }

  void setPreferences(UserPreferences userPreferences) async {
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('currency', userPreferences.currency);
    sharedPreferences.setString('language', userPreferences.language);
    sharedPreferences.setStringList("coins", userPreferences.coins);
    sharedPreferences.setInt('daysInterval', 2);
  }

  Future<bool> setCurrency(String currency) async {
    sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString('currency', currency);
  }

  Future<bool> setLanguage(String language) async {
    sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString('language', language);
  }

  Future<bool> setDaysInterval(int daysInterval) async {
    sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setInt('daysInterval', daysInterval);
  }

  Future<bool> setCoins(List<String> coins) async {
    sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setStringList('coins', coins);
  }
}
