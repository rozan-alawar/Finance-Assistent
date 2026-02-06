
import 'package:finance_assistent/src/features/debts/data/model/debt_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class DebtState {}
class DebtInitial extends DebtState {}
class DebtLoaded extends DebtState {
  final List<DebtModel> debts;
  final String selectedFilter;
  DebtLoaded(this.debts, this.selectedFilter);
}

class DebtCubit extends Cubit<DebtState> {
  DebtCubit() : super(DebtInitial());

  final List<DebtModel> _allData = [
  DebtModel(
    id: "1", 
    name: "Ghydaa jamal", 
    status: "Unpaid", 
    amount: "23,4455", 
    date: "Dec 25, 2024",
    description: "Personal loan for car repair"
  ),
  DebtModel(
    id: "2", 
    name: "Ahmed jamal", 
    status: "Overdue", 
    amount: "23,4455", 
    date: "Dec 25, 2024",
    description: "Personal loan for car repair"
  ),
  DebtModel(
    id: "3", 
    name: "Ahmed jamal", 
    status: "Paid", 
    amount: "23,4455", 
    date: "Dec 25, 2024",
    description: "Personal loan for car repair"
  ),
];

  void fetchDebts({String filter = "All"}) {
    if (filter == "All") {
      emit(DebtLoaded(_allData, filter));
    } else {
      final filtered = _allData.where((d) => 
        d.status.toLowerCase().replaceAll(" ", "") == filter.toLowerCase().replaceAll(" ", "")
      ).toList();
      emit(DebtLoaded(filtered, filter));
    }
  }
}