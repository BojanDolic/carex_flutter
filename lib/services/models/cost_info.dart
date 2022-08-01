class CostInfo {
  final String costName;
  final double costPrice;

  CostInfo(this.costName, this.costPrice);

  @override
  String toString() {
    return 'CostInfo{costName: $costName, costPrice: $costPrice}';
  }
}
