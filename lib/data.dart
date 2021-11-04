class Coin {
  final String id;
  final String symbol;
  final String name;
  final String lastUpdated;
  final Map<String, double> currentPrices;
  final Map<String, dynamic> allTimeHigh;
  final Map<String, double> allTimeHighChange;
  final Map<String, String> allTimeHighDate;
  final Map<String, dynamic> allTimeLow;
  final Map<String, double> allTimeLowChange;
  final Map<String, String> allTimeLowDate;
  final Map<String, int> marketCap;
  final int marketCapRank;
  final Map<String, int> totalVolume;
  final Map<String, double> highest24h;
  final Map<String, double> lowest24h;
  final Map<String, double> highest7d;
  final Map<String, double> lowest7d;
  final double priceChange24h;

  Coin(
      {required this.id,
      required this.symbol,
      required this.name,
      required this.lastUpdated,
      required this.currentPrices,
      required this.allTimeHigh,
      required this.allTimeHighChange,
      required this.allTimeHighDate,
      required this.allTimeLow,
      required this.allTimeLowChange,
      required this.allTimeLowDate,
      required this.marketCap,
      required this.marketCapRank,
      required this.totalVolume,
      required this.highest24h,
      required this.lowest24h,
      required this.highest7d,
      required this.lowest7d,
      required this.priceChange24h});

  factory Coin.fromJson(Map<String, dynamic> json) {
    return Coin(
        id: json['id'],
        symbol: json['symbol'],
        name: json['name'],
        lastUpdated: json['last_updated'],
        currentPrices:
            Map<String, double>.from(json['market_data']['current_price']),
        allTimeHigh: Map<String, dynamic>.from(json['market_data']['ath']),
        allTimeHighChange: Map<String, double>.from(
            json['market_data']['ath_change_percentage']),
        allTimeHighDate:
            Map<String, String>.from(json['market_data']['ath_date']),
        allTimeLow: Map<String, double>.from(json['market_data']['atl']),
        allTimeLowChange: Map<String, double>.from(
            json['market_data']['atl_change_percentage']),
        allTimeLowDate:
            Map<String, String>.from(json['market_data']['atl_date']),
        marketCap: Map<String, int>.from(json['market_data']['market_cap']),
        marketCapRank: json['market_data']['market_cap_rank'],
        totalVolume: Map<String, int>.from(json['market_data']['total_volume']),
        highest24h: Map<String, double>.from(json['market_data']['high_24h']),
        lowest24h: Map<String, double>.from(json['market_data']['low_24h']),
        highest7d: Map<String, double>.from(json['market_data']['high_7d']),
        lowest7d: Map<String, double>.from(json['market_data']['low_7d']),
        priceChange24h: json['market_data']['price_change_24h']);
  }
}

class MarketChart {
  final List<dynamic> prices;
  final List<dynamic> marketCaps;
  final List<dynamic> totalVolume;

  MarketChart(
      {required this.prices,
      required this.marketCaps,
      required this.totalVolume});

  factory MarketChart.fromJson(Map<String, dynamic> json) {
    return MarketChart(
        prices: List<dynamic>.from(json['prices']),
        marketCaps: List<dynamic>.from(json['market_caps']),
        totalVolume: List<dynamic>.from(json['total_volumes']));
  }
}

var currencies = [
  "aed",
  "ars",
  "aud",
  "bch",
  "bdt",
  "bhd",
  "bmd",
  "bnb",
  "brl",
  "btc",
  "cad",
  "chf",
  "clp",
  "cny",
  "czk",
  "dkk",
  "dot",
  "eos",
  "eth",
  "eur",
  "gbp",
  "hkd",
  "idr",
  "inr",
  "jpy",
  "krw",
  "kwd",
  "lkr",
  "ltc",
  "mmk",
  "mxn",
  "myr",
  "ngn",
  "nok",
  "nzd",
  "php",
  "pkr",
  "pln",
  "rub",
  "sar",
  "sek",
  "sgd",
  "thb",
  "try",
  "twd",
  "uah",
  "usd",
  "xag",
  "xau",
  "xdr",
  "xlm",
  "xrp",
  "yfi",
  "zar",
  "bits",
  "link",
  "sats"
];

var currencyNames = {
  "aed": "United Arab Emirates Dirham",
  "ars": "Argenine Peso",
  "aud": "Australian Dollar",
  "bch": "Bitcoin Cash",
  "bdt": "Bangladeshi Taka",
  "bhd": "Bahraini Dinar",
  "bmd": "Bermudan Dollar",
  "bnb": "Binance Coin",
  "brl": "Brazilian Real",
  "btc": "Bitcoin",
  "cad": "Canadian Dollar",
  "chf": "Swiss Franc",
  "clp": "Chilean Peso",
  "cny": "Chinese Yuan",
  "czk": "Czech Koruna",
  "dkk": "Danish Krone",
  "dot": "Polkadot",
  "eos": "EOS",
  "eth": "Ethereum",
  "eur": "Euro",
  "gbp": "British Pound",
  "hkd": "Hong-",
  "huf": "Hong Kong Dollar",
  "idr": "Indonesian Rupiah",
  "ils": "Israeli New Shekel",
  "inr": "Indian Rupee",
  "jpy": "Japanese Yen",
  "krw": "South Korean",
  "kwd": "Kuwaiti Dinar",
  "lkr": "Sri Lankan Rupee",
  "ltc": "Litecoin",
  "mmk": "Myanmar Kyat",
  "mxn": "Mexican Peso",
  "myr": "Malaysian Ringgit",
  "ngn": "Nigerian Naira",
  "nok": "Norwegian Krone",
  "nzd": "New Zealand Dollar",
  "php": "Philippine Peso",
  "pkr": "Pakistani Rupee",
  "pln": "Polish złoty",
  "rub": "Russian Ruble",
  "sar": "Saudi Riyal",
  "sek": "Swedish Krona",
  "sgd": "Singapore Dollar",
  "thb": "Thai Baht",
  "try": "Turkish Lira",
  "twd": "New Taiwan Dollar",
  "uah": "Ukrainian hryvnia",
  "usd": "United States Dollar",
  "vef": "Venezuelan Bolívar",
  "vnd": "Vietnamese dong",
  "xag": "Silver",
  "xau": "Gold",
  "xdr": "Special Drawing Rights",
  "xlm": "Stellar Lumens",
  "xrp": "Ripple",
  "yfi": "Yearn.finance",
  "zar": "South African Rand",
  "bits": "Bit",
  "link": "Chainlink",
  "sats": "Satoshi"
};
