import '../../domain/entity/budget_data.dart';

class BudgetDataModel {
  String? id;
  String? userId;
  String? category;
  String? allocatedAmount;
  String? spentAmount;
  String? startDate;
  String? endDate;
  String? description;
  String? createdAt;
  String? updatedAt;
  //String? status;

  BudgetDataModel({
    this.id,
    this.userId,
    this.category,
    this.allocatedAmount,
    this.spentAmount,
    this.startDate,
    this.endDate,
    this.description,
    this.createdAt,
    this.updatedAt,
    // this.status,
  });

  BudgetDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    userId = json['userId']?.toString();
    category = json['category'];
    allocatedAmount = json['allocatedAmount']?.toString();
    spentAmount = json['spentAmount']?.toString();
    startDate = json['startDate'];
    endDate = json['endDate'];
    description = json['description'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    //  status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['category'] = category;
    data['allocatedAmount'] = allocatedAmount;
    data['spentAmount'] = spentAmount;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['description'] = description;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    // data['status'] = status;
    return data;
  }

  BudgetData toEntity() {
    return BudgetData(
      id: id,
      userId: userId,
      category: category,
      allocatedAmount: allocatedAmount,
      spentAmount: spentAmount,
      startDate: startDate,
      endDate: endDate,
      description: description,
      createdAt: createdAt,
      updatedAt: updatedAt,
      //   status: status,
    );
  }
}
