import 'dart:async';

import 'package:carex_flutter/services/bloc/events/vehicles_bloc_events.dart';
import 'package:carex_flutter/services/bloc/states/vehicles_bloc_states.dart';
import 'package:carex_flutter/services/repositories/repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VehiclesBloc extends Bloc<VehicleBlocEvent, VehiclesState> {
  final Repository _repository;

  VehiclesBloc(this._repository) : super(const InitialState()) {
    on<LoadVehicles>(_loadVehicles);
  }

  FutureOr<void> _loadVehicles(LoadVehicles event, Emitter<VehiclesState> emit) {}
}
