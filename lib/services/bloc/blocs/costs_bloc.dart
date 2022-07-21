import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:carex_flutter/services/bloc/events/costs_bloc_events.dart';
import 'package:carex_flutter/services/bloc/states/costs_bloc_states.dart' as states;
import 'package:carex_flutter/services/repositories/repository.dart';

class CostsBloc extends Bloc<CostsBlocEvent, states.CostsBlocStates> {
  final Repository _repository;

  CostsBloc(this._repository) : super(const states.CostsInitialState()) {
    on<LoadCosts>(_loadCosts);
    on<AddCost>(_addCost);
    on<NoCostEvent>(_noCostsEvent);
    on<DeleteCost>(_deleteCost);
  }

  FutureOr<void> _loadCosts(LoadCosts event, Emitter<states.CostsBlocStates> emit) {
    final selectedVehicle = _repository.getSelectedVehicle();

    if (selectedVehicle == null) {
      emit(const states.CostsNoSelectedVehicleState());
      return Future.value();
    } else {
      final costs = _repository.getAllCosts(selectedVehicle);

      if (costs.isEmpty) {
        add(const NoCostEvent());
        return Future.value();
      }
      emit(
        states.LoadedCostsState(
          selectedVehicle: selectedVehicle,
          costs: costs,
          costsInfo: _repository.getCosts(selectedVehicle),
        ),
      );
    }
  }

  FutureOr<void> _addCost(AddCost event, Emitter<states.CostsBlocStates> emit) {
    final cost = event.cost;
    final _selectedVehicle = _repository.getSelectedVehicle();

    if (_selectedVehicle == null) {
      emit(const states.CostsNoSelectedVehicleState());
    } else {
      _selectedVehicle.costs.add(cost);
      _repository.insertVehicle(_selectedVehicle);
      final costs = _repository.getAllCosts(_selectedVehicle);

      if (costs.isEmpty) {
        add(const NoCostEvent());
      } else {
        emit(
          states.LoadedCostsState(
            selectedVehicle: _selectedVehicle,
            costs: _repository.getAllCosts(_selectedVehicle),
            costsInfo: _repository.getCosts(_selectedVehicle),
          ),
        );
      }
    }
  }

  FutureOr<void> _noCostsEvent(NoCostEvent event, Emitter<states.CostsBlocStates> emit) {
    emit(const states.NoCostsState());
  }

  FutureOr<void> _deleteCost(DeleteCost event, Emitter<states.CostsBlocStates> emit) {
    final costToDelete = event.cost;
    final selectedVehicle = _repository.getSelectedVehicle();

    if (selectedVehicle == null) {
      emit(const states.CostsNoSelectedVehicleState());
      return Future.value();
    }

    final indexOfItem = selectedVehicle.costs.indexWhere((element) => element.id == costToDelete.id);
    selectedVehicle.costs.removeAt(indexOfItem);

    _repository.insertVehicle(selectedVehicle); // Update database

    add(const LoadCosts());
  }
}
