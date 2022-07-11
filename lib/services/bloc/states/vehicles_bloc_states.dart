import 'package:carex_flutter/services/models/vehicle.dart';
import 'package:equatable/equatable.dart';

abstract class VehiclesState extends Equatable {
  const VehiclesState();

  @override
  List<Object?> get props => [];
}

class InitialState extends VehiclesState {
  const InitialState();

  @override
  List<Object?> get props => [];
}

class LoadedVehicles extends VehiclesState {
  final List<Vehicle> vehicles;

  const LoadedVehicles({this.vehicles = const <Vehicle>[]});

  @override
  List<Object?> get props => [vehicles];
}
