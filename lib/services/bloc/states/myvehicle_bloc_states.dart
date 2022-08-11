import 'package:carex_flutter/services/models/cost.dart';
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
  final List<Cost> thisMonthCosts;
  final List<Cost> lastFillups;
  final double averageConsumption;

  const LoadedVehicleState({
    required this.selectedVehicle,
    required this.allVehicles,
    required this.thisMonthCosts,
    required this.lastFillups,
    required this.averageConsumption,
  });

  @override
  List<Object?> get props => [selectedVehicle, allVehicles, thisMonthCosts, lastFillups, averageConsumption];
}
