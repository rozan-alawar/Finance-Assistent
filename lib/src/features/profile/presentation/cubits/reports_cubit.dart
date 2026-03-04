import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/domain/report_data_model.dart';
import '../../data/data_source/reports_remote_data_source.dart'; 
abstract class ReportsState {}

class ReportsLoading extends ReportsState {} 

class ReportsLoaded extends ReportsState { 
  final ReportDataModel? reportData;
  ReportsLoaded(this.reportData);
}

class ReportsError extends ReportsState { 
  final String message;
  ReportsError(this.message);
}

class ReportsCubit extends Cubit<ReportsState> {
  final ReportsRemoteDataSource dataSource;

  ReportsCubit(this.dataSource) : super(ReportsLoading());

  Future<void> loadReports({String? filterTime}) async {
    emit(ReportsLoading()); 
    try {
      final data = await dataSource.fetchReports(filterTime: filterTime);
      emit(ReportsLoaded(data)); 
    } catch (e) {
      emit(ReportsError(e.toString())); 
    }
  }
}