import '../../domain/entities/bill.dart';
import '../../domain/entities/bill_status.dart';
import '../../domain/entities/participant.dart';
import '../../domain/repositories/bill_repository.dart';
import '../data_sources/bill_remote_data_source.dart';
import '../models/bill_model.dart';

class BillRepositoryImpl implements BillRepository {
  final BillRemoteDataSource remoteDataSource;

  /// Set to false when real APIs are ready
  static const bool _useMockData = true;

  BillRepositoryImpl({required this.remoteDataSource});

  // ============ MOCK DATA ============

  final List<BillEntity> _mockIndividualBills = [
    BillEntity(
      id: '1',
      name: 'Electricity Bill',
      amount: 125.50,
      dueDate: DateTime.now().add(const Duration(days: 5)),
      status: BillStatus.unpaid,
      isGroupBill: false,
      invoiceNumber: 'INV-2026-001',
      reminderEnabled: true,
      reminderFrequency: ReminderFrequency.weekly,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
    BillEntity(
      id: '2',
      name: 'Internet Service',
      amount: 79.99,
      dueDate: DateTime.now().add(const Duration(days: 12)),
      status: BillStatus.unpaid,
      isGroupBill: false,
      invoiceNumber: 'INV-2026-002',
      reminderEnabled: true,
      reminderFrequency: ReminderFrequency.monthly,
      createdAt: DateTime.now().subtract(const Duration(days: 8)),
    ),
    BillEntity(
      id: '3',
      name: 'Water Bill',
      amount: 45.00,
      dueDate: DateTime.now().subtract(const Duration(days: 2)),
      status: BillStatus.paid,
      isGroupBill: false,
      invoiceNumber: 'INV-2026-003',
      reminderEnabled: false,
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
    ),
    BillEntity(
      id: '4',
      name: 'Phone Bill',
      amount: 55.00,
      dueDate: DateTime.now().subtract(const Duration(days: 5)),
      status: BillStatus.overdue,
      isGroupBill: false,
      invoiceNumber: 'INV-2026-004',
      reminderEnabled: true,
      reminderFrequency: ReminderFrequency.daily,
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
    ),
    BillEntity(
      id: '5',
      name: 'Gas Bill',
      amount: 38.75,
      dueDate: DateTime.now().add(const Duration(days: 20)),
      status: BillStatus.unpaid,
      isGroupBill: false,
      invoiceNumber: 'INV-2026-005',
      reminderEnabled: true,
      reminderFrequency: ReminderFrequency.weekly,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  final List<GroupBillEntity> _mockGroupBills = [
    GroupBillEntity(
      id: 'g1',
      name: 'Dinner at Restaurant',
      amount: 240.00,
      dueDate: DateTime.now().add(const Duration(days: 3)),
      status: BillStatus.unpaid,
      subtitle: 'Split among 4 friends',
      splitMethod: SplitMethod.equal,
      userShare: 60.00,
      contributionPercentage: 25.0,
      participants: [
        ParticipantEntity(
          id: 'p1',
          name: 'Ahmed Cirve',
          isCurrentUser: true,
          shareAmount: 60.00,
          sharePercentage: 25.0,
          hasPaid: true,
          avatarColor: ParticipantColors.getColor(0),
        ),
        ParticipantEntity(
          id: 'p2',
          name: 'Sara Ali',
          shareAmount: 60.00,
          sharePercentage: 25.0,
          hasPaid: false,
          avatarColor: ParticipantColors.getColor(1),
        ),
        ParticipantEntity(
          id: 'p3',
          name: 'Omar Hassan',
          shareAmount: 60.00,
          sharePercentage: 25.0,
          hasPaid: true,
          avatarColor: ParticipantColors.getColor(2),
        ),
        ParticipantEntity(
          id: 'p4',
          name: 'Layla Mahmoud',
          shareAmount: 60.00,
          sharePercentage: 25.0,
          hasPaid: false,
          avatarColor: ParticipantColors.getColor(3),
        ),
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    GroupBillEntity(
      id: 'g2',
      name: 'Apartment Rent',
      amount: 1800.00,
      dueDate: DateTime.now().add(const Duration(days: 15)),
      status: BillStatus.unpaid,
      subtitle: 'Monthly rent split',
      splitMethod: SplitMethod.percentage,
      userShare: 720.00,
      contributionPercentage: 40.0,
      participants: [
        ParticipantEntity(
          id: 'p1',
          name: 'Ahmed Cirve',
          isCurrentUser: true,
          shareAmount: 720.00,
          sharePercentage: 40.0,
          hasPaid: true,
          avatarColor: ParticipantColors.getColor(0),
        ),
        ParticipantEntity(
          id: 'p5',
          name: 'Khalid Nasser',
          shareAmount: 540.00,
          sharePercentage: 30.0,
          hasPaid: false,
          avatarColor: ParticipantColors.getColor(4),
        ),
        ParticipantEntity(
          id: 'p6',
          name: 'Yousef Tamer',
          shareAmount: 540.00,
          sharePercentage: 30.0,
          hasPaid: true,
          avatarColor: ParticipantColors.getColor(5),
        ),
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    GroupBillEntity(
      id: 'g3',
      name: 'Trip Expenses',
      amount: 500.00,
      dueDate: DateTime.now().subtract(const Duration(days: 1)),
      status: BillStatus.paid,
      subtitle: 'Weekend getaway',
      splitMethod: SplitMethod.equal,
      userShare: 250.00,
      contributionPercentage: 50.0,
      participants: [
        ParticipantEntity(
          id: 'p1',
          name: 'Ahmed Cirve',
          isCurrentUser: true,
          shareAmount: 250.00,
          sharePercentage: 50.0,
          hasPaid: true,
          avatarColor: ParticipantColors.getColor(0),
        ),
        ParticipantEntity(
          id: 'p7',
          name: 'Nour Saleh',
          shareAmount: 250.00,
          sharePercentage: 50.0,
          hasPaid: true,
          avatarColor: ParticipantColors.getColor(6),
        ),
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
  ];

  // ============ REPOSITORY METHODS ============

  @override
  Future<List<BillEntity>> getBills({
    bool? isGroupBill,
    String? searchQuery,
  }) async {
    if (_useMockData) {
      await Future.delayed(const Duration(milliseconds: 300));
      List<BillEntity> allBills = [..._mockIndividualBills, ..._mockGroupBills];

      if (isGroupBill != null) {
        allBills = allBills.where((b) => b.isGroupBill == isGroupBill).toList();
      }

      if (searchQuery != null && searchQuery.isNotEmpty) {
        allBills = allBills
            .where(
              (b) => b.name.toLowerCase().contains(searchQuery.toLowerCase()),
            )
            .toList();
      }

      return allBills;
    }
    return await remoteDataSource.getBills(
      isGroupBill: isGroupBill,
      searchQuery: searchQuery,
    );
  }

  @override
  Future<BillEntity> getBillById(String id) async {
    if (_useMockData) {
      await Future.delayed(const Duration(milliseconds: 200));
      final allBills = <BillEntity>[
        ..._mockIndividualBills,
        ..._mockGroupBills,
      ];
      return allBills.firstWhere(
        (b) => b.id == id,
        orElse: () => _mockIndividualBills.first,
      );
    }
    return await remoteDataSource.getBillById(id);
  }

  @override
  Future<BillEntity> createBill(BillEntity bill) async {
    if (_useMockData) {
      await Future.delayed(const Duration(milliseconds: 300));
      if (bill is GroupBillEntity) {
        _mockGroupBills.insert(0, bill);
      } else {
        _mockIndividualBills.insert(0, bill);
      }
      return bill;
    }
    final isGroup = bill is GroupBillEntity;
    final Map<String, dynamic> data;

    if (isGroup) {
      data = GroupBillModel.fromEntity(bill).toJson();
    } else {
      data = BillModel.fromEntity(bill).toJson();
    }

    return await remoteDataSource.createBill(data, isGroup: isGroup);
  }

  @override
  Future<BillEntity> updateBill(BillEntity bill) async {
    if (_useMockData) {
      await Future.delayed(const Duration(milliseconds: 200));
      if (bill is GroupBillEntity) {
        final index = _mockGroupBills.indexWhere((b) => b.id == bill.id);
        if (index != -1) _mockGroupBills[index] = bill;
      } else {
        final index = _mockIndividualBills.indexWhere((b) => b.id == bill.id);
        if (index != -1) _mockIndividualBills[index] = bill;
      }
      return bill;
    }
    final isGroup = bill is GroupBillEntity;
    final Map<String, dynamic> data;

    if (isGroup) {
      data = GroupBillModel.fromEntity(bill).toJson();
    } else {
      data = BillModel.fromEntity(bill).toJson();
    }

    return await remoteDataSource.updateBill(bill.id, data, isGroup: isGroup);
  }

  @override
  Future<void> deleteBill(String id) async {
    if (_useMockData) {
      await Future.delayed(const Duration(milliseconds: 200));
      _mockIndividualBills.removeWhere((b) => b.id == id);
      _mockGroupBills.removeWhere((b) => b.id == id);
      return;
    }
    await remoteDataSource.deleteBill(id);
  }

  @override
  Future<BillEntity> updateBillStatus(String id, BillStatus status) async {
    if (_useMockData) {
      await Future.delayed(const Duration(milliseconds: 200));
      // Update in individual bills
      final indIdx = _mockIndividualBills.indexWhere((b) => b.id == id);
      if (indIdx != -1) {
        _mockIndividualBills[indIdx] = _mockIndividualBills[indIdx].copyWith(
          status: status,
        );
        return _mockIndividualBills[indIdx];
      }
      // Update in group bills
      final grpIdx = _mockGroupBills.indexWhere((b) => b.id == id);
      if (grpIdx != -1) {
        _mockGroupBills[grpIdx] = _mockGroupBills[grpIdx].copyWith(
          status: status,
        );
        return _mockGroupBills[grpIdx];
      }
      throw Exception('Bill not found');
    }
    return await remoteDataSource.updateBillStatus(id, status);
  }

  @override
  Future<BillEntity> smartParseBill(String imageData) async {
    if (_useMockData) {
      await Future.delayed(const Duration(milliseconds: 500));
      return BillEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: 'Parsed Bill',
        amount: 99.99,
        dueDate: DateTime.now().add(const Duration(days: 7)),
        status: BillStatus.unpaid,
      );
    }
    return await remoteDataSource.smartParseBill(imageData);
  }

  @override
  Future<List<BillEntity>> getIndividualBills({String? searchQuery}) async {
    if (_useMockData) {
      await Future.delayed(const Duration(milliseconds: 300));
      if (searchQuery != null && searchQuery.isNotEmpty) {
        return _mockIndividualBills
            .where(
              (b) => b.name.toLowerCase().contains(searchQuery.toLowerCase()),
            )
            .toList();
      }
      return List.from(_mockIndividualBills);
    }
    final bills = await remoteDataSource.getBills(
      isGroupBill: false,
      searchQuery: searchQuery,
    );
    return bills.where((b) => !b.isGroupBill).toList();
  }

  @override
  Future<List<GroupBillEntity>> getGroupBills({String? searchQuery}) async {
    if (_useMockData) {
      await Future.delayed(const Duration(milliseconds: 300));
      if (searchQuery != null && searchQuery.isNotEmpty) {
        return _mockGroupBills
            .where(
              (b) => b.name.toLowerCase().contains(searchQuery.toLowerCase()),
            )
            .toList();
      }
      return List.from(_mockGroupBills);
    }
    final bills = await remoteDataSource.getBills(
      isGroupBill: true,
      searchQuery: searchQuery,
    );
    return bills
        .where((b) => b.isGroupBill)
        .map((b) => b as GroupBillEntity)
        .toList();
  }
}
