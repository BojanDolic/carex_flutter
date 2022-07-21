import 'package:carex_flutter/services/models/cost.dart';
import 'package:equatable/equatable.dart';

abstract class CostsBlocEvent extends Equatable {
  const CostsBlocEvent();

  @override
  List<Object?> get props => [];
}

/// Load costs
/// Passing current vehicle because we will extract
/// costs for selected vehicle
class LoadCosts extends CostsBlocEvent {
  const LoadCosts();

  @override
  List<Object?> get props => [];
}

class AddCost extends CostsBlocEvent {
  final Cost cost;

  const AddCost({required this.cost});

  @override
  List<Object?> get props => [cost];
}

class DeleteCost extends CostsBlocEvent {
  final Cost cost;

  const DeleteCost({required this.cost});

  @override
  List<Object?> get props => [cost];
}

class NoCostEvent extends CostsBlocEvent {
  const NoCostEvent();

  @override
  List<Object?> get props => [];
}
