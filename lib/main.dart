import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  ThemeData construct() {
    final base = ThemeData.dark();
    const mainColor = Color(0xff322f44);
    return base.copyWith(
        scaffoldBackgroundColor: mainColor,
        primaryColor: Colors.indigo,
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
            )));
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coind',
      theme: construct(),
      home: const HomePage(title: 'Coind'),
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
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(title: Text(widget.title.toUpperCase())),
        body: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: const [Expanded(child: CryptoDataCard())],
                ))));
  }
}
