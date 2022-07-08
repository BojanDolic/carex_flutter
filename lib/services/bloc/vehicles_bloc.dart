import 'dart:async';

import 'package:carex_flutter/services/bloc/events/vehicles_bloc_events.dart';
import 'package:carex_flutter/services/bloc/states/vehicles_bloc_states.dart';
import 'package:carex_flutter/services/repositories/repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VehiclesBloc extends Bloc<VehicleBlocEvent, VehiclesState> {
  final Repository _repository;

  VehiclesBloc(this._repository) : super(const InitialState()) {
    on<LoadVehicles>(_loadVehicles);
    on<AddVehicle>(_addVehicle);
    on<DeleteVehicle>(_deleteVehicle);
    on<SelectVehicle>(_selectVehicle);
  }

  FutureOr<void> _loadVehicles(LoadVehicles event, Emitter<VehiclesState> emit) {
    emit(
      LoadedVehicles(
        vehicles: _repository.getAllVehicles(),
      ),
    );
  }

  FutureOr<void> _addVehicle(AddVehicle event, Emitter<VehiclesState> emit) {
    _repository.insertVehicle(event.vehicle);

    emit(
      LoadedVehicles(
        vehicles: _repository.getAllVehicles(),
      ),
    );
  }

  FutureOr<void> _deleteVehicle(DeleteVehicle event, Emitter<VehiclesState> emit) {
    _repository.deleteVehicle(event.vehicle);

    emit(
      LoadedVehicles(
        vehicles: _repository.getAllVehicles(),
      ),
    );
  }

  FutureOr<void> _selectVehicle(SelectVehicle event, Emitter<VehiclesState> emit) {
    _repository.selectVehicle(event.vehicle);

    emit(
      LoadedVehicles(
        vehicles: _repository.getAllVehicles(),
      ),
    );
  }
}
