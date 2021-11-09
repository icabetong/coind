import 'package:animations/animations.dart';
import 'package:coind/routes/about.dart';
import 'package:coind/routes/crypto_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'l10n/l10n.dart';
import 'routes/crypto_data.dart';
import 'routes/crypto.dart';
import 'routes/settings.dart';

void main() {
  runApp(const Coind());
}

class Coind extends StatelessWidget {
  const Coind({Key? key}) : super(key: key);

  ThemeData construct() {
    final base = ThemeData(brightness: Brightness.dark, fontFamily: 'Rubik');
    const mainColor = Color(0xff322f44);
    const secondaryColor = Color(0xff29ccb9);
    return base.copyWith(
      dialogBackgroundColor: Color.lerp(mainColor, Colors.white, 0.1),
      canvasColor: mainColor,
      bottomSheetTheme: base.bottomSheetTheme
          .copyWith(backgroundColor: Color.lerp(mainColor, Colors.white, 0.05)),
      scaffoldBackgroundColor: mainColor,
      backgroundColor: mainColor,
      colorScheme: base.colorScheme.copyWith(
          primary: secondaryColor,
          background: mainColor,
          surface: Color.lerp(mainColor, Colors.white, 0.2)),
      cardColor: Color.lerp(mainColor, Colors.white, 0.2),
      cardTheme: base.cardTheme.copyWith(
          color: Color.lerp(mainColor, Colors.black, 0.1),
          margin: const EdgeInsets.all(16.0),
          elevation: 0.0),
      appBarTheme: base.appBarTheme.copyWith(
          backgroundColor: mainColor,
          elevation: 0.0,
          centerTitle: true,
          titleTextStyle: base.appBarTheme.titleTextStyle?.copyWith(
            color: Color.lerp(mainColor, Colors.white, 0.7),
          )),
      progressIndicatorTheme:
          base.progressIndicatorTheme.copyWith(color: secondaryColor),
      popupMenuTheme: base.popupMenuTheme.copyWith(
          color: Color.lerp(mainColor, Colors.white, 0.1),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)))),
      dialogTheme: base.dialogTheme
          .copyWith(backgroundColor: Color.lerp(mainColor, Colors.white, 0.1)),
      chipTheme: base.chipTheme
          .copyWith(backgroundColor: Color.lerp(mainColor, Colors.white, 0.1)),
      textTheme: base.textTheme.copyWith(
          headline4: const TextStyle(color: Colors.white),
          headline6: const TextStyle(color: Colors.white),
          overline: const TextStyle(color: Colors.white)),
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {CryptoRoute.routeName: (context) => const CryptoRoute()},
      supportedLocales: L10n.all,
      localizationsDelegates: const [
        Translations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      title: Translations.of(context)?.app_name ?? "Coind",
      theme: construct(),
      home: HomePage(title: Translations.of(context)?.app_name ?? "Coind"),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SharedPreferencesHelper helper = SharedPreferencesHelper();
  UserPreferences userPreferences = UserPreferences.getDefault();

  @override
  void initState() {
    super.initState();
    helper.getPreferences().then((value) {
      userPreferences = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title.toUpperCase()),
        leading: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const CryptoListRoute(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return SharedAxisTransition(
                            child: child,
                            animation: animation,
                            secondaryAnimation: secondaryAnimation,
                            transitionType:
                                SharedAxisTransitionType.horizontal);
                      }));
            },
            child: const Icon(Icons.menu)),
        actions: <Widget>[
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: "action:settings",
                  child: Text(Translations.of(context)!.navigation_settings),
                ),
                PopupMenuItem<String>(
                    value: "action:about",
                    child: Text(Translations.of(context)!.navigation_about))
              ];
            },
            onSelected: (result) {
              switch (result) {
                case "action:settings":
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SettingsRoute()));
                  break;
                case "action:about":
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AboutRoute()));
                  break;
                default:
                  break;
              }
            },
          )
        ],
      ),
      body: const SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: CryptoDataRoute()),
    );
  }
}
