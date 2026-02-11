import '../../domain/entities/bill.dart';
import '../../domain/entities/bill_status.dart';
import 'participant_model.dart';

/// Bill model for API serialization
class BillModel extends BillEntity {
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
  });

  /// Create BillModel from JSON
  factory BillModel.fromJson(Map<String, dynamic> json) {
    return BillModel(
      id: json['id'] as String? ?? json['_id'] as String? ?? '',
      name: json['name'] as String? ?? json['billName'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'] as String)
          : DateTime.now(),
      status: BillStatus.fromId(json['status'] as String? ?? 'unpaid'),
      isGroupBill: json['isGroupBill'] as bool? ?? json['isGroup'] as bool? ?? false,
      invoiceNumber: json['invoiceNumber'] as String?,
      reminderEnabled: json['reminderEnabled'] as bool? ?? json['reminder'] as bool? ?? false,
      reminderFrequency: ReminderFrequency.fromId(
        json['reminderFrequency'] as String? ?? 'none',
      ),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  /// Convert to JSON for API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'dueDate': dueDate.toIso8601String(),
      'status': status.id,
      'isGroupBill': isGroupBill,
      if (invoiceNumber != null) 'invoiceNumber': invoiceNumber,
      'reminderEnabled': reminderEnabled,
      'reminderFrequency': reminderFrequency.id,
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
}

/// Group Bill model for API serialization
class GroupBillModel extends GroupBillEntity {
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
  });

  /// Create GroupBillModel from JSON
  factory GroupBillModel.fromJson(Map<String, dynamic> json) {
    final participantsList = json['participants'] as List<dynamic>? ?? [];
    
    return GroupBillModel(
      id: json['id'] as String? ?? json['_id'] as String? ?? '',
      name: json['name'] as String? ?? json['billName'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 
              (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'] as String)
          : DateTime.now(),
      status: BillStatus.fromId(json['status'] as String? ?? 'unpaid'),
      invoiceNumber: json['invoiceNumber'] as String?,
      reminderEnabled: json['reminderEnabled'] as bool? ?? false,
      reminderFrequency: ReminderFrequency.fromId(
        json['reminderFrequency'] as String? ?? 'none',
      ),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      subtitle: json['subtitle'] as String? ?? json['description'] as String?,
      participants: participantsList
          .map((p) => ParticipantModel.fromJson(p as Map<String, dynamic>))
          .toList(),
      splitMethod: SplitMethod.fromId(json['splitMethod'] as String? ?? 'equal'),
      userShare: (json['userShare'] as num?)?.toDouble() ?? 
                 (json['myShare'] as num?)?.toDouble() ?? 0.0,
      contributionPercentage: (json['contributionPercentage'] as num?)?.toDouble() ?? 
                              (json['contribution'] as num?)?.toDouble() ?? 0.0,
    );
  }

  /// Convert to JSON for API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'dueDate': dueDate.toIso8601String(),
      'status': status.id,
      'isGroupBill': true,
      if (invoiceNumber != null) 'invoiceNumber': invoiceNumber,
      'reminderEnabled': reminderEnabled,
      'reminderFrequency': reminderFrequency.id,
      if (subtitle != null) 'subtitle': subtitle,
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
}

