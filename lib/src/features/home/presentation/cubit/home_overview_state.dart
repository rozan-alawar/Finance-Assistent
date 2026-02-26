import 'package:equatable/equatable.dart';
import 'package:finance_assistent/src/features/home/domain/home_overview.dart';

abstract class HomeOverviewState extends Equatable {
  const HomeOverviewState();
  @override
  List<Object?> get props => [];
}

class HomeOverviewInitial extends HomeOverviewState {
  const HomeOverviewInitial();
}

class HomeOverviewLoading extends HomeOverviewState {
  const HomeOverviewLoading();
}

class HomeOverviewLoaded extends HomeOverviewState {
  final HomeOverview overview;
  const HomeOverviewLoaded(this.overview);
  @override
  List<Object?> get props => [overview];
}

class HomeOverviewError extends HomeOverviewState {
  final String message;
  const HomeOverviewError(this.message);
  @override
  List<Object?> get props => [message];
}
