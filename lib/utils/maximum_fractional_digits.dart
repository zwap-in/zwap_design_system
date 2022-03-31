extension DoubleExtension on double {
  double getMximumFractionsDigits(int fractionalDigits) => double.parse(this.toStringAsFixed(2));
}
