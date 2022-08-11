class Calculator {
  /// Function used to calculate average fuel consumption of the vehicle
  ///
  /// It uses previous and current odometer value and liters filled
  ///
  /// Returns fuel consumption as double
  static double calculateFuelConsumption(int previous, int current, double liters) {
    final difference = current - previous;
    double averageConsumption = 0.0;

    try {
      averageConsumption = (liters / difference) * 100.0;
    } catch (e) {
      averageConsumption = 0.0;
    }
    return averageConsumption;
  }
}
