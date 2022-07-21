import 'package:carex_flutter/objectbox.g.dart';
import 'package:carex_flutter/services/models/cost.dart';
import 'package:carex_flutter/services/models/vehicle.dart';
import 'package:carex_flutter/services/store/objectbox_store.dart';

class Repository {
  final ObjectBox objectBox;

  late Box<Vehicle> _vehiclesStore;
  late Box<Cost> _costsStore;

  Repository(this.objectBox) {
    _vehiclesStore = objectBox.store.box<Vehicle>();
    _costsStore = objectBox.store.box<Cost>();
  }

  List<Vehicle> getAllVehicles() {
    return _vehiclesStore.getAll();
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

  Vehicle? getSelectedVehicle() {
    final _queryBuilder = _vehiclesStore.query(Vehicle_.selected.equals(true));

    final query = _queryBuilder.build();
    try {
      final vehicle = query.find().first;
      query.close();
      return vehicle;
    } catch (badState) {
      query.close();
      return null;
    }
  }

  List<Cost> getAllCosts(Vehicle vehicle) {
    final queryBuilder = _costsStore.query(Cost_.vehicle.equals(vehicle.id))
      ..order(
        Cost_.date,
        flags: Order.descending,
      );

    final query = queryBuilder.build();

    final costs = query.find();
    query.close();
    return costs;
  }

  Map<String, double> getCosts(Vehicle vehicle) {
    final queryBuilder = _costsStore.query(Cost_.vehicle.equals(vehicle.id))
      ..order(
        Cost_.date,
        flags: Order.descending,
      );

    final query = queryBuilder.build();

    final costs = query.find();

    final map = <String, double>{};
    var totalCost = 0.0;

    if (costs.isNotEmpty) {
      totalCost = costs.fold(totalCost, (previousValue, element) => previousValue + element.totalPrice);
    }

    map.putIfAbsent("Total", () => totalCost);
    map.putIfAbsent(
      "Fuel",
      () => costs.fold(
        0,
        (previousValue, element) {
          if (element.category == "Fuel") {
            return previousValue + element.totalPrice;
          } else {
            return previousValue;
          }
        },
      ),
    );
    map.putIfAbsent(
      "Service",
      () => costs.fold(
        0,
        (previousValue, element) {
          if (element.category == "Service") {
            return previousValue + element.totalPrice;
          } else {
            return previousValue;
          }
        },
      ),
    );

    return map;
  }
}
