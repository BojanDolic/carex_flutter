import 'package:flutter/services.dart';

final oneDecimalTextFormatter = FilteringTextInputFormatter.allow(RegExp(r'([0-9]?(\.{1}))?([0-9]{1}){1}'));

enum VehiclesMenuOptions {
  selectVehicle,
  deleteVehicle,
}

enum FuelType {
  diesel,
  gasoline,
}

enum CostType {
  fuel,
  service,
  maintenance,
  parking,
  registration,
}
