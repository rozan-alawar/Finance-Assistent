import 'package:finance_assistent/src/features/income/data/model/income_overview_model.dart';

abstract class IncomeState {}

class IncomeInitial extends IncomeState {}
class IncomeLoading extends IncomeState {}

class IncomeError extends IncomeState {
  final String message;
  IncomeError(this.message);
}

class IncomeSuccess extends IncomeState {
  final IncomeOverviewModel data;
  IncomeSuccess(this.data);
}


class AddIncomeSuccess extends IncomeState {
  final String message;
  AddIncomeSuccess({this.message = "Income added successfully!"});
}