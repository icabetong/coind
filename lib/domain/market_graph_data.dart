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
