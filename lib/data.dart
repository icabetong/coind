class CryptoData {
    final String id;
    final String symbol;
    final String name;

    CryptoData({
        required: this.id,
        required: this.symbol,
        required: this.name,
    })

    factory CryptoData.fromJson(Map<String, dynamic> json) {
        return CryptoData(
            id: json['id'], 
            symbol: json['symbol'],
            name: json['name']);
    }
}