import '../entities/bill.dart';
import '../entities/bill_status.dart';

/// Abstract repository interface for bill operations
abstract class BillRepository {
  /// Get all bills (both individual and group)
  Future<List<BillEntity>> getBills({
    bool? isGroupBill,
    String? searchQuery,
  });

  /// Get bill by ID
  Future<BillEntity> getBillById(String id);

  /// Create a new bill
  Future<BillEntity> createBill(BillEntity bill);

  /// Update an existing bill
  Future<BillEntity> updateBill(BillEntity bill);

  /// Delete a bill
  Future<void> deleteBill(String id);

  /// Update bill payment status
  Future<BillEntity> updateBillStatus(String id, BillStatus status);

  /// Smart parse bill using AI
  Future<BillEntity> smartParseBill(String imageData);

  /// Get individual bills only
  Future<List<BillEntity>> getIndividualBills({String? searchQuery});

  /// Get group bills only
  Future<List<GroupBillEntity>> getGroupBills({String? searchQuery});
}

