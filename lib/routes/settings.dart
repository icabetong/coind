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

  @override
  void initState() {
    super.initState();
    helper.getPreferences().then((p) {
      setState(() {
        preferences = p;
      });
    });
  }

  void save(UserPreferences preferences) {
    setState(() {
      this.preferences = preferences;
    });
    helper.setPreferences(preferences);
  }

  void _navigateToCurrencySelection(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                CurrenciesScreen(currency: preferences.currency)));

    preferences.currency = result;
    save(preferences);
  }

  void _navigateToLangugeSelection(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                LanguagesScreen(language: preferences.language)));
    preferences.language = result;
    save(preferences);
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
                    title:
                        Translations.of(context)!.settings_graph_data_interval,
                    leading: const Icon(Icons.timeline_outlined))
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
  int currencyIndex = 0;

  @override
  void initState() {
    super.initState();
    currencyIndex = currencies.indexOf(widget.currency);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(Translations.of(context)!.select_currency),
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context, currencies[currencyIndex]);
              },
              child: const Icon(Icons.arrow_back)),
        ),
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

class LanguagesScreen extends StatefulWidget {
  final String language;

  const LanguagesScreen({Key? key, required this.language}) : super(key: key);

  @override
  _LanguagesScreenState createState() => _LanguagesScreenState();
}

class _LanguagesScreenState extends State<LanguagesScreen> {
  int languageIndex = 0;

  @override
  void initState() {
    super.initState();
    languageIndex = languages.indexOf(widget.language);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(Translations.of(context)!.select_language),
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context, languages[languageIndex]);
              },
              child: const Icon(Icons.arrow_back)),
        ),
        body: SettingsList(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          sections: [
            SettingsSection(
                tiles: languages
                    .asMap()
                    .entries
                    .map((e) => SettingsTile(
                          title: languageNames[e.value] ?? "",
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
    return (index == languageIndex)
        ? const Icon(Icons.check, color: Colors.white)
        : const Icon(null);
  }

  void change(BuildContext context, int index) {
    setState(() {
      languageIndex = index;
    });
    Navigator.pop(context, languages[index]);
  }
}

class UserPreferences {
  String currency;
  String language;

  UserPreferences({this.currency = 'usd', this.language = 'en'});

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
    return userPreferences;
  }

  void setPreferences(UserPreferences userPreferences) async {
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('currency', userPreferences.currency);
    sharedPreferences.setString('language', userPreferences.language);
  }

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
