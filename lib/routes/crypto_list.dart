import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:coind/domain/market.dart';
import 'package:coind/domain/store.dart';
import 'package:coind/routes/settings.dart';
import 'package:coind/routes/crypto.dart';

class CryptoListRoute extends StatefulWidget {
  const CryptoListRoute({Key? key}) : super(key: key);

  @override
  _CryptoListRouteState createState() => _CryptoListRouteState();
}

class _CryptoListRouteState extends State<CryptoListRoute> {
  SharedPreferencesHelper helper = SharedPreferencesHelper();
  UserPreferences preferences = UserPreferences.getDefault();
  List<String> currencies = [];
  final PagingController<int, Market> controller =
      PagingController(firstPageKey: 1);

  late Future<List<Market>> coins;

  void _prepare() {
    setState(() {
      helper.getPreferences().then((value) {
        preferences = value;
        currencies = preferences.coins;
      });
    });
  }

  void _addToFavorites(String currency) {
    if (!currencies.contains(currency)) {
      currencies.add(currency);
      setState(() {
        currencies = currencies;
      });

      helper.setCoins(currencies);
    }
  }

  void _removeFromFavorites(String currency) {
    if (currencies.contains(currency)) {
      currencies.remove(currency);
      setState(() {
        currencies = currencies;
      });

      helper.setCoins(currencies);
    }
  }

  Widget trailingWidget(String currency) {
    return currencies.contains(currency)
        ? IconButton(
            icon: const Icon(Icons.star_rounded, color: Colors.amber),
            onPressed: () {
              _removeFromFavorites(currency);
            },
          )
        : IconButton(
            icon: const Icon(Icons.star_outline_rounded),
            onPressed: () {
              _addToFavorites(currency);
            });
  }

  Future<void> fetch(int page) async {
    try {
      final newItems =
          await Store.fetchCoins(currency: preferences.currency, page: page);

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
    _prepare();
    controller.addPageRequestListener((pageKey) {
      fetch(pageKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    NumberFormat numberFormat =
        NumberFormat.currency(symbol: preferences.currency.toUpperCase());

    return Scaffold(
        appBar: AppBar(
            title: Text(Translations.of(context)!.navigation_cryptocurrencies)),
        body: RefreshIndicator(
            backgroundColor: Theme.of(context).colorScheme.surface,
            onRefresh: () async {
              _prepare();
            },
            child: PagedListView<int, Market>.separated(
                pagingController: controller,
                builderDelegate: PagedChildBuilderDelegate<Market>(
                    itemBuilder: (context, item, index) => ListTile(
                        trailing: trailingWidget(item.id),
                        leading: FadeInImage.memoryNetwork(
                            width: 36,
                            height: 36,
                            placeholder: kTransparentImage,
                            image: item.image),
                        title: Text(item.name),
                        subtitle: Text(numberFormat.format(item.currentPrice)),
                        onTap: () {
                          Navigator.pushNamed(context, CryptoRoute.routeName,
                              arguments: CryptoRouteArguments(id: item.id));
                        })),
                separatorBuilder: (context, index) => const Divider())));
  }
}
