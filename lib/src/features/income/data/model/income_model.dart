class IncomeModel {
  final String id;
  final String userId;
  final double amount;
  final String currencyId;
  final String source;
  final String description;
  final DateTime incomeDate;
  final String createdAt;
  final String updatedAt;

  IncomeModel({
    required this.id,
    required this.userId,
    required this.amount,
    required this.currencyId,
    required this.source,
    required this.description,
    required this.incomeDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory IncomeModel.fromJson(Map<String, dynamic> json) {
    return IncomeModel(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      currencyId: json['currencyId'] as String? ?? '',
      source: json['source'] as String? ?? '',
      description: json['description'] as String? ?? '',
      incomeDate:
          DateTime.tryParse(json['incomeDate'] as String? ?? '') ??
          DateTime.now(),
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
    );
  }
}

class IncomeListResponse {
  final bool success;
  final Meta meta;
  final String message;
  final List<IncomeModel> data;

  IncomeListResponse({
    required this.success,
    required this.meta,
    required this.message,
    required this.data,
  });

  factory IncomeListResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'];
    if (list is! List) {
      list = [];
    }

    return IncomeListResponse(
      success: json['success'] as bool? ?? false,
      meta: Meta.fromJson(json['meta'] as Map<String, dynamic>? ?? {}),
      message: json['message'] as String? ?? '',
      data: (list)
          .map((e) => IncomeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Meta {
  final int page;
  final int limit;
  final int totalPages;
  final int total;

  Meta({
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.total,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      page: json['page'] as int? ?? 0,
      limit: json['limit'] as int? ?? 0,
      totalPages: json['totalPages'] as int? ?? 0,
      total: json['total'] as int? ?? 0,
    );
  }
}
