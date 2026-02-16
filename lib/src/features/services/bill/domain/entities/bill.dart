import 'bill_status.dart';
import 'participant.dart';

/// Base Bill entity
class BillEntity {
  final String id;
  final String name;
  final double amount;
  final DateTime dueDate;
  final BillStatus status;
  final bool isGroupBill;
  final String? invoiceNumber;
  final bool reminderEnabled;
  final ReminderFrequency reminderFrequency;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const BillEntity({
    required this.id,
    required this.name,
    required this.amount,
    required this.dueDate,
    required this.status,
    this.isGroupBill = false,
    this.invoiceNumber,
    this.reminderEnabled = false,
    this.reminderFrequency = ReminderFrequency.none,
    this.createdAt,
    this.updatedAt,
  });

  BillEntity copyWith({
    String? id,
    String? name,
    double? amount,
    DateTime? dueDate,
    BillStatus? status,
    bool? isGroupBill,
    String? invoiceNumber,
    bool? reminderEnabled,
    ReminderFrequency? reminderFrequency,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BillEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      isGroupBill: isGroupBill ?? this.isGroupBill,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderFrequency: reminderFrequency ?? this.reminderFrequency,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BillEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Group Bill entity with participants and split info
class GroupBillEntity extends BillEntity {
  final String? subtitle;
  final List<ParticipantEntity> participants;
  final SplitMethod splitMethod;
  final double userShare;
  final double contributionPercentage;

  const GroupBillEntity({
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
    this.subtitle,
    this.participants = const [],
    this.splitMethod = SplitMethod.equal,
    this.userShare = 0.0,
    this.contributionPercentage = 0.0,
  }) : super(isGroupBill: true);

  @override
  GroupBillEntity copyWith({
    String? id,
    String? name,
    double? amount,
    DateTime? dueDate,
    BillStatus? status,
    bool? isGroupBill,
    String? invoiceNumber,
    bool? reminderEnabled,
    ReminderFrequency? reminderFrequency,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? subtitle,
    List<ParticipantEntity>? participants,
    SplitMethod? splitMethod,
    double? userShare,
    double? contributionPercentage,
  }) {
    return GroupBillEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderFrequency: reminderFrequency ?? this.reminderFrequency,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      subtitle: subtitle ?? this.subtitle,
      participants: participants ?? this.participants,
      splitMethod: splitMethod ?? this.splitMethod,
      userShare: userShare ?? this.userShare,
      contributionPercentage: contributionPercentage ?? this.contributionPercentage,
    );
  }
}

