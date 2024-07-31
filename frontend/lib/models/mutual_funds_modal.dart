class MutualFunds {
  final String name;
  final String age;
  final String category;
  final String size;

  MutualFunds({
    required this.name,
    required this.age,
    required this.category,
    required this.size,
  });
}

class InvestedMutualFundModel {
  // final DateTime investmentDate;
  // final String purchasedPrice;
  final double investmentAmount;
  final dynamic currentValue;
  final String unitsPurchased;
  final String fundName;

  InvestedMutualFundModel({
    // required this.investmentDate,
    // required this.purchasedPrice,
    required this.investmentAmount,
    required this.unitsPurchased,
    required this.currentValue,
    required this.fundName,
  });
}