class CryptoData {
  final String id;
  final String symbol;
  final String name;
  final Map<String, double> currentPrices;

  CryptoData(
      {required this.id,
      required this.symbol,
      required this.name,
      required this.currentPrices});

  factory CryptoData.fromJson(Map<String, dynamic> json) {
    return CryptoData(
        id: json['id'],
        symbol: json['symbol'],
        name: json['name'],
        currentPrices:
            Map<String, double>.from(json['market_data']['current_price']));
  }
}
