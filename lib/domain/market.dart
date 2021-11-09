class Market {
  final String id;
  final String symbol;
  final String name;
  final String image;
  final double currentPrice;
  final int marketCap;
  final int marketCapRank;
  final String lastUpdated;

  const Market(
      {required this.id,
      required this.symbol,
      required this.name,
      required this.image,
      required this.currentPrice,
      required this.marketCap,
      required this.marketCapRank,
      required this.lastUpdated});

  factory Market.fromJson(Map<String, dynamic> json) {
    return Market(
        id: json['id'],
        symbol: json['symbol'],
        name: json['name'],
        image: json['image'],
        currentPrice: double.parse(json['current_price'].toString()),
        marketCap: json['market_cap'],
        marketCapRank: json['market_cap_rank'],
        lastUpdated: json['last_updated']);
  }
}
