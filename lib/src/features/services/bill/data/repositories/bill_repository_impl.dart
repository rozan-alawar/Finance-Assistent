import '../../domain/entities/bill.dart';
import '../../domain/entities/bill_status.dart';
import '../../domain/repositories/bill_repository.dart';
import '../data_sources/bill_local_data_source.dart';
import '../data_sources/bill_remote_data_source.dart';

class BillRepositoryImpl implements BillRepository {
  final BillRemoteDataSource remoteDataSource;
  final BillLocalDataSource localDataSource;

  /// Set to true to use SharedPreferences, false for real API
  static const bool _useLocalStorage = false;

  BillRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<BillEntity>> getBills({
    bool? isGroupBill,
    String? searchQuery,
  }) async {
    String? type;
    if (isGroupBill == true) {
      type = 'group';
    } else if (isGroupBill == false) {
      type = 'individual';
    }

    final List<BillEntity> bills;
    if (_useLocalStorage) {
      bills = await localDataSource.getBills(type: type);
    } else {
      bills = await remoteDataSource.getBills(type: type);
    }

    if (searchQuery != null && searchQuery.isNotEmpty) {
      return bills
          .where(
            (b) => b.name.toLowerCase().contains(searchQuery.toLowerCase()),
          )
          .toList();
    }

    return bills;
  }

  @override
  Future<BillEntity> getBillById(String id) async {
    if (_useLocalStorage) {
      return await localDataSource.getBillById(id);
    }
    return await remoteDataSource.getBillById(id);
  }

  @override
  Future<BillEntity> createBill(BillEntity bill) async {
    if (_useLocalStorage) {
      return await localDataSource.createBill(bill);
    }

    final Map<String, dynamic> data;
    if (bill is GroupBillEntity) {
      data = {
        'name': bill.name,
        'amount': bill.amount,
        'date': bill.dueDate.toIso8601String().split('T')[0],
        'type': 'group',
      };
    } else {
      data = {
        'name': bill.name,
        'amount': bill.amount,
        'date': bill.dueDate.toIso8601String().split('T')[0],
        'type': 'individual',
      };
    }
    return await remoteDataSource.createBill(data);
  }

  @override
  Future<BillEntity> updateBill(BillEntity bill) async {
    if (_useLocalStorage) {
      return await localDataSource.updateBill(bill);
    }

    final data = {
      'name': bill.name,
      'amount': bill.amount,
      'date': bill.dueDate.toIso8601String().split('T')[0],
    };
    return await remoteDataSource.updateBill(bill.id, data);
  }

  @override
  Future<void> deleteBill(String id) async {
    if (_useLocalStorage) {
      await localDataSource.deleteBill(id);
      return;
    }
    await remoteDataSource.deleteBill(id);
  }

  @override
  Future<BillEntity> updateBillStatus(String id, BillStatus status) async {
    if (_useLocalStorage) {
      return await localDataSource.updateBillStatus(id, status);
    }
    return await remoteDataSource.updateBillStatus(id, status);
  }

  @override
  Future<BillEntity> smartParseBill(String imageData) async {
    if (_useLocalStorage) {
      // Return a mock parsed bill
      return BillEntity(
        id: 'bill_${DateTime.now().millisecondsSinceEpoch}',
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
    final List<BillEntity> bills;
    if (_useLocalStorage) {
      bills = await localDataSource.getBills(type: 'individual');
    } else {
      bills = await remoteDataSource.getBills(type: 'individual');
    }

    if (searchQuery != null && searchQuery.isNotEmpty) {
      return bills
          .where(
            (b) => b.name.toLowerCase().contains(searchQuery.toLowerCase()),
          )
          .toList();
    }
    return bills;
  }

  @override
  Future<List<GroupBillEntity>> getGroupBills({String? searchQuery}) async {
    final List<BillEntity> bills;
    if (_useLocalStorage) {
      bills = await localDataSource.getBills(type: 'group');
    } else {
      bills = await remoteDataSource.getBills(type: 'group');
    }

    List<BillEntity> filtered = bills;
    if (searchQuery != null && searchQuery.isNotEmpty) {
      filtered = bills
          .where(
            (b) => b.name.toLowerCase().contains(searchQuery.toLowerCase()),
          )
          .toList();
    }

    return filtered.map<GroupBillEntity>((b) {
      if (b is GroupBillEntity) return b;
      return GroupBillEntity(
        id: b.id,
        name: b.name,
        amount: b.amount,
        dueDate: b.dueDate,
        status: b.status,
        createdAt: b.createdAt,
        updatedAt: b.updatedAt,
      );
    }).toList();
  }
}
