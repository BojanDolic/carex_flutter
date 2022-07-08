import 'package:carex_flutter/services/models/vehicle.dart';
import 'package:equatable/equatable.dart';

abstract class VehicleBlocEvent extends Equatable {
  const VehicleBlocEvent();

  @override
  List<Object?> get props => [];
}

class LoadVehicles extends VehicleBlocEvent {
  final List<Vehicle> vehicles;

  const LoadVehicles({required this.vehicles});

  @override
  List<Object?> get props => [vehicles];
}

class AddVehicle extends VehicleBlocEvent {
  final Vehicle vehicle;

  const AddVehicle({required this.vehicle});

  @override
  List<Object?> get props => [vehicle];
}

class DeleteVehicle extends VehicleBlocEvent {
  final Vehicle vehicle;

  const DeleteVehicle({required this.vehicle});

  @override
  List<Object?> get props => [vehicle];
}

class SelectVehicle extends VehicleBlocEvent {
  final Vehicle vehicle;

  const SelectVehicle({required this.vehicle});

  @override
  List<Object?> get props => [vehicle];
}
