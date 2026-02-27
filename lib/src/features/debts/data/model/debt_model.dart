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
    this.description = "",
  });

  factory DebtModel.fromJson(Map<String, dynamic> json) {
    return DebtModel(
      id: json['id'] ?? "",
      name: json['personalName'] ?? "",
      date: json['dueDate'] ?? "",
      amount: json['amount'].toString(),
      status: json['status'] ?? "UNPAID",
      description: json['description'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "personalName": name,
      "direction": "I_OWE",
      "amount": amount, 
      "dueDate": date,
      "description": description.isEmpty ? "No description" : description,
      "reminderEnabled": false,
      "remindAt": null,
      "assetId": null 
    };
  }
}