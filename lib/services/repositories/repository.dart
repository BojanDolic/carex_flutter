import 'package:carex_flutter/objectbox.g.dart';
import 'package:carex_flutter/services/models/cost.dart';
import 'package:carex_flutter/services/models/cost_info.dart';
import 'package:carex_flutter/services/models/vehicle.dart';
import 'package:carex_flutter/services/store/objectbox_store.dart';

class Repository {
  final ObjectBox database;

  late Box<Vehicle> _vehiclesStore;
  late Box<Cost> _costsStore;

  Repository(this.database) {
    _vehiclesStore = database.store.box<Vehicle>();
    _costsStore = database.store.box<Cost>();
  }

  List<Vehicle> getAllVehicles() {
    return _vehiclesStore.getAll();
  }

  List<Vehicle> getNonSelectedVehicles() {
    return database.getAllNonSelectedVehicles();
  }

  Stream<Vehicle> getAllVehiclesStream() {
    final _queryBuilder = _vehiclesStore.query();
    final _query = _queryBuilder.build();
    return _query.stream();
  }

  void insertVehicle(Vehicle vehicle) {
    _vehiclesStore.put(vehicle);
  }

  void deleteVehicle(Vehicle vehicle) {
    _vehiclesStore.remove(vehicle.id);
  }

  /// Function iterates through all vehicles in database and deselects all of them except
  /// the vehicle which needs to be marked as selected
  void selectVehicle(Vehicle vehicle) {
    final vehicles = getAllVehicles();
    final modifiedVehicles = vehicles.map((_vehicle) {
      if (_vehicle.id == vehicle.id) {
        _vehicle.selected = true;
      } else {
        _vehicle.selected = false;
      }
      return _vehicle;
    });
    _vehiclesStore.putMany(modifiedVehicles.toList());
  }

  List<Cost> getAllCosts() {
    final vehicle = getSelectedVehicle();
    var costs = <Cost>[];

    if (vehicle == null) {
      return costs;
    }

    final queryBuilder = _costsStore.query(Cost_.vehicle.equals(vehicle.id))
      ..order(
        Cost_.date,
        flags: Order.descending,
      );

    final query = queryBuilder.build();

    costs = query.find();
    query.close();
    return costs;
  }

  List<Cost> getLastTwoFillUps() {
    return database.lastFillups();
  }

  List<Cost> getThisMonthCosts() {
    return database.getCostsForThisMonth();
  }

  Vehicle? getSelectedVehicle() {
    return database.getSelectedVehicle();
  }

  double getFuelConsumption() {
    return database.getAverageFuelConsumption();
  }

  List<CostInfo> getCostsStatisticsForThisMonth() {
    return database.getCosts();
  }

  List<CostInfo> getCostsByMonth() {
    return database.getYearCostsByMonth();
  }
}
