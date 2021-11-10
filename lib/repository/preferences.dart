import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  List<String> coins;
  String defaultCrypto;
  String currency;
  String language;
  int daysInterval;

  static const _initDefaultCrypto = 'smooth-love-potion:Smooth Love Potion';
  static const _initCurrency = 'php';
  static const _initLanguage = 'en';
  static const _initDaysInterval = 2;

  UserPreferences(
      {this.defaultCrypto = _initDefaultCrypto,
      this.currency = _initCurrency,
      this.language = _initLanguage,
      this.daysInterval = _initDaysInterval,
      this.coins = const [_initDefaultCrypto]});

  static UserPreferences getDefault() {
    return UserPreferences();
  }
}

class SharedPreferencesHelper {
  late SharedPreferences sharedPreferences;

  Future<UserPreferences> getPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
    UserPreferences userPreferences = UserPreferences();
    userPreferences.defaultCrypto =
        sharedPreferences.getString("widgetCrypto") ??
            UserPreferences._initDefaultCrypto;
    userPreferences.currency = sharedPreferences.getString("currency") ??
        UserPreferences._initCurrency;
    userPreferences.language = sharedPreferences.getString("language") ??
        UserPreferences._initLanguage;
    userPreferences.daysInterval = sharedPreferences.getInt("daysInterval") ??
        UserPreferences._initDaysInterval;
    userPreferences.coins = sharedPreferences.getStringList("coins") ??
        [UserPreferences._initDefaultCrypto];
    return userPreferences;
  }

  Future<bool> setDefaultCrypto(String defaultCrypto) async {
    sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setString('defaultCrypto', defaultCrypto);
  }

  Future<String> getDefaultCrypto() async {
    sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString('defaultCrypto') ??
        "smooth-love-potion:Smooth Love Potion";
  }

  Future<bool> setCurrency(String currency) async {
    sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString('currency', currency);
  }

  Future<String> getCurrency() async {
    sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString('currency') ?? 'usd';
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
