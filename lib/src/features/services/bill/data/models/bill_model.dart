import '../../domain/entities/bill.dart';
import '../../domain/entities/bill_status.dart';
import 'participant_model.dart';

/// Bill model for API serialization
/// API uses `type` ("individual"/"group") instead of `isGroupBill`
/// Amounts can be strings from the API
class BillModel extends BillEntity {
  final String? description;
  final String? currencyId;
  final String? assetId;
  final String? title;
  final String? amountTotal;

  const BillModel({
    required super.id,
    required super.name,
    required super.amount,
    required super.dueDate,
    required super.status,
    super.isGroupBill,
    super.invoiceNumber,
    super.reminderEnabled,
    super.reminderFrequency,
    super.createdAt,
    super.updatedAt,
    this.description,
    this.currencyId,
    this.assetId,
    this.title,
    this.amountTotal,
  });

  /// Create BillModel from API JSON response
  /// Handles both list items and detail responses
  factory BillModel.fromJson(Map<String, dynamic> json) {
    // Handle wrapped response: { "data": { ... } }
    final data = json.containsKey('data') && json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    // Determine if group bill from `type` field
    final type = data['type'] as String? ?? 'individual';
    final isGroup = type.toLowerCase() == 'group' ||
        data['isGroupBill'] == true ||
        data['isGroup'] == true;

    return BillModel(
      id: (data['id'] ?? data['_id'] ?? '').toString(),
      name: data['name'] as String? ?? data['title'] as String? ?? '',
      amount: _parseDouble(data['amount'] ?? data['amountTotal']),
      dueDate: _parseDate(data['dueDate'] ?? data['date']),
      status: BillStatus.fromId(data['status'] as String? ?? 'unpaid'),
      isGroupBill: isGroup,
      invoiceNumber: data['invoiceNumber'] as String?,
      reminderEnabled: data['reminderEnabled'] as bool? ?? false,
      reminderFrequency: ReminderFrequency.fromId(
        data['reminderFrequency'] as String? ?? 'none',
      ),
      createdAt: data['createdAt'] != null
          ? DateTime.tryParse(data['createdAt'] as String)
          : null,
      updatedAt: data['updatedAt'] != null
          ? DateTime.tryParse(data['updatedAt'] as String)
          : null,
      description: data['description'] as String?,
      currencyId: data['currencyId'] as String?,
      assetId: data['assetId'] as String?,
      title: data['title'] as String?,
      amountTotal: data['amountTotal']?.toString(),
    );
  }

  /// Convert to JSON for POST /api/v1/bills (create bill)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'amount': amount,
      'date': dueDate.toIso8601String().split('T')[0], // "2023-11-20"
      'type': isGroupBill ? 'group' : 'individual',
      if (description != null && description!.isNotEmpty)
        'description': description,
      if (currencyId != null && currencyId!.isNotEmpty)
        'currencyId': currencyId,
      if (assetId != null && assetId!.isNotEmpty) 'assetId': assetId,
    };
  }

  /// Convert to JSON for PUT /api/v1/bills/{id} (update bill)
  Map<String, dynamic> toUpdateJson() {
    return {
      'name': name,
      'amount': amount,
      'date': dueDate.toIso8601String().split('T')[0],
      if (description != null && description!.isNotEmpty)
        'description': description,
      if (currencyId != null && currencyId!.isNotEmpty)
        'currencyId': currencyId,
      if (assetId != null && assetId!.isNotEmpty) 'assetId': assetId,
    };
  }

  /// Create from entity
  factory BillModel.fromEntity(BillEntity entity) {
    return BillModel(
      id: entity.id,
      name: entity.name,
      amount: entity.amount,
      dueDate: entity.dueDate,
      status: entity.status,
      isGroupBill: entity.isGroupBill,
      invoiceNumber: entity.invoiceNumber,
      reminderEnabled: entity.reminderEnabled,
      reminderFrequency: entity.reminderFrequency,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static DateTime _parseDate(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    return DateTime.now();
  }
}

/// Group Bill model for API serialization
class GroupBillModel extends GroupBillEntity {
  final String? description;
  final String? currencyId;
  final String? assetId;

  const GroupBillModel({
    required super.id,
    required super.name,
    required super.amount,
    required super.dueDate,
    required super.status,
    super.invoiceNumber,
    super.reminderEnabled,
    super.reminderFrequency,
    super.createdAt,
    super.updatedAt,
    super.subtitle,
    super.participants,
    super.splitMethod,
    super.userShare,
    super.contributionPercentage,
    this.description,
    this.currencyId,
    this.assetId,
  });

  /// Create GroupBillModel from JSON
  factory GroupBillModel.fromJson(Map<String, dynamic> json) {
    // Handle wrapped response
    final data = json.containsKey('data') && json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    final participantsList = data['participants'] as List<dynamic>? ?? [];

    return GroupBillModel(
      id: (data['id'] ?? data['_id'] ?? '').toString(),
      name: data['name'] as String? ?? data['title'] as String? ?? '',
      amount: _parseDouble(data['amount'] ?? data['amountTotal'] ?? data['totalAmount']),
      dueDate: _parseDate(data['dueDate'] ?? data['date']),
      status: BillStatus.fromId(data['status'] as String? ?? 'unpaid'),
      invoiceNumber: data['invoiceNumber'] as String?,
      reminderEnabled: data['reminderEnabled'] as bool? ?? false,
      reminderFrequency: ReminderFrequency.fromId(
        data['reminderFrequency'] as String? ?? 'none',
      ),
      createdAt: data['createdAt'] != null
          ? DateTime.tryParse(data['createdAt'] as String)
          : null,
      updatedAt: data['updatedAt'] != null
          ? DateTime.tryParse(data['updatedAt'] as String)
          : null,
      subtitle: data['subtitle'] as String? ?? data['description'] as String?,
      participants: participantsList
          .map((p) => ParticipantModel.fromJson(p as Map<String, dynamic>))
          .toList(),
      splitMethod: SplitMethod.fromId(data['splitMethod'] as String? ?? 'equal'),
      userShare: _parseDouble(data['userShare'] ?? data['myShare']),
      contributionPercentage: _parseDouble(
        data['contributionPercentage'] ?? data['contribution'],
      ),
      description: data['description'] as String?,
      currencyId: data['currencyId'] as String?,
      assetId: data['assetId'] as String?,
    );
  }

  /// Convert to JSON for POST /api/v1/bills (create group bill)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'amount': amount,
      'date': dueDate.toIso8601String().split('T')[0],
      'type': 'group',
      if (description != null && description!.isNotEmpty)
        'description': description,
      if (currencyId != null && currencyId!.isNotEmpty)
        'currencyId': currencyId,
      if (assetId != null && assetId!.isNotEmpty) 'assetId': assetId,
      if (participants.isNotEmpty)
        'participants': participants
            .map((p) => ParticipantModel.fromEntity(p).toJson())
            .toList(),
      'splitMethod': splitMethod.id,
    };
  }

  /// Create from entity
  factory GroupBillModel.fromEntity(GroupBillEntity entity) {
    return GroupBillModel(
      id: entity.id,
      name: entity.name,
      amount: entity.amount,
      dueDate: entity.dueDate,
      status: entity.status,
      invoiceNumber: entity.invoiceNumber,
      reminderEnabled: entity.reminderEnabled,
      reminderFrequency: entity.reminderFrequency,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      subtitle: entity.subtitle,
      participants: entity.participants,
      splitMethod: entity.splitMethod,
      userShare: entity.userShare,
      contributionPercentage: entity.contributionPercentage,
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static DateTime _parseDate(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    return DateTime.now();
  }
}
