import 'package:carex_flutter/services/models/vehicle.dart';
import 'package:carex_flutter/services/store/objectbox_store.dart';
import 'package:objectbox/objectbox.dart';

class Repository {
  late Box<Vehicle> _vehiclesBox;

  final ObjectBox objectBox;

  Repository(this.objectBox) {
    _vehiclesBox = objectBox.store.box<Vehicle>();
  }
}
