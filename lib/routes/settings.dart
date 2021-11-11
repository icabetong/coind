import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:coind/domain/market.dart';
import 'package:coind/l10n/locales.dart';
import 'package:coind/l10n/formatters.dart';
import 'package:coind/repository/preferences.dart';
import 'package:coind/repository/store.dart';

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

  void _navigateToCryptoSelection(BuildContext context) async {
    final result = await Navigator.push(
        context,
        PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                CryptoCurrencyScreen(
                    crypto: preferences.defaultCrypto,
                    currency: preferences.currency),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return SharedAxisTransition(
                  child: child,
                  animation: animation,
                  secondaryAnimation: secondaryAnimation,
                  transitionType: SharedAxisTransitionType.horizontal);
            }));

    if (result != null) {
      preferences.defaultCrypto = result;
      save(preferences);
      helper.setDefaultCrypto(result);
    }
  }

  void _navigateToCurrencySelection(BuildContext context) async {
    final result = await Navigator.push(
        context,
        PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                CurrenciesScreen(currency: preferences.currency),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return SharedAxisTransition(
                  child: child,
                  animation: animation,
                  secondaryAnimation: secondaryAnimation,
                  transitionType: SharedAxisTransitionType.horizontal);
            }));

    if (result != null) {
      preferences.currency = result;
      save(preferences);
      helper.setCurrency(result);
    }
  }

  void _navigateToLangugeSelection(BuildContext context) async {
    final result = await Navigator.push(
        context,
        PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                LanguagesScreen(language: preferences.language),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return SharedAxisTransition(
                  child: child,
                  animation: animation,
                  secondaryAnimation: secondaryAnimation,
                  transitionType: SharedAxisTransitionType.horizontal);
            }));

    if (result != null) {
      preferences.language = result;
      save(preferences);
      helper.setLanguage(result);
      Translations.delegate.load(Locale(preferences.language));
    }
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
                ),
                SettingsTile(
                  title: Translations.of(context)!.settings_default_crypto,
                  subtitle: preferences.defaultCrypto.substring(
                      preferences.defaultCrypto.indexOf(':') + 1,
                      preferences.defaultCrypto.length),
                  leading: const Icon(Icons.monetization_on_outlined),
                  onPressed: (BuildContext context) async {
                    _navigateToCryptoSelection(context);
                  },
                ),
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

class CryptoCurrencyScreen extends StatefulWidget {
  final String crypto;
  final String currency;

  const CryptoCurrencyScreen(
      {Key? key, required this.crypto, required this.currency})
      : super(key: key);

  @override
  _CryptoCurrencyScreenState createState() => _CryptoCurrencyScreenState();
}

class _CryptoCurrencyScreenState extends State<CryptoCurrencyScreen> {
  final PagingController<int, Market> controller =
      PagingController(firstPageKey: 1);
  late String crypto;

  Future<void> fetch(int page) async {
    try {
      final newItems =
          await Store.fetchCoins(currency: widget.currency, page: page);

      final isLastPage = newItems.length < Store.pageSize;
      if (isLastPage) {
        controller.appendLastPage(newItems);
      } else {
        final int nextPage = page + 1;
        controller.appendPage(newItems, nextPage);
      }
    } catch (error) {
      controller.error = error;
    }
  }

  @override
  void initState() {
    super.initState();
    crypto = widget.crypto;
    controller.addPageRequestListener((pageKey) {
      fetch(pageKey);
    });
  }

  Widget _trailingWidget(String id) {
    return id == widget.crypto.substring(0, widget.crypto.indexOf(":"))
        ? const Icon(Icons.check)
        : const Icon(null);
  }

  void _change(BuildContext context, Market market) {
    String newCrypto = "${market.id}:${market.name}";
    setState(() {
      crypto = newCrypto;
    });
    Navigator.pop(context, newCrypto);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(Translations.of(context)!.select_crypto)),
        body: PagedListView<int, Market>.separated(
            pagingController: controller,
            builderDelegate: PagedChildBuilderDelegate<Market>(
                itemBuilder: (context, item, index) => ListTile(
                    trailing: _trailingWidget(item.id),
                    leading: FadeInImage.memoryNetwork(
                        width: 36,
                        height: 36,
                        placeholder: kTransparentImage,
                        image: item.image),
                    title: Text(item.name),
                    subtitle: Text(formatCurrency(item.currentPrice)),
                    onTap: () {
                      _change(context, item);
                    })),
            separatorBuilder: (context, index) => const Divider()));
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
      body: ListView.separated(
          separatorBuilder: (context, index) => const Divider(),
          itemCount: currencies.length,
          itemBuilder: (context, index) => ListTile(
                title: Text(currencies[index].toUpperCase()),
                subtitle: Text(currencyNames[currencies[index]] ?? ""),
                trailing: _trailingWidget(currencies[index]),
                onTap: () {
                  _change(context, currencies[index]);
                },
              )),
    );
  }

  Widget _trailingWidget(String currency) {
    return (currentCurrency == currency)
        ? const Icon(Icons.check, color: Colors.white)
        : const Icon(null);
  }

  void _change(BuildContext context, String currency) {
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
        body: ListView.separated(
          separatorBuilder: (context, index) => const Divider(),
          itemCount: languages.length,
          itemBuilder: (context, index) => ListTile(
              title: Text(languageNames[languages[index]] ?? ""),
              trailing: _trailingWidget(languages[index]),
              onTap: () {
                _change(context, languages[index]);
              }),
        ));
  }

  Widget _trailingWidget(String language) {
    return (currentLanguage == language)
        ? const Icon(Icons.check, color: Colors.white)
        : const Icon(null);
  }

  void _change(BuildContext context, String language) {
    setState(() {
      currentLanguage = language;
    });
    Navigator.pop(context, language);
  }
}
