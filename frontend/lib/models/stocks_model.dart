class StocksModel {
  final int id;
  final String symbolName;
  final String purchasedPrice;
  final int quantity;
  final String stockName;
  final double? currentPrice; // Add this field

  StocksModel({
    required this.id,
    required this.symbolName,
    required this.purchasedPrice,
    required this.quantity,
    required this.stockName,
    this.currentPrice, // Add this to constructor
  });
}
