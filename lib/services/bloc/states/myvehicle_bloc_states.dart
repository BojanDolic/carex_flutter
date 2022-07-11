import 'package:carex_flutter/services/models/vehicle.dart';
import 'package:equatable/equatable.dart';

abstract class MyVehicleBlocState extends Equatable {
  const MyVehicleBlocState();

  @override
  List<Object?> get props => [];
}

class InitialState extends MyVehicleBlocState {
  const InitialState();

  @override
  List<Object?> get props => [];
}

class LoadedVehicleState extends MyVehicleBlocState {
  final Vehicle? selectedVehicle;
  final List<Vehicle> allVehicles;

  const LoadedVehicleState({required this.selectedVehicle, required this.allVehicles});

  @override
  List<Object?> get props => [selectedVehicle, allVehicles];
}
