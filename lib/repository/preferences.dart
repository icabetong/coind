import 'package:shared_preferences/shared_preferences.dart';

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
