import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/bill.dart';
import '../../domain/entities/bill_status.dart';
import '../../domain/entities/participant.dart';
/// Local data source for bill operations using SharedPreferences
abstract class BillLocalDataSource {
  Future<List<BillEntity>> getBills({String? type});
  Future<BillEntity> getBillById(String id);
  Future<BillEntity> createBill(BillEntity bill);
  Future<BillEntity> updateBill(BillEntity bill);
  Future<void> deleteBill(String id);
  Future<BillEntity> updateBillStatus(String id, BillStatus status);
}

class BillLocalDataSourceImpl implements BillLocalDataSource {
  final SharedPreferences sharedPreferences;

  static const String _billsKey = 'bills_data';
  static const String _initialized = 'bills_initialized';

  BillLocalDataSourceImpl({required this.sharedPreferences}) {
    _initSeedData();
  }

  /// Seed initial data if first time
  void _initSeedData() {
    if (sharedPreferences.getBool(_initialized) == true) return;

    final seedBills = <Map<String, dynamic>>[
      {
        'id': 'bill_1',
        'name': 'Electricity Bill',
        'amount': 125.50,
        'date': DateTime.now().add(const Duration(days: 5)).toIso8601String(),
        'status': 'unpaid',
        'type': 'individual',
        'description': 'Monthly electricity bill',
        'currencyId': '',
      },
      {
        'id': 'bill_2',
        'name': 'Internet Service',
        'amount': 79.99,
        'date': DateTime.now().add(const Duration(days: 12)).toIso8601String(),
        'status': 'unpaid',
        'type': 'individual',
        'description': 'Monthly internet subscription',
      },
      {
        'id': 'bill_3',
        'name': 'Water Bill',
        'amount': 45.00,
        'date':
            DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
        'status': 'paid',
        'type': 'individual',
        'description': 'Monthly water bill',
      },
      {
        'id': 'bill_4',
        'name': 'Phone Bill',
        'amount': 55.00,
        'date':
            DateTime.now().subtract(const Duration(days: 5)).toIso8601String(),
        'status': 'unpaid',
        'type': 'individual',
        'description': 'Mobile phone plan',
      },
      {
        'id': 'bill_5',
        'name': 'Gas Bill',
        'amount': 38.75,
        'date': DateTime.now().add(const Duration(days: 20)).toIso8601String(),
        'status': 'unpaid',
        'type': 'individual',
        'description': 'Monthly gas bill',
      },
      // Group bills
      {
        'id': 'gbill_1',
        'name': 'Dinner at Restaurant',
        'amount': 240.00,
        'date': DateTime.now().add(const Duration(days: 3)).toIso8601String(),
        'status': 'unpaid',
        'type': 'group',
        'description': 'Split among 4 friends',
        'splitMethod': 'equal',
        'userShare': 60.00,
        'contributionPercentage': 25.0,
        'participants': [
          {
            'id': 'p1',
            'name': 'Ahmed Cirve',
            'isCurrentUser': true,
            'shareAmount': 60.00,
            'sharePercentage': 25.0,
            'hasPaid': true,
          },
          {
            'id': 'p2',
            'name': 'Sara Ali',
            'shareAmount': 60.00,
            'sharePercentage': 25.0,
            'hasPaid': false,
          },
          {
            'id': 'p3',
            'name': 'Omar Hassan',
            'shareAmount': 60.00,
            'sharePercentage': 25.0,
            'hasPaid': true,
          },
          {
            'id': 'p4',
            'name': 'Layla Mahmoud',
            'shareAmount': 60.00,
            'sharePercentage': 25.0,
            'hasPaid': false,
          },
        ],
      },
      {
        'id': 'gbill_2',
        'name': 'Apartment Rent',
        'amount': 1800.00,
        'date': DateTime.now().add(const Duration(days: 15)).toIso8601String(),
        'status': 'unpaid',
        'type': 'group',
        'description': 'Monthly rent split',
        'splitMethod': 'percentage',
        'userShare': 720.00,
        'contributionPercentage': 40.0,
        'participants': [
          {
            'id': 'p1',
            'name': 'Ahmed Cirve',
            'isCurrentUser': true,
            'shareAmount': 720.00,
            'sharePercentage': 40.0,
            'hasPaid': true,
          },
          {
            'id': 'p5',
            'name': 'Khalid Nasser',
            'shareAmount': 540.00,
            'sharePercentage': 30.0,
            'hasPaid': false,
          },
          {
            'id': 'p6',
            'name': 'Yousef Tamer',
            'shareAmount': 540.00,
            'sharePercentage': 30.0,
            'hasPaid': true,
          },
        ],
      },
      {
        'id': 'gbill_3',
        'name': 'Trip Expenses',
        'amount': 500.00,
        'date':
            DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
        'status': 'paid',
        'type': 'group',
        'description': 'Weekend getaway',
        'splitMethod': 'equal',
        'userShare': 250.00,
        'contributionPercentage': 50.0,
        'participants': [
          {
            'id': 'p1',
            'name': 'Ahmed Cirve',
            'isCurrentUser': true,
            'shareAmount': 250.00,
            'sharePercentage': 50.0,
            'hasPaid': true,
          },
          {
            'id': 'p7',
            'name': 'Nour Saleh',
            'shareAmount': 250.00,
            'sharePercentage': 50.0,
            'hasPaid': true,
          },
        ],
      },
    ];

    sharedPreferences.setString(_billsKey, json.encode(seedBills));
    sharedPreferences.setBool(_initialized, true);
  }

  List<Map<String, dynamic>> _readAll() {
    final jsonString = sharedPreferences.getString(_billsKey);
    if (jsonString == null || jsonString.isEmpty) return [];
    final list = json.decode(jsonString) as List<dynamic>;
    return list.cast<Map<String, dynamic>>();
  }

  Future<void> _writeAll(List<Map<String, dynamic>> bills) async {
    await sharedPreferences.setString(_billsKey, json.encode(bills));
  }

  /// Convert a BillEntity/GroupBillEntity to storable JSON
  Map<String, dynamic> _entityToJson(BillEntity bill) {
    final map = <String, dynamic>{
      'id': bill.id,
      'name': bill.name,
      'amount': bill.amount,
      'date': bill.dueDate.toIso8601String(),
      'status': bill.status.id,
      'type': bill.isGroupBill ? 'group' : 'individual',
      'createdAt': bill.createdAt?.toIso8601String() ??
          DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    };

    if (bill is GroupBillEntity) {
      map['subtitle'] = bill.subtitle ?? '';
      map['description'] = bill.subtitle ?? '';
      map['splitMethod'] = bill.splitMethod.id;
      map['userShare'] = bill.userShare;
      map['contributionPercentage'] = bill.contributionPercentage;
      map['participants'] = bill.participants.map((p) {
        return {
          'id': p.id,
          'name': p.name,
          'shareAmount': p.shareAmount,
          'sharePercentage': p.sharePercentage,
          'hasPaid': p.hasPaid,
          'isCurrentUser': p.isCurrentUser,
          if (p.avatarUrl != null) 'avatarUrl': p.avatarUrl,
        };
      }).toList();
    }

    return map;
  }

  /// Convert stored JSON to BillEntity or GroupBillEntity
  BillEntity _jsonToEntity(Map<String, dynamic> map) {
    final type = map['type'] as String? ?? 'individual';

    if (type == 'group') {
      final participantsList = map['participants'] as List<dynamic>? ?? [];
      return GroupBillEntity(
        id: map['id'] as String,
        name: map['name'] as String? ?? '',
        amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
        dueDate: DateTime.tryParse(map['date'] as String? ?? '') ??
            DateTime.now(),
        status: BillStatus.fromId(map['status'] as String? ?? 'unpaid'),
        subtitle: map['subtitle'] as String? ?? map['description'] as String?,
        splitMethod:
            SplitMethod.fromId(map['splitMethod'] as String? ?? 'equal'),
        userShare: (map['userShare'] as num?)?.toDouble() ?? 0.0,
        contributionPercentage:
            (map['contributionPercentage'] as num?)?.toDouble() ?? 0.0,
        participants: participantsList.map((p) {
          final pm = p as Map<String, dynamic>;
          return ParticipantEntity(
            id: pm['id'] as String? ?? '',
            name: pm['name'] as String? ?? '',
            shareAmount: (pm['shareAmount'] as num?)?.toDouble() ?? 0.0,
            sharePercentage:
                (pm['sharePercentage'] as num?)?.toDouble() ?? 0.0,
            hasPaid: pm['hasPaid'] as bool? ?? false,
            isCurrentUser: pm['isCurrentUser'] as bool? ?? false,
            avatarColor: ParticipantColors.getColor(
              participantsList.indexOf(p),
            ),
          );
        }).toList(),
        createdAt: map['createdAt'] != null
            ? DateTime.tryParse(map['createdAt'] as String)
            : null,
        updatedAt: map['updatedAt'] != null
            ? DateTime.tryParse(map['updatedAt'] as String)
            : null,
      );
    }

    return BillEntity(
      id: map['id'] as String,
      name: map['name'] as String? ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      dueDate:
          DateTime.tryParse(map['date'] as String? ?? '') ?? DateTime.now(),
      status: BillStatus.fromId(map['status'] as String? ?? 'unpaid'),
      isGroupBill: false,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'] as String)
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt'] as String)
          : null,
    );
  }

  @override
  Future<List<BillEntity>> getBills({String? type}) async {
    final all = _readAll();

    List<Map<String, dynamic>> filtered = all;
    if (type != null) {
      filtered = all.where((m) => m['type'] == type).toList();
    }

    return filtered.map(_jsonToEntity).toList();
  }

  @override
  Future<BillEntity> getBillById(String id) async {
    final all = _readAll();
    final map = all.firstWhere(
      (m) => m['id'] == id,
      orElse: () => throw Exception('Bill not found'),
    );
    return _jsonToEntity(map);
  }

  @override
  Future<BillEntity> createBill(BillEntity bill) async {
    final all = _readAll();

    // Generate an ID if empty
    final newBill = bill.id.isEmpty
        ? bill.copyWith(id: 'bill_${DateTime.now().millisecondsSinceEpoch}')
        : bill;

    all.insert(0, _entityToJson(newBill));
    await _writeAll(all);
    return newBill;
  }

  @override
  Future<BillEntity> updateBill(BillEntity bill) async {
    final all = _readAll();
    final index = all.indexWhere((m) => m['id'] == bill.id);
    if (index != -1) {
      all[index] = _entityToJson(bill);
      await _writeAll(all);
    }
    return bill;
  }

  @override
  Future<void> deleteBill(String id) async {
    final all = _readAll();
    all.removeWhere((m) => m['id'] == id);
    await _writeAll(all);
  }

  @override
  Future<BillEntity> updateBillStatus(String id, BillStatus status) async {
    final all = _readAll();
    final index = all.indexWhere((m) => m['id'] == id);
    if (index == -1) throw Exception('Bill not found');

    all[index]['status'] = status.id;
    all[index]['updatedAt'] = DateTime.now().toIso8601String();
    await _writeAll(all);

    return _jsonToEntity(all[index]);
  }
}

