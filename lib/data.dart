class Coin {
  final String id;
  final String symbol;
  final String name;
  final DateTime? lastUpdated;
  final Map<String, String> description;
  final List<String> categories;
  final Links links;
  final MarketData marketData;

  Coin(
      {required this.id,
      required this.symbol,
      required this.name,
      required this.lastUpdated,
      required this.description,
      required this.categories,
      required this.links,
      required this.marketData});

  factory Coin.fromJson(Map<String, dynamic> json) {
    return Coin(
        id: json['id'],
        symbol: json['symbol'],
        name: json['name'],
        lastUpdated: DateTime.tryParse(json['last_updated']),
        description: Map<String, String>.from(json['description']),
        categories: List<String>.from(json['categories']),
        links: Links.from(json['links']),
        marketData: MarketData.fromJson(
            Map<String, dynamic>.from(json['market_data'])));
  }
}

class Links {
  final List<String> homepage;
  final List<String> blockchainSites;
  final List<String> forums;
  final List<String> chatUrls;
  final List<String> announcements;
  final String? twitterName;
  final String? facebookUsername;
  final String? bitcoinTalkThreadId;
  final String? telegramChannelId;
  final String? subredditUrl;

  Links(
      {required this.homepage,
      required this.blockchainSites,
      required this.forums,
      required this.chatUrls,
      required this.announcements,
      required this.twitterName,
      required this.facebookUsername,
      required this.bitcoinTalkThreadId,
      required this.telegramChannelId,
      required this.subredditUrl});

  factory Links.from(Map<String, dynamic> json) {
    return Links(
      homepage: List<String>.from(json['homepage']),
      blockchainSites: List<String>.from(json['blockchain_site']),
      forums: List<String>.from(json['official_forum_url']),
      chatUrls: List<String>.from(json['chat_url']),
      announcements: List<String>.from(json['announcement_url']),
      twitterName: json['twitter_screen_name'],
      facebookUsername: json['facebook_username'],
      bitcoinTalkThreadId: json['bitcointalk_thread_identifier'],
      telegramChannelId: json['telegram_channel_identifier'],
      subredditUrl: json['subreddit_url'],
    );
  }
}

class ReturnOfInvestment {
  final double times;
  final String currency;
  final double percentage;

  ReturnOfInvestment(
      {required this.times, required this.currency, required this.percentage});

  factory ReturnOfInvestment.from(Map<String, dynamic> json) {
    return ReturnOfInvestment(
        times: json["times"] ?? 0,
        currency: json["currency"],
        percentage: json["percentage"]);
  }
}

class MarketData {
  final Map<String, num> currentPrice;
  final ReturnOfInvestment? returnOfInvestment;
  final Map<String, num> allTimeHigh;
  final Map<String, num> allTimeHighChange;
  final Map<String, String> allTimeHighDate;
  final Map<String, num> allTimeLow;
  final Map<String, num> allTimeLowChange;
  final Map<String, String> allTimeLowDate;
  final Map<String, num> marketCap;
  final int marketCapRank;
  final Map<String, num> totalVolume;
  final Map<String, num> highest24h;
  final Map<String, num> lowest24h;
  final num priceChange24h;
  final num priceChangePercentage24h;
  final num priceChangePercentage7d;
  final num priceChangePercentage14d;
  final num priceChangePercentage30d;
  final num priceChangePercentage60d;
  final num priceChangePercentage200d;
  final num priceChangePercentage1y;
  final num marketCapChange24h;
  final num marketCapChangePercentage24h;
  final Map<String, num> priceChange24hInCurrency;
  final Map<String, num> priceChangePercentage1hInCurrency;
  final Map<String, num> priceChangePercentage24hInCurrency;
  final Map<String, num> priceChangePercentage7dInCurrency;
  final Map<String, num> priceChangePercentage14dInCurrency;
  final Map<String, num> priceChangePercentage30dInCurrency;
  final Map<String, num> priceChangePercentage60dInCurrency;
  final Map<String, num> priceChangePercentage200dInCurrency;
  final Map<String, num> priceChangePercentage1yInCurrency;
  final Map<String, num> marketCapChangePercentage24InCurrency;
  final Map<String, int> fullyDilutedValuation;
  final Map<String, int> totalValueLocked;
  final String? marketCapToTradeValueLockedRatio;
  final String? fullyDilutedValuationToTradeVolumeRatio;
  final num totalSupply;
  final num maxSupply;
  final num circulatingSupply;
  final String lastUpdated;

  MarketData(
      {required this.currentPrice,
      required this.returnOfInvestment,
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
      required this.priceChange24h,
      required this.priceChangePercentage24h,
      required this.priceChangePercentage7d,
      required this.priceChangePercentage14d,
      required this.priceChangePercentage30d,
      required this.priceChangePercentage60d,
      required this.priceChangePercentage200d,
      required this.priceChangePercentage1y,
      required this.marketCapChange24h,
      required this.marketCapChangePercentage24h,
      required this.priceChange24hInCurrency,
      required this.priceChangePercentage1hInCurrency,
      required this.priceChangePercentage24hInCurrency,
      required this.priceChangePercentage7dInCurrency,
      required this.priceChangePercentage14dInCurrency,
      required this.priceChangePercentage30dInCurrency,
      required this.priceChangePercentage60dInCurrency,
      required this.priceChangePercentage200dInCurrency,
      required this.priceChangePercentage1yInCurrency,
      required this.marketCapChangePercentage24InCurrency,
      required this.fullyDilutedValuation,
      required this.totalValueLocked,
      required this.marketCapToTradeValueLockedRatio,
      required this.fullyDilutedValuationToTradeVolumeRatio,
      required this.totalSupply,
      required this.maxSupply,
      required this.circulatingSupply,
      required this.lastUpdated});

  factory MarketData.fromJson(Map<String, dynamic> json) {
    return MarketData(
        currentPrice: Map<String, num>.from(json['current_price']),
        returnOfInvestment: json['roi'] != null
            ? ReturnOfInvestment.from(Map<String, dynamic>.from(json['roi']))
            : null,
        allTimeHigh: Map<String, num>.from(json['ath']),
        allTimeHighChange: Map<String, num>.from(json['ath_change_percentage']),
        allTimeHighDate: Map<String, String>.from(json['ath_date']),
        allTimeLow: Map<String, num>.from(json['atl']),
        allTimeLowChange: Map<String, num>.from(json['ath_change_percentage']),
        allTimeLowDate: Map<String, String>.from(json['atl_date']),
        marketCap: Map<String, num>.from(json['market_cap']),
        marketCapRank: json['market_cap_rank'],
        totalVolume: Map<String, num>.from(json['total_volume']),
        highest24h: Map<String, num>.from(json['high_24h']),
        lowest24h: Map<String, num>.from(json['low_24h']),
        priceChange24h: json['price_change_24h'],
        priceChangePercentage24h: json['price_change_percentage_24h'],
        priceChangePercentage7d: json['price_change_percentage_7d'],
        priceChangePercentage14d: json['price_change_percentage_14d'],
        priceChangePercentage30d: json['price_change_percentage_30d'],
        priceChangePercentage60d: json['price_change_percentage_60d'],
        priceChangePercentage200d: json['price_change_percentage_200d'],
        priceChangePercentage1y: json['price_change_percentage_1y'],
        marketCapChange24h: json['market_cap_change_24h'].toDouble(),
        marketCapChangePercentage24h: json['market_cap_change_percentage_24h'],
        priceChange24hInCurrency:
            Map<String, num>.from(json['price_change_24h_in_currency']),
        priceChangePercentage1hInCurrency: Map<String, num>.from(
            json['price_change_percentage_1h_in_currency']),
        priceChangePercentage24hInCurrency: Map<String, num>.from(
            json['price_change_percentage_24h_in_currency']),
        priceChangePercentage7dInCurrency: Map<String, num>.from(
            json['price_change_percentage_7d_in_currency']),
        priceChangePercentage14dInCurrency: Map<String, num>.from(
            json['price_change_percentage_14d_in_currency']),
        priceChangePercentage30dInCurrency: Map<String, num>.from(
            json['price_change_percentage_30d_in_currency']),
        priceChangePercentage60dInCurrency: Map<String, num>.from(
            json['price_change_percentage_60d_in_currency']),
        priceChangePercentage200dInCurrency: Map<String, num>.from(
            json['price_change_percentage_200d_in_currency']),
        priceChangePercentage1yInCurrency: Map<String, num>.from(
            json['price_change_percentage_1y_in_currency']),
        marketCapChangePercentage24InCurrency: Map<String, num>.from(
            json['market_cap_change_percentage_24h_in_currency']),
        fullyDilutedValuation:
            Map<String, int>.from(json['fully_diluted_valuation']),
        totalValueLocked: json['total_value_locked'] != null
            ? Map<String, int>.from(json['total_value_locked'])
            : {},
        marketCapToTradeValueLockedRatio: json['mcap_to_tvl_ratio'],
        fullyDilutedValuationToTradeVolumeRatio: json['fdv_to_tvl_ratio'],
        totalSupply: json['total_supply'],
        maxSupply: json['max_supply'] ?? 0,
        circulatingSupply: json['circulating_supply'],
        lastUpdated: json['last_updated']);
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

  static double findLowestValue(Map<double, double> data) {
    return data.values.reduce((curr, next) => curr < next ? curr : next);
  }

  static double findLowestKey(Map<double, double> data) {
    return data.keys.reduce((curr, next) => curr < next ? curr : next);
  }

  static double findHighestValue(Map<double, double> data) {
    return data.values.reduce((curr, next) => curr > next ? curr : next);
  }

  static double findHighestKey(Map<double, double> data) {
    return data.keys.reduce((curr, next) => curr > next ? curr : next);
  }

  static Map<double, double> convert(List<dynamic> items) {
    return Map.fromIterable(items, key: (element) {
      String data = element.toString();
      return double.parse(data.substring(1, data.indexOf(',')));
    }, value: (element) {
      String data = element.toString();
      return double.parse(
          data.substring(data.indexOf(',') + 2, data.length - 1));
    });
  }

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
  "hkd": "Hong-Kong Dollar",
  "huf": "Hungarian Forint",
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
