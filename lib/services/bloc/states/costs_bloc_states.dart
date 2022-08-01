import 'package:carex_flutter/services/models/cost.dart';
import 'package:carex_flutter/services/models/cost_info.dart';
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
  final Vehicle? selectedVehicle;
  const NoCostsState({required this.selectedVehicle});

  @override
  List<Object?> get props => [selectedVehicle];
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
  final List<CostInfo> costsInfo;
  final List<CostInfo> yearCosts;

  const LoadedCostsState({
    required this.selectedVehicle,
    required this.costs,
    required this.costsInfo,
    required this.yearCosts,
  });

  @override
  List<Object?> get props => [selectedVehicle, costs, costsInfo, yearCosts];
}
