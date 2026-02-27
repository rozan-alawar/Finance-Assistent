import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:finance_assistent/src/features/debts/data/model/debt_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class DebtState {}

class DebtInitial extends DebtState {}

class DebtLoading extends DebtState {}

class DebtLoaded extends DebtState {
  final List<DebtModel> debts;
  final String selectedFilter;
  final Map<String, dynamic> summary;
  final String searchQuery;

  DebtLoaded(
    this.debts,
    this.selectedFilter,
    this.summary, {
    this.searchQuery = "",
  });
}

class DebtDetailLoaded extends DebtState {
  final DebtModel debt;
  DebtDetailLoaded(this.debt);
}

class DebtError extends DebtState {
  final String message;
  DebtError(this.message);
}

class DebtCubit extends Cubit<DebtState> {
  DebtCubit() : super(DebtInitial());

  final String _baseUrl = "https://gsg-project-group-5.vercel.app/api/v1/debts";
  final String _token =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI1ZWJlN2VlOS1kNzVkLTQ4ZjItYWNkYS1kMGI0NjJiYjc0MzUiLCJyb2xlIjoiVVNFUiIsImVtYWlsIjoibW9hbWVuQGV4YW1wbGUuY29tIiwiZnVsbE5hbWUiOiJNb2FtZW4gQWwtWWF6b3VyaSIsInByb3ZpZGVyIjoiTE9DQUwiLCJzdGF0dXMiOiJBQ1RJVkUiLCJpYXQiOjE3NzE3MDE3NTB9.8qNAs0nG18m9SEVDKH_ky3E77MWoMYkxv9AymONK93Y";

  List<DebtModel> _allDebts = [];
  Map<String, dynamic> _summaryData = {
    'totalAmount': "0.00",
    'paidAmount': "0.00",
    'unpaidAmount': "0.00",
    'overdueAmount': "0.00",
  };

  Map<String, String> get _headers => {
    'Authorization': 'Bearer $_token',
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  Future<void> fetchDebts({String filter = "All", String query = ""}) async {
    if (state is! DebtLoaded) emit(DebtLoading());
    try {
      final response = await http.get(Uri.parse(_baseUrl), headers: _headers);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> list = data['data'];
        _allDebts = list.map((e) => DebtModel.fromJson(e)).toList();

        _calculateSummary(_allDebts);
        _applyFilters(filter, query);
      } else {
        emit(DebtError("Failed to fetch data"));
      }
    } catch (e) {
      emit(DebtError(e.toString()));
    }
  }

  void _applyFilters(String filter, String query) {
    List<DebtModel> filteredList = _allDebts;

    if (filter != "All") {
      String normalizedFilter = filter.replaceAll(" ", "").toUpperCase();
      filteredList = filteredList
          .where(
            (d) =>
                d.status.toUpperCase().replaceAll(" ", "") == normalizedFilter,
          )
          .toList();
    }

    if (query.isNotEmpty) {
      filteredList = filteredList
          .where(
            (d) =>
                d.name.toLowerCase().contains(query.toLowerCase()) ||
                (d.description.toLowerCase().contains(query.toLowerCase()) ??
                    false),
          )
          .toList();
    }

    emit(DebtLoaded(filteredList, filter, _summaryData, searchQuery: query));
  }

  void _calculateSummary(List<DebtModel> debts) {
    double total = 0;
    double paid = 0;
    double unpaid = 0;
    double overdue = 0;

    for (var debt in debts) {
      double amountValue = double.tryParse(debt.amount.toString()) ?? 0;
      total += amountValue;

      String status = debt.status.toUpperCase().replaceAll(" ", "");

      if (status == "PAID") {
        paid += amountValue;
      } else if (status == "OVERDUE") {
        overdue += amountValue;
        unpaid += amountValue;
      } else {
        unpaid += amountValue;
      }
    }

    _summaryData = {
      'totalAmount': total.toStringAsFixed(2),
      'paidAmount': paid.toStringAsFixed(2),
      'unpaidAmount': unpaid.toStringAsFixed(2),
      'overdueAmount': overdue.toStringAsFixed(2),
    };
  }

  Future<void> updateDebt(String id, Map<String, dynamic> updateData) async {
    try {
      final response = await http.patch(
        Uri.parse("$_baseUrl/$id"),
        headers: _headers,
        body: jsonEncode(updateData),
      );
      if (response.statusCode == 200) {
        await fetchDebts();
      }
    } catch (e) {
      emit(DebtError(e.toString()));
    }
  }

  Future<void> deleteDebt(String id) async {
    try {
      final response = await http.delete(
        Uri.parse("$_baseUrl/$id"),
        headers: _headers,
      );
      if (response.statusCode == 200 || response.statusCode == 204) {
        await fetchDebts();
      }
    } catch (e) {
      emit(DebtError(e.toString()));
    }
  }

  Future<bool> addDebt(DebtModel debt) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: _headers,
        body: jsonEncode(debt.toJson()),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchDebts();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
