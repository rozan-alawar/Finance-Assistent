import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/bill.dart';
import '../../domain/entities/bill_status.dart';
import '../../domain/entities/participant.dart';
import '../../domain/repositories/bill_repository.dart';
import 'bill_state.dart';

class BillCubit extends Cubit<BillState> {
  final BillRepository repository;

  BillCubit({required this.repository}) : super(const BillInitial());

  /// Load all bills
  Future<void> loadBills() async {
    emit(const BillLoading());

    try {
      // Fetch individual and group bills in parallel
      final individualBillsFuture = repository.getIndividualBills();
      final groupBillsFuture = repository.getGroupBills();

      final individualBills = await individualBillsFuture;
      final groupBills = await groupBillsFuture;

      emit(BillLoaded(
        individualBills: individualBills,
        groupBills: groupBills,
      ));
    } catch (e) {
      emit(BillError(e.toString()));
    }
  }

  /// Change tab (Individual/Group)
  void changeTab(BillTabType tab) {
    final currentState = state;
    if (currentState is BillLoaded) {
      emit(currentState.copyWith(selectedTab: tab));
    }
  }

  /// Search bills
  void searchBills(String query) {
    final currentState = state;
    if (currentState is BillLoaded) {
      emit(currentState.copyWith(searchQuery: query));
    }
  }

  /// Delete a bill
  Future<void> deleteBill(String id) async {
    try {
      await repository.deleteBill(id);
      await loadBills();
    } catch (e) {
      emit(BillError(e.toString()));
    }
  }

  /// Update bill status
  Future<void> updateBillStatus(String id, BillStatus status) async {
    try {
      await repository.updateBillStatus(id, status);
      await loadBills();
    } catch (e) {
      emit(BillError(e.toString()));
    }
  }
}

/// Cubit for Add Individual Bill screen
class AddIndividualBillCubit extends Cubit<AddIndividualBillState> {
  final BillRepository repository;

  AddIndividualBillCubit({required this.repository})
      : super(AddIndividualBillState(dueDate: DateTime.now()));

  void updateName(String name) {
    emit(state.copyWith(name: name, clearError: true));
  }

  void updateAmount(double amount) {
    emit(state.copyWith(amount: amount, clearError: true));
  }

  void updateStatus(BillStatus status) {
    emit(state.copyWith(status: status));
  }

  void updateDueDate(DateTime date) {
    emit(state.copyWith(dueDate: date));
  }

  void updateReminderFrequency(ReminderFrequency frequency) {
    emit(state.copyWith(reminderFrequency: frequency));
  }

  void toggleReminder(bool enabled) {
    emit(state.copyWith(reminderEnabled: enabled));
  }

  Future<bool> saveBill() async {
    if (!state.isValid) {
      emit(state.copyWith(error: 'Please fill all required fields'));
      return false;
    }

    emit(state.copyWith(isLoading: true));

    try {
      final bill = BillEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: state.name,
        amount: state.amount,
        dueDate: state.dueDate,
        status: state.status,
        isGroupBill: false,
        reminderEnabled: state.reminderEnabled,
        reminderFrequency: state.reminderFrequency,
      );

      await repository.createBill(bill);
      emit(state.copyWith(isLoading: false));
      return true;
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
      return false;
    }
  }

  void reset() {
    emit(AddIndividualBillState(dueDate: DateTime.now()));
  }
}

/// Cubit for Add Group Bill screen
class AddGroupBillCubit extends Cubit<AddGroupBillState> {
  final BillRepository repository;

  AddGroupBillCubit({required this.repository})
      : super(AddGroupBillState(
          dueDate: DateTime.now(),
          participants: [
            ParticipantEntity(
              id: 'current_user',
              name: 'Ahmed Cirve',
              isCurrentUser: true,
              avatarColor: ParticipantColors.getColor(0),
            ),
          ],
        ));

  void updateName(String name) {
    emit(state.copyWith(name: name, clearError: true));
  }

  void updateAmount(double amount) {
    emit(state.copyWith(amount: amount, clearError: true));
    _recalculateShares();
  }

  void updateDueDate(DateTime date) {
    emit(state.copyWith(dueDate: date));
  }

  void updateStatus(BillStatus status) {
    emit(state.copyWith(status: status));
  }

  void updateSplitMethod(SplitMethod method) {
    emit(state.copyWith(splitMethod: method));
    _recalculateShares();
  }

  void toggleReminder(bool enabled) {
    emit(state.copyWith(reminderEnabled: enabled));
  }

  // Participant input methods
  void startAddingParticipant() {
    emit(state.copyWith(isAddingParticipant: true, newParticipantName: ''));
  }

  void updateNewParticipantName(String name) {
    emit(state.copyWith(newParticipantName: name));
  }

  void cancelAddingParticipant() {
    emit(state.copyWith(isAddingParticipant: false, newParticipantName: ''));
  }

  void confirmAddParticipant() {
    if (state.newParticipantName.trim().isEmpty) return;
    
    final colorIndex = state.participants.length;
    final participant = ParticipantEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: state.newParticipantName.trim(),
      avatarColor: ParticipantColors.getColor(colorIndex),
    );
    
    final updatedParticipants = [...state.participants, participant];
    emit(state.copyWith(
      participants: updatedParticipants,
      isAddingParticipant: false,
      newParticipantName: '',
    ));
    _recalculateShares();
  }

  void removeParticipant(String participantId) {
    final updatedParticipants = state.participants
        .where((p) => p.id != participantId)
        .toList();
    emit(state.copyWith(participants: updatedParticipants));
    _recalculateShares();
  }

  void setAsCurrentUser(String participantId) {
    final updatedParticipants = state.participants.map((p) {
      if (p.id == participantId) {
        return p.copyWith(isCurrentUser: true);
      }
      return p.copyWith(isCurrentUser: false);
    }).toList();
    emit(state.copyWith(participants: updatedParticipants));
  }

  // Percentage split methods
  void updateParticipantPercentage(String participantId, double percentage) {
    final updatedParticipants = state.participants.map((p) {
      if (p.id == participantId) {
        final shareAmount = (percentage / 100) * state.amount;
        return p.copyWith(
          sharePercentage: percentage,
          shareAmount: shareAmount,
        );
      }
      return p;
    }).toList();
    emit(state.copyWith(participants: updatedParticipants));
  }

  // Custom split methods
  void toggleParticipantExpanded(String participantId) {
    final updatedParticipants = state.participants.map((p) {
      if (p.id == participantId) {
        return p.copyWith(isExpanded: !p.isExpanded);
      }
      return p;
    }).toList();
    emit(state.copyWith(participants: updatedParticipants));
  }

  void addItemToParticipant(String participantId) {
    final updatedParticipants = state.participants.map((p) {
      if (p.id == participantId) {
        final newItem = SplitItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
        );
        return p.copyWith(items: [...p.items, newItem]);
      }
      return p;
    }).toList();
    emit(state.copyWith(participants: updatedParticipants));
  }

  void updateItemName(String participantId, String itemId, String name) {
    final updatedParticipants = state.participants.map((p) {
      if (p.id == participantId) {
        final updatedItems = p.items.map((item) {
          if (item.id == itemId) {
            return item.copyWith(name: name);
          }
          return item;
        }).toList();
        return p.copyWith(items: updatedItems);
      }
      return p;
    }).toList();
    emit(state.copyWith(participants: updatedParticipants));
  }

  void updateItemAmount(String participantId, String itemId, double amount) {
    final updatedParticipants = state.participants.map((p) {
      if (p.id == participantId) {
        final updatedItems = p.items.map((item) {
          if (item.id == itemId) {
            return item.copyWith(amount: amount);
          }
          return item;
        }).toList();
        return p.copyWith(items: updatedItems);
      }
      return p;
    }).toList();
    emit(state.copyWith(participants: updatedParticipants));
  }

  void removeItem(String participantId, String itemId) {
    final updatedParticipants = state.participants.map((p) {
      if (p.id == participantId) {
        final updatedItems = p.items.where((item) => item.id != itemId).toList();
        return p.copyWith(items: updatedItems);
      }
      return p;
    }).toList();
    emit(state.copyWith(participants: updatedParticipants));
  }

  void _recalculateShares() {
    if (state.participants.isEmpty || state.amount <= 0) return;

    if (state.splitMethod == SplitMethod.equal) {
      final shareAmount = state.amount / state.participants.length;
      final sharePercentage = 100.0 / state.participants.length;
      final updatedParticipants = state.participants.map((p) {
        return p.copyWith(
          shareAmount: shareAmount,
          sharePercentage: sharePercentage,
        );
      }).toList();
      emit(state.copyWith(participants: updatedParticipants));
    }
    // For percentage and custom, shares are updated manually
  }

  Future<bool> saveBill() async {
    if (!state.isValid) {
      String errorMessage = 'Please fill all required fields';
      if (state.splitMethod == SplitMethod.percentage && !state.isPercentageValid) {
        errorMessage = 'Total percentage must equal 100%';
      } else if (state.splitMethod == SplitMethod.custom && !state.isCustomSplitValid) {
        errorMessage = 'Total items must equal the bill amount';
      }
      emit(state.copyWith(error: errorMessage));
      return false;
    }

    emit(state.copyWith(isLoading: true));

    try {
      final bill = GroupBillEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: state.name,
        amount: state.amount,
        dueDate: state.dueDate,
        status: state.status,
        participants: state.participants,
        splitMethod: state.splitMethod,
        reminderEnabled: state.reminderEnabled,
        userShare: state.userShare,
      );

      await repository.createBill(bill);
      emit(state.copyWith(isLoading: false));
      return true;
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
      return false;
    }
  }

  void reset() {
    emit(AddGroupBillState(
      dueDate: DateTime.now(),
      participants: [
        ParticipantEntity(
          id: 'current_user',
          name: 'Ahmed Cirve',
          isCurrentUser: true,
          avatarColor: ParticipantColors.getColor(0),
        ),
      ],
    ));
  }
}

