import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:carex_flutter/services/bloc/events/myvehicle_bloc_events.dart';
import 'package:carex_flutter/services/bloc/states/myvehicle_bloc_states.dart';
import 'package:carex_flutter/services/repositories/repository.dart';

class MyVehicleBloc extends Bloc<MyVehicleBlocEvent, MyVehicleBlocState> {
  final Repository _repository;

  MyVehicleBloc(this._repository) : super(const InitialState()) {
    on<LoadVehicles>(_loadVehicles);
    on<SelectVehicle>(_selectVehicle);
    on<DeleteCost>(_deleteCost);
  }

  FutureOr<void> _loadVehicles(LoadVehicles event, Emitter<MyVehicleBlocState> emit) {
    emit(
      LoadedVehicleState(
        selectedVehicle: _repository.getSelectedVehicle(),
        allVehicles: _repository.getAllVehicles(),
        thisMonthCosts: _repository.getThisMonthCosts(),
        lastFillups: _repository.getLastTwoFillUps(),
        averageConsumption: _repository.getFuelConsumption(),
      ),
    );
  }

  FutureOr<void> _selectVehicle(SelectVehicle event, Emitter<MyVehicleBlocState> emit) {
    _repository.selectVehicle(event.vehicle);

    emit(
      LoadedVehicleState(
        selectedVehicle: _repository.getSelectedVehicle(),
        allVehicles: _repository.getAllVehicles(),
        thisMonthCosts: _repository.getThisMonthCosts(),
        lastFillups: _repository.getLastTwoFillUps(),
        averageConsumption: _repository.getFuelConsumption(),
      ),
    );
  }

  FutureOr<void> _deleteCost(DeleteCost event, Emitter<MyVehicleBlocState> emit) {
    final vehicle = event.selectedVehicle;

    final indexOfItem = vehicle.costs.indexWhere((element) => element.id == event.cost.id);
    vehicle.costs.removeAt(indexOfItem);

    _repository.insertVehicle(vehicle);

    add(
      LoadVehicles(
        selectedVehicle: vehicle,
        vehicles: _repository.getAllVehicles(),
      ),
    );
  }
}
