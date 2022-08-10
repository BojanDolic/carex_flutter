import 'package:equatable/equatable.dart';

abstract class StatisticsBlocEvent extends Equatable {
  const StatisticsBlocEvent();

  @override
  List<Object?> get props => [];
}

class LoadStatistics extends StatisticsBlocEvent {
  const LoadStatistics();

  @override
  List<Object?> get props => [];
}
