import 'package:finance_assistent/src/features/home/presentation/cubit/home_overview_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repo/home_repository.dart';

class HomeOverviewCubit extends Cubit<HomeOverviewState> {
  final HomeRepository repository;
  HomeOverviewCubit(this.repository) : super(const HomeOverviewInitial());

  Future<void> fetch() async {
    emit(const HomeOverviewLoading());
    try {
      final data = await repository.getOverview();
      emit(HomeOverviewLoaded(data));
    } catch (e) {
      emit(HomeOverviewError(e.toString()));
    }
  }
}
