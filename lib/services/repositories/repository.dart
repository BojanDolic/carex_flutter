import 'package:carex_flutter/objectbox.g.dart';
import 'package:carex_flutter/services/models/vehicle.dart';
import 'package:carex_flutter/services/store/objectbox_store.dart';

class Repository {
  late Box<Vehicle> _vehiclesBox;

  final ObjectBox objectBox;

  Repository(this.objectBox) {
    _vehiclesBox = objectBox.store.box<Vehicle>();
  }

  List<Vehicle> getAllVehicles() {
    return _vehiclesBox.getAll();
  }

  Stream<Vehicle> getAllVehiclesStream() {
    final _queryBuilder = _vehiclesBox.query();
    final _query = _queryBuilder.build();
    return _query.stream();
  }

  void insertVehicle(Vehicle vehicle) {
    _vehiclesBox.put(vehicle);
  }

  void deleteVehicle(Vehicle vehicle) {
    _vehiclesBox.remove(vehicle.id);
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
    _vehiclesBox.putMany(modifiedVehicles.toList());
  }

  Vehicle? getSelectedVehicle() {
    final _queryBuilder = _vehiclesBox.query(Vehicle_.selected.equals(true));

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
}
