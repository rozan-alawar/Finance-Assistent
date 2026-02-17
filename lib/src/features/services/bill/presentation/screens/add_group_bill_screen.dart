import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../core/config/theme/app_color/color_palette.dart';
import '../../../../../core/config/theme/styles/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/network/api_client.dart';
import '../../../../../core/view/component/base/custom_app_bar.dart';
import '../../../../../core/view/component/base/indicator.dart';
import '../../data/data_sources/bill_local_data_source.dart';
import '../../data/data_sources/bill_remote_data_source.dart';
import '../../data/repositories/bill_repository_impl.dart';
import '../../domain/entities/bill_status.dart';
import '../../domain/entities/participant.dart';
import '../bloc/bill_cubit.dart';
import '../bloc/bill_state.dart';

class AddGroupBillScreen extends StatelessWidget {
  final BillCubit billCubit;

  const AddGroupBillScreen({
    super.key,
    required this.billCubit,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: LoadingAppIndicator()),
          );
        }

        final remoteDataSource = BillRemoteDataSourceImpl(dio: ApiClient.dio);
        final localDataSource = BillLocalDataSourceImpl(
          sharedPreferences: snapshot.data!,
        );
        final repository = BillRepositoryImpl(
          remoteDataSource: remoteDataSource,
          localDataSource: localDataSource,
        );

        return BlocProvider(
          create: (_) => AddGroupBillCubit(repository: repository),
          child: _AddGroupBillContent(billCubit: billCubit),
        );
      },
    );
  }
}

class _AddGroupBillContent extends StatefulWidget {
  final BillCubit billCubit;

  const _AddGroupBillContent({required this.billCubit});

  @override
  State<_AddGroupBillContent> createState() => _AddGroupBillContentState();
}

class _AddGroupBillContentState extends State<_AddGroupBillContent> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _participantNameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _participantNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.white,
      appBar: const CustomAppBar(
        title: 'Add Group Bill',
        showBackButton: true,
      ),
      body: BlocConsumer<AddGroupBillCubit, AddGroupBillState>(
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error!)),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bill Name
                _buildLabel(context, 'Bill Name'),
                const SizedBox(height: 8),
                _buildTextField(
                  context: context,
                  controller: _nameController,
                  hintText: 'Bill Name',
                  prefixIcon: Icons.person_outline,
                  onChanged: (value) =>
                      context.read<AddGroupBillCubit>().updateName(value),
                ),
                const SizedBox(height: 20),

                // Amount
                _buildLabel(context, 'Amount'),
                const SizedBox(height: 8),
                _buildTextField(
                  context: context,
                  controller: _amountController,
                  hintText: '0.00',
                  prefixText: '\$ ',
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final amount = double.tryParse(value) ?? 0.0;
                    context.read<AddGroupBillCubit>().updateAmount(amount);
                  },
                ),
                const SizedBox(height: 20),

                // Due Date
                _buildLabel(context, 'Due date'),
                const SizedBox(height: 8),
                _buildDatePicker(context, state),
                const SizedBox(height: 20),

                // Payment Status
                _buildLabel(context, 'Payment Status'),
                const SizedBox(height: 12),
                _buildPaymentStatusSelector(context, state),
                const SizedBox(height: 20),

                // Participants Section
                _buildParticipantsSection(context, state),
                const SizedBox(height: 20),

                // Split Method
                _buildSplitMethodSection(context, state),
                const SizedBox(height: 20),

                // Amount Summary
                _buildAmountSummary(context, state),
                const SizedBox(height: 20),

                // Reminder Toggle
                _buildReminderToggle(context, state),
                const SizedBox(height: 100),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: _buildSaveButton(context),
    );
  }

  Widget _buildLabel(BuildContext context, String label) {
    return Text(
      label,
      style: TextStyles.f14(context).copyWith(
        color: const Color(0xFF2D3142),
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildTextField({
    required BuildContext context,
    required TextEditingController controller,
    required String hintText,
    IconData? prefixIcon,
    String? prefixText,
    TextInputType? keyboardType,
    ValueChanged<String>? onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: ColorPalette.coldGray10.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorPalette.coldGray20),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        onChanged: onChanged,
        style: TextStyles.f14(context),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyles.f14(context).copyWith(
            color: ColorPalette.gray50,
          ),
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, color: ColorPalette.gray50, size: 20)
              : null,
          prefixText: prefixText,
          prefixStyle: TextStyles.f14(context).copyWith(
            color: ColorPalette.gray50,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context, AddGroupBillState state) {
    return GestureDetector(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: state.dueDate,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
        );
        if (date != null && context.mounted) {
          context.read<AddGroupBillCubit>().updateDueDate(date);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: ColorPalette.coldGray10.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ColorPalette.coldGray20),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              color: ColorPalette.gray50,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              DateFormat('dd MMM yyyy').format(state.dueDate),
              style: TextStyles.f14(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentStatusSelector(
    BuildContext context,
    AddGroupBillState state,
  ) {
    return Row(
      children: [
        _StatusRadio(
          label: 'Paid',
          isSelected: state.status == BillStatus.paid,
          onTap: () =>
              context.read<AddGroupBillCubit>().updateStatus(BillStatus.paid),
        ),
        const SizedBox(width: 32),
        _StatusRadio(
          label: 'Unpaid',
          isSelected: state.status == BillStatus.unpaid,
          onTap: () =>
              context.read<AddGroupBillCubit>().updateStatus(BillStatus.unpaid),
        ),
      ],
    );
  }

  Widget _buildParticipantsSection(
    BuildContext context,
    AddGroupBillState state,
  ) {
    final cubit = context.read<AddGroupBillCubit>();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorPalette.coldGray10.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorPalette.coldGray20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Participants',
                style: TextStyles.f14(context).copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${state.participantCount} added',
                style: TextStyles.f12(context).copyWith(
                  color: ColorPalette.gray50,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Participants List
          ...state.participants.map((participant) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _ParticipantTile(
                participant: participant,
                showSetAsYou: state.splitMethod == SplitMethod.custom &&
                    !participant.isCurrentUser,
                onRemove: participant.isCurrentUser
                    ? null
                    : () => cubit.removeParticipant(participant.id),
                onSetAsYou: () => cubit.setAsCurrentUser(participant.id),
              ),
            );
          }),

          // Add Participant Input
          if (state.isAddingParticipant) ...[
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: ColorPalette.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: ColorPalette.coldGray20),
              ),
              child: TextField(
                controller: _participantNameController,
                autofocus: true,
                style: TextStyles.f14(context),
                decoration: InputDecoration(
                  hintText: 'Participant Name',
                  hintStyle: TextStyles.f14(context).copyWith(
                    color: ColorPalette.gray50,
                  ),
                  prefixIcon: Icon(
                    Icons.person_outline,
                    color: ColorPalette.gray50,
                    size: 20,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                onChanged: (value) => cubit.updateNewParticipantName(value),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      cubit.confirmAddParticipant();
                      _participantNameController.clear();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorPalette.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Done',
                      style: TextStyles.f14(context).copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      cubit.cancelAddingParticipant();
                      _participantNameController.clear();
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: ColorPalette.primary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      side: BorderSide(color: ColorPalette.primary),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyles.f14(context).copyWith(
                        color: ColorPalette.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[
            // Add Participant Button
            GestureDetector(
              onTap: () => cubit.startAddingParticipant(),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: ColorPalette.coldGray20,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add,
                      color: ColorPalette.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Add Participant',
                      style: TextStyles.f14(context).copyWith(
                        color: ColorPalette.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSplitMethodSection(
    BuildContext context,
    AddGroupBillState state,
  ) {
    final cubit = context.read<AddGroupBillCubit>();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorPalette.coldGray10.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorPalette.coldGray20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Split Method',
            style: TextStyles.f14(context).copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),

          // Split Method Tabs
          Row(
            children: SplitMethod.values.map((method) {
              final isSelected = state.splitMethod == method;
              return Expanded(
                child: GestureDetector(
                  onTap: () => cubit.updateSplitMethod(method),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? ColorPalette.white
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: isSelected
                          ? Border.all(color: ColorPalette.coldGray20)
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        method.name,
                        style: TextStyles.f12(context).copyWith(
                          color: isSelected
                              ? const Color(0xFF2D3142)
                              : ColorPalette.gray50,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          // Split Details
          if (state.participants.isNotEmpty && state.amount > 0) ...[
            const SizedBox(height: 16),
            _buildSplitDetails(context, state),
          ] else if (state.participants.length <= 1) ...[
            const SizedBox(height: 24),
            _buildEmptySplitState(context),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptySplitState(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Icon(
            Icons.person_outline,
            size: 48,
            color: ColorPalette.gray50.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 12),
          Text(
            'Add Participant to see the split',
            style: TextStyles.f14(context).copyWith(
              color: ColorPalette.gray50,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSplitDetails(BuildContext context, AddGroupBillState state) {
    switch (state.splitMethod) {
      case SplitMethod.equal:
        return _buildEqualSplit(context, state);
      case SplitMethod.percentage:
        return _buildPercentageSplit(context, state);
      case SplitMethod.custom:
        return _buildCustomSplit(context, state);
    }
  }

  Widget _buildEqualSplit(BuildContext context, AddGroupBillState state) {
    final shareAmount = state.amount / state.participants.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Split Details',
          style: TextStyles.f12(context).copyWith(
            color: ColorPalette.gray50,
          ),
        ),
        const SizedBox(height: 12),
        ...state.participants.map((p) => _EqualSplitRow(
              participant: p,
              amount: shareAmount,
            )),
        const SizedBox(height: 12),
        Text(
          'The total amount is split equally between all participants.',
          style: TextStyles.f12(context).copyWith(
            color: ColorPalette.gray50,
          ),
        ),
      ],
    );
  }

  Widget _buildPercentageSplit(BuildContext context, AddGroupBillState state) {
    final cubit = context.read<AddGroupBillCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Split Details',
          style: TextStyles.f12(context).copyWith(
            color: ColorPalette.gray50,
          ),
        ),
        const SizedBox(height: 12),
        ...state.participants.map((p) => _PercentageSplitRow(
              participant: p,
              totalAmount: state.amount,
              onPercentageChanged: (value) =>
                  cubit.updateParticipantPercentage(p.id, value),
            )),

        // Validation message
        if (!state.isPercentageValid) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFEE2E2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Color(0xFFEF4444),
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  'Total percentage must equal 100% (currently ${state.totalPercentage.toStringAsFixed(0)}%)',
                  style: TextStyles.f12(context).copyWith(
                    color: const Color(0xFFEF4444),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCustomSplit(BuildContext context, AddGroupBillState state) {
    final cubit = context.read<AddGroupBillCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Split Details',
          style: TextStyles.f12(context).copyWith(
            color: ColorPalette.gray50,
          ),
        ),
        const SizedBox(height: 12),
        ...state.participants.map((p) => _CustomSplitCard(
              participant: p,
              onToggleExpand: () => cubit.toggleParticipantExpanded(p.id),
              onAddItem: () => cubit.addItemToParticipant(p.id),
              onUpdateItemName: (itemId, name) =>
                  cubit.updateItemName(p.id, itemId, name),
              onUpdateItemAmount: (itemId, amount) =>
                  cubit.updateItemAmount(p.id, itemId, amount),
              onRemoveItem: (itemId) => cubit.removeItem(p.id, itemId),
            )),

        // Total entered
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total entered:',
              style: TextStyles.f12(context).copyWith(
                color: ColorPalette.gray50,
              ),
            ),
            Text(
              '\$${state.totalEntered.toStringAsFixed(2)}',
              style: TextStyles.f14(context).copyWith(
                color: state.isCustomSplitValid
                    ? const Color(0xFF10B981)
                    : ColorPalette.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),

        // Validation message
        if (!state.isCustomSplitValid && state.amount > 0) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFEE2E2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Color(0xFFEF4444),
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  state.amountDifference > 0
                      ? 'Under by \$${state.amountDifference.toStringAsFixed(2)}'
                      : 'Over by \$${(-state.amountDifference).toStringAsFixed(2)}',
                  style: TextStyles.f12(context).copyWith(
                    color: const Color(0xFFEF4444),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAmountSummary(BuildContext context, AddGroupBillState state) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total Amount',
              style: TextStyles.f14(context).copyWith(
                color: const Color(0xFF2D3142),
              ),
            ),
            Text(
              '\$${state.amount.toStringAsFixed(2)}',
              style: TextStyles.f16(context).copyWith(
                color: const Color(0xFF2D3142),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'My Amount',
              style: TextStyles.f14(context).copyWith(
                color: const Color(0xFF2D3142),
              ),
            ),
            Text(
              '\$${state.userShare.toStringAsFixed(2)}',
              style: TextStyles.f16(context).copyWith(
                color: ColorPalette.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReminderToggle(BuildContext context, AddGroupBillState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorPalette.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: ColorPalette.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.notifications_outlined,
              color: ColorPalette.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reminder',
                  style: TextStyles.f14(context).copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Get notified before due date',
                  style: TextStyles.f12(context).copyWith(
                    color: ColorPalette.gray50,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: state.reminderEnabled,
            onChanged: (value) =>
                context.read<AddGroupBillCubit>().toggleReminder(value),
            activeColor: ColorPalette.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorPalette.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: BlocBuilder<AddGroupBillCubit, AddGroupBillState>(
          builder: (context, state) {
            return ElevatedButton(
              onPressed: state.isLoading ? null : () => _saveBill(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorPalette.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: state.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: LoadingAppIndicator(),
                    )
                  : Text(
                      'Save Bill',
                      style: TextStyles.f16(context).copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _saveBill(BuildContext context) async {
    final cubit = context.read<AddGroupBillCubit>();
    final success = await cubit.saveBill();

    if (success && context.mounted) {
      widget.billCubit.loadBills();
      Navigator.of(context).pop();
    }
  }
}

// Helper Widgets

class _StatusRadio extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _StatusRadio({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? ColorPalette.primary : ColorPalette.gray50,
                width: 2,
              ),
            ),
            child: isSelected
                ? Center(
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ColorPalette.primary,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyles.f14(context).copyWith(
              color: isSelected ? ColorPalette.primary : ColorPalette.gray50,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class _ParticipantTile extends StatelessWidget {
  final ParticipantEntity participant;
  final bool showSetAsYou;
  final VoidCallback? onRemove;
  final VoidCallback? onSetAsYou;

  const _ParticipantTile({
    required this.participant,
    this.showSetAsYou = false,
    this.onRemove,
    this.onSetAsYou,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: participant.isCurrentUser
            ? ColorPalette.primary.withValues(alpha: 0.1)
            : ColorPalette.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: participant.isCurrentUser
              ? ColorPalette.primary.withValues(alpha: 0.3)
              : ColorPalette.coldGray20,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: participant.avatarColor.withValues(alpha: 0.2),
            ),
            child: Center(
              child: Text(
                participant.initials,
                style: TextStyles.f12(context).copyWith(
                  fontWeight: FontWeight.w600,
                  color: participant.avatarColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              children: [
                Text(
                  participant.name,
                  style: TextStyles.f14(context).copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (participant.isCurrentUser) ...[
                  const SizedBox(width: 8),
                  Text(
                    '(You)',
                    style: TextStyles.f12(context).copyWith(
                      color: ColorPalette.gray50,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (showSetAsYou)
            GestureDetector(
              onTap: onSetAsYou,
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  'Set as you',
                  style: TextStyles.f12(context).copyWith(
                    color: ColorPalette.gray50,
                  ),
                ),
              ),
            ),
          if (onRemove != null)
            GestureDetector(
              onTap: onRemove,
              child: Icon(
                Icons.close,
                size: 18,
                color: ColorPalette.gray50,
              ),
            ),
        ],
      ),
    );
  }
}

class _EqualSplitRow extends StatelessWidget {
  final ParticipantEntity participant;
  final double amount;

  const _EqualSplitRow({
    required this.participant,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: ColorPalette.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: ColorPalette.coldGray20),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: participant.avatarColor.withValues(alpha: 0.2),
            ),
            child: Center(
              child: Text(
                participant.initials,
                style: TextStyles.f10(context).copyWith(
                  fontWeight: FontWeight.w600,
                  color: participant.avatarColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              children: [
                Text(
                  participant.name,
                  style: TextStyles.f14(context),
                ),
                if (participant.isCurrentUser) ...[
                  const SizedBox(width: 4),
                  Text(
                    '(You)',
                    style: TextStyles.f12(context).copyWith(
                      color: ColorPalette.gray50,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: TextStyles.f14(context).copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _PercentageSplitRow extends StatelessWidget {
  final ParticipantEntity participant;
  final double totalAmount;
  final ValueChanged<double> onPercentageChanged;

  const _PercentageSplitRow({
    required this.participant,
    required this.totalAmount,
    required this.onPercentageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final calculatedAmount = (participant.sharePercentage / 100) * totalAmount;

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: ColorPalette.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: ColorPalette.coldGray20),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: participant.avatarColor.withValues(alpha: 0.2),
            ),
            child: Center(
              child: Text(
                participant.initials,
                style: TextStyles.f10(context).copyWith(
                  fontWeight: FontWeight.w600,
                  color: participant.avatarColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              children: [
                Text(
                  participant.name,
                  style: TextStyles.f14(context),
                ),
                if (participant.isCurrentUser) ...[
                  const SizedBox(width: 4),
                  Text(
                    '(You)',
                    style: TextStyles.f12(context).copyWith(
                      color: ColorPalette.gray50,
                    ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(
            width: 50,
            child: TextField(
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: TextStyles.f14(context),
              decoration: InputDecoration(
                hintText: '0',
                hintStyle: TextStyles.f14(context).copyWith(
                  color: ColorPalette.gray50,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: ColorPalette.coldGray20),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: ColorPalette.coldGray20),
                ),
                isDense: true,
              ),
              controller: TextEditingController(
                text: participant.sharePercentage > 0
                    ? participant.sharePercentage.toStringAsFixed(0)
                    : '',
              ),
              onChanged: (value) {
                final percentage = double.tryParse(value) ?? 0.0;
                onPercentageChanged(percentage);
              },
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '%',
            style: TextStyles.f14(context).copyWith(
              color: ColorPalette.gray50,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '\$${calculatedAmount.toStringAsFixed(2)}',
            style: TextStyles.f14(context).copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomSplitCard extends StatelessWidget {
  final ParticipantEntity participant;
  final VoidCallback onToggleExpand;
  final VoidCallback onAddItem;
  final Function(String itemId, String name) onUpdateItemName;
  final Function(String itemId, double amount) onUpdateItemAmount;
  final Function(String itemId) onRemoveItem;

  const _CustomSplitCard({
    required this.participant,
    required this.onToggleExpand,
    required this.onAddItem,
    required this.onUpdateItemName,
    required this.onUpdateItemAmount,
    required this.onRemoveItem,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: ColorPalette.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: ColorPalette.coldGray20),
      ),
      child: Column(
        children: [
          // Header
          GestureDetector(
            onTap: onToggleExpand,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: participant.avatarColor.withValues(alpha: 0.2),
                    ),
                    child: Center(
                      child: Text(
                        participant.initials,
                        style: TextStyles.f10(context).copyWith(
                          fontWeight: FontWeight.w600,
                          color: participant.avatarColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              participant.name,
                              style: TextStyles.f14(context).copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (participant.isCurrentUser) ...[
                              const SizedBox(width: 4),
                              Text(
                                '(You)',
                                style: TextStyles.f12(context).copyWith(
                                  color: ColorPalette.gray50,
                                ),
                              ),
                            ],
                          ],
                        ),
                        Text(
                          'Subtotal: \$${participant.itemsSubtotal.toStringAsFixed(2)}',
                          style: TextStyles.f12(context).copyWith(
                            color: ColorPalette.gray50,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    participant.isExpanded
                        ? Icons.keyboard_arrow_down
                        : Icons.chevron_right,
                    color: ColorPalette.gray50,
                  ),
                ],
              ),
            ),
          ),

          // Expanded content
          if (participant.isExpanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  ...participant.items.map((item) => _ItemRow(
                        item: item,
                        onNameChanged: (name) =>
                            onUpdateItemName(item.id, name),
                        onAmountChanged: (amount) =>
                            onUpdateItemAmount(item.id, amount),
                        onRemove: () => onRemoveItem(item.id),
                      )),
                  GestureDetector(
                    onTap: onAddItem,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Icon(
                            Icons.add,
                            color: ColorPalette.primary,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Add Item',
                            style: TextStyles.f12(context).copyWith(
                              color: ColorPalette.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ItemRow extends StatelessWidget {
  final SplitItem item;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<double> onAmountChanged;
  final VoidCallback onRemove;

  const _ItemRow({
    required this.item,
    required this.onNameChanged,
    required this.onAmountChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              style: TextStyles.f12(context),
              decoration: InputDecoration(
                hintText: 'Item Name',
                hintStyle: TextStyles.f12(context).copyWith(
                  color: ColorPalette.gray50,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: ColorPalette.coldGray20),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: ColorPalette.coldGray20),
                ),
                isDense: true,
              ),
              controller: TextEditingController(text: item.name),
              onChanged: onNameChanged,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '\$',
            style: TextStyles.f12(context).copyWith(
              color: ColorPalette.gray50,
            ),
          ),
          const SizedBox(width: 4),
          SizedBox(
            width: 60,
            child: TextField(
              keyboardType: TextInputType.number,
              style: TextStyles.f12(context),
              textAlign: TextAlign.end,
              decoration: InputDecoration(
                hintText: '00.00',
                hintStyle: TextStyles.f12(context).copyWith(
                  color: ColorPalette.gray50,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: ColorPalette.coldGray20),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: ColorPalette.coldGray20),
                ),
                isDense: true,
              ),
              controller: TextEditingController(
                text: item.amount > 0 ? item.amount.toStringAsFixed(2) : '',
              ),
              onChanged: (value) {
                final amount = double.tryParse(value) ?? 0.0;
                onAmountChanged(amount);
              },
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onRemove,
            child: Icon(
              Icons.close,
              size: 18,
              color: ColorPalette.gray50,
            ),
          ),
        ],
      ),
    );
  }
}
