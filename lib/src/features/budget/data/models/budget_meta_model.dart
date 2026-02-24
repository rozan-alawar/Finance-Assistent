class BudgetMetaModel {
  int? total;
  int? page;
  int? limit;
  int? totalPages;

  BudgetMetaModel({this.total, this.page, this.limit, this.totalPages});

  BudgetMetaModel.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    page = json['page'];
    limit = json['limit'];
    totalPages = json['totalPages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    data['page'] = page;
    data['limit'] = limit;
    data['totalPages'] = totalPages;
    return data;
  }
}
