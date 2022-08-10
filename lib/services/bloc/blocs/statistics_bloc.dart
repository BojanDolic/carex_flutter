import 'dart:async';

import 'package:carex_flutter/services/bloc/events/statistics_bloc_events.dart';
import 'package:carex_flutter/services/bloc/states/statistics_bloc_states.dart';
import 'package:carex_flutter/services/repositories/repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatisticsBloc extends Bloc<StatisticsBlocEvent, StatisticsBlocStates> {
  final Repository _repository;

  StatisticsBloc(this._repository) : super(const LoadingStatisticsState()) {
    on<LoadStatistics>(_loadStatistics);
  }

  FutureOr<void> _loadStatistics(LoadStatistics event, Emitter<StatisticsBlocStates> emit) {
    emit(
      StatisticsLoaded(
        litersFilledStatistics: _repository.getFuelLitersForThisMonth(),
        costsSummedSixMonths: _repository.getSummedCostsForSixMonths(),
        kilometersTravelledPreviousMonth: _repository.getKilometersTravelledForPreviousMonth(),
      ),
    );
  }
}
