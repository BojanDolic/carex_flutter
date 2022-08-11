import 'package:carex_flutter/services/models/statistic_data.dart';
import 'package:equatable/equatable.dart';

abstract class StatisticsBlocStates extends Equatable {
  const StatisticsBlocStates();

  @override
  List<Object?> get props => [];
}

class LoadingStatisticsState extends StatisticsBlocStates {
  const LoadingStatisticsState();

  @override
  List<Object?> get props => [];
}

class StatisticsLoaded extends StatisticsBlocStates {
  final List<StatisticData> litersFilledStatistics;
  final List<StatisticData> costsSummedSixMonths;
  final StatisticData kilometersTravelledPreviousMonth;

  const StatisticsLoaded({
    required this.litersFilledStatistics,
    required this.costsSummedSixMonths,
    required this.kilometersTravelledPreviousMonth,
  });

  @override
  List<Object?> get props => [litersFilledStatistics, costsSummedSixMonths, kilometersTravelledPreviousMonth];
}
