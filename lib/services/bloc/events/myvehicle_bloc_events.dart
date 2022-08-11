import 'package:carex_flutter/services/models/cost.dart';
import 'package:carex_flutter/services/models/vehicle.dart';
import 'package:equatable/equatable.dart';

abstract class MyVehicleBlocEvent extends Equatable {
  const MyVehicleBlocEvent();

  @override
  List<Object?> get props => [];
}

class LoadVehicles extends MyVehicleBlocEvent {
  final Vehicle? selectedVehicle;
  final List<Vehicle> vehicles;

  const LoadVehicles({
    required this.selectedVehicle,
    required this.vehicles,
  });

  @override
  List<Object?> get props => [selectedVehicle, vehicles];
}

class SelectVehicle extends MyVehicleBlocEvent {
  final Vehicle vehicle;

  const SelectVehicle({required this.vehicle});

  @override
  List<Object?> get props => [vehicle];
}

class DeleteCost extends MyVehicleBlocEvent {
  final Cost cost;
  final Vehicle selectedVehicle;

  const DeleteCost({
    required this.cost,
    required this.selectedVehicle,
  });

  @override
  List<Object?> get props => [cost, selectedVehicle];
}
