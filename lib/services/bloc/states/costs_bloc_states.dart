import 'package:carex_flutter/services/models/cost.dart';
import 'package:carex_flutter/services/models/vehicle.dart';
import 'package:equatable/equatable.dart';

abstract class CostsBlocStates extends Equatable {
  const CostsBlocStates();

  @override
  List<Object?> get props => [];
}

class CostsInitialState extends CostsBlocStates {
  const CostsInitialState();

  @override
  List<Object?> get props => [];
}

class CostsErrorState extends CostsBlocStates {
  final String errorMessage;

  const CostsErrorState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

class NoCostsState extends CostsBlocStates {
  const NoCostsState();

  @override
  List<Object?> get props => [];
}

class CostsNoSelectedVehicleState extends CostsBlocStates {
  final String message;

  const CostsNoSelectedVehicleState({this.message = "No vehicle selected"});

  @override
  List<Object?> get props => [message];
}

class LoadedCostsState extends CostsBlocStates {
  final Vehicle? selectedVehicle;
  final List<Cost> costs;
  final Map<String, double> costsInfo;

  const LoadedCostsState({
    required this.selectedVehicle,
    required this.costs,
    required this.costsInfo,
  });

  @override
  List<Object?> get props => [selectedVehicle, costs, costsInfo];
}
