
class DebtModel {
  final String id;
  final String name;
  final String date;
  final String amount;
  final String status; 
  final String description;

  DebtModel({
    required this.id,
    required this.name,
    required this.date,
    required this.amount,
    required this.status,
    this.description = "Personal loan description",
  });
}