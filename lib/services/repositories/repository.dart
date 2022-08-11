import 'package:carex_flutter/services/models/cost.dart';
import 'package:carex_flutter/services/models/cost_info.dart';
import 'package:carex_flutter/services/models/statistic_data.dart';
import 'package:carex_flutter/services/models/vehicle.dart';
import 'package:carex_flutter/services/store/objectbox_store.dart';

class Repository {
  final ObjectBox database;

  Repository(this.database);

  /// Get all vehicles from database
  List<Vehicle> getAllVehicles() {
    return database.getAllVehicles();
  }

  /// Get all vehicles except "selected" vehicle
  List<Vehicle> getNonSelectedVehicles() {
    return database.getAllNonSelectedVehicles();
  }

  /// Insert [vehicle] into database
  void insertVehicle(Vehicle vehicle) {
    return database.insertVehicle(vehicle);
  }

  /// Remove [vehicle] from database
  void deleteVehicle(Vehicle vehicle) {
    return database.deleteVehicle(vehicle);
  }

  /// Marks vehicle as "selected"
  void selectVehicle(Vehicle vehicle) {
    return database.selectVehicle(vehicle);
  }

  /// Get all costs for currently selected vehicle
  List<Cost> getAllCosts() {
    return database.getAllCosts();
  }

  /// Get last two fuel fill-ups
  List<Cost> getLastTwoFillUps() {
    return database.lastFillups();
  }

  /// Get costs for current month only
  List<Cost> getThisMonthCosts() {
    return database.getCostsForThisMonth();
  }

  /// Get selected vehicle
  Vehicle? getSelectedVehicle() {
    return database.getSelectedVehicle();
  }

  /// Get average fuel consumption between last two fill-ups
  double getFuelConsumption() {
    return database.getAverageFuelConsumption();
  }

  /// Get costs grouped by category for current month only
  List<CostInfo> getCostsStatisticsForThisMonth() {
    return database.getCosts();
  }

  /// Get total costs for past 12 months grouped by month
  List<CostInfo> getCostsByMonth() {
    return database.getYearCostsByMonth();
  }

  /// Get fuel liters statistic for current month
  List<StatisticData> getFuelLitersForThisMonth() {
    return database.getFuelLitersFilledForCurrentMonth();
  }

  /// Get summed costs total price grouped by their category for
  /// previous six months
  List<StatisticData> getSummedCostsForSixMonths() {
    return database.getSummedCostsFor6Months();
  }

  /// Get number of kilometers traveled in previous month
  /// based on the odometer value
  StatisticData getKilometersTravelledForPreviousMonth() {
    return database.getKilometersTravelledPastMonth();
  }
}
