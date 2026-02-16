import 'package:equatable/equatable.dart';

import '../../domain/entities/bill.dart';
import '../../domain/entities/bill_status.dart';
import '../../domain/entities/participant.dart';

/// Tab type for bills screen
enum BillTabType { individual, group }

/// Base state class for Bill feature
abstract class BillState extends Equatable {
  const BillState();

  @override
  List<Object?> get props => [];
}

/// Initial state when the screen is first loaded
class BillInitial extends BillState {
  const BillInitial();
}

/// Loading state while fetching data
class BillLoading extends BillState {
  const BillLoading();
}

/// State when bills are successfully loaded
class BillLoaded extends BillState {
  final List<BillEntity> individualBills;
  final List<GroupBillEntity> groupBills;
  final BillTabType selectedTab;
  final String searchQuery;

  const BillLoaded({
    required this.individualBills,
    required this.groupBills,
    this.selectedTab = BillTabType.individual,
    this.searchQuery = '',
  });

  /// Get current bills based on selected tab
  List<BillEntity> get currentBills {
    return selectedTab == BillTabType.individual 
        ? individualBills 
        : groupBills;
  }

  /// Filter bills based on search query
  List<BillEntity> get filteredBills {
    final bills = currentBills;
    if (searchQuery.isEmpty) return bills;
    
    return bills.where((bill) {
      return bill.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          (bill.invoiceNumber?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false);
    }).toList();
  }

  BillLoaded copyWith({
    List<BillEntity>? individualBills,
    List<GroupBillEntity>? groupBills,
    BillTabType? selectedTab,
    String? searchQuery,
  }) {
    return BillLoaded(
      individualBills: individualBills ?? this.individualBills,
      groupBills: groupBills ?? this.groupBills,
      selectedTab: selectedTab ?? this.selectedTab,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [
    individualBills,
    groupBills,
    selectedTab,
    searchQuery,
  ];
}

/// Error state when something goes wrong
class BillError extends BillState {
  final String message;

  const BillError(this.message);

  @override
  List<Object?> get props => [message];
}

/// State for Add Individual Bill screen
class AddIndividualBillState extends Equatable {
  final String name;
  final double amount;
  final BillStatus status;
  final DateTime dueDate;
  final ReminderFrequency reminderFrequency;
  final bool reminderEnabled;
  final bool isLoading;
  final String? error;

  const AddIndividualBillState({
    this.name = '',
    this.amount = 0.0,
    this.status = BillStatus.paid,
    required this.dueDate,
    this.reminderFrequency = ReminderFrequency.monthly,
    this.reminderEnabled = true,
    this.isLoading = false,
    this.error,
  });

  bool get isValid => name.isNotEmpty && amount > 0;

  AddIndividualBillState copyWith({
    String? name,
    double? amount,
    BillStatus? status,
    DateTime? dueDate,
    ReminderFrequency? reminderFrequency,
    bool? reminderEnabled,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return AddIndividualBillState(
      name: name ?? this.name,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      dueDate: dueDate ?? this.dueDate,
      reminderFrequency: reminderFrequency ?? this.reminderFrequency,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [
    name,
    amount,
    status,
    dueDate,
    reminderFrequency,
    reminderEnabled,
    isLoading,
    error,
  ];
}

/// State for Add Group Bill screen
class AddGroupBillState extends Equatable {
  final String name;
  final double amount;
  final DateTime dueDate;
  final BillStatus status;
  final List<ParticipantEntity> participants;
  final SplitMethod splitMethod;
  final bool reminderEnabled;
  final bool isLoading;
  final String? error;
  final bool isAddingParticipant;
  final String newParticipantName;

  const AddGroupBillState({
    this.name = '',
    this.amount = 0.0,
    required this.dueDate,
    this.status = BillStatus.unpaid,
    this.participants = const [],
    this.splitMethod = SplitMethod.equal,
    this.reminderEnabled = true,
    this.isLoading = false,
    this.error,
    this.isAddingParticipant = false,
    this.newParticipantName = '',
  });

  bool get isValid {
    if (name.isEmpty || amount <= 0 || participants.isEmpty) return false;
    
    // Validate based on split method
    switch (splitMethod) {
      case SplitMethod.equal:
        return true;
      case SplitMethod.percentage:
        return totalPercentage == 100.0;
      case SplitMethod.custom:
        return (totalEntered - amount).abs() < 0.01;
    }
  }

  /// Calculate user's share based on split method
  double get userShare {
    if (participants.isEmpty || amount <= 0) return 0.0;
    
    final currentUser = participants.firstWhere(
      (p) => p.isCurrentUser,
      orElse: () => participants.first,
    );
    
    switch (splitMethod) {
      case SplitMethod.equal:
        return amount / participants.length;
      case SplitMethod.percentage:
        return (currentUser.sharePercentage / 100) * amount;
      case SplitMethod.custom:
        return currentUser.itemsSubtotal;
    }
  }

  /// Get number of participants
  int get participantCount => participants.length;

  /// Total percentage (for percentage split validation)
  double get totalPercentage {
    double total = 0.0;
    for (final p in participants) {
      total += p.sharePercentage;
    }
    return total;
  }

  /// Total entered amount (for custom split)
  double get totalEntered {
    double total = 0.0;
    for (final p in participants) {
      total += p.itemsSubtotal;
    }
    return total;
  }

  /// Difference from total (for custom split validation)
  double get amountDifference => amount - totalEntered;

  /// Check if percentage is valid
  bool get isPercentageValid => totalPercentage == 100.0;

  /// Check if custom split is valid
  bool get isCustomSplitValid => (totalEntered - amount).abs() < 0.01;

  AddGroupBillState copyWith({
    String? name,
    double? amount,
    DateTime? dueDate,
    BillStatus? status,
    List<ParticipantEntity>? participants,
    SplitMethod? splitMethod,
    bool? reminderEnabled,
    bool? isLoading,
    String? error,
    bool clearError = false,
    bool? isAddingParticipant,
    String? newParticipantName,
  }) {
    return AddGroupBillState(
      name: name ?? this.name,
      amount: amount ?? this.amount,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      participants: participants ?? this.participants,
      splitMethod: splitMethod ?? this.splitMethod,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      isLoading: isLoading ?? this.isLoading,
      isAddingParticipant: isAddingParticipant ?? this.isAddingParticipant,
      newParticipantName: newParticipantName ?? this.newParticipantName,
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [
    name,
    amount,
    dueDate,
    status,
    participants,
    splitMethod,
    reminderEnabled,
    isLoading,
    error,
  ];
}

