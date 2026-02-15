import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../core/config/theme/app_color/color_palette.dart';
import '../../../../../core/config/theme/styles/styles.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/view/component/base/custom_app_bar.dart';
import '../../data/data_sources/bill_local_data_source.dart';
import '../../data/data_sources/bill_remote_data_source.dart';
import '../../data/repositories/bill_repository_impl.dart';
import '../../domain/entities/bill_status.dart';
import '../bloc/bill_cubit.dart';
import '../bloc/bill_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddIndividualBillScreen extends StatelessWidget {
  final BillCubit billCubit;

  const AddIndividualBillScreen({super.key, required this.billCubit});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
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
          create: (_) => AddIndividualBillCubit(repository: repository),
          child: _AddIndividualBillContent(billCubit: billCubit),
        );
      },
    );
  }
}

class _AddIndividualBillContent extends StatefulWidget {
  final BillCubit billCubit;

  const _AddIndividualBillContent({required this.billCubit});

  @override
  State<_AddIndividualBillContent> createState() =>
      _AddIndividualBillContentState();
}

class _AddIndividualBillContentState extends State<_AddIndividualBillContent> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.white,
      appBar: const CustomAppBar(
        title: 'Add Individual Bill',
        showBackButton: true,
      ),
      body: BlocConsumer<AddIndividualBillCubit, AddIndividualBillState>(
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error!)));
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
                      context.read<AddIndividualBillCubit>().updateName(value),
                ),
                const SizedBox(height: 20),

                // Amount
                _buildLabel(context, 'Amount'),
                const SizedBox(height: 8),
                _buildTextField(
                  context: context,
                  controller: _amountController,
                  hintText: '0.00',
                  prefixIcon: null,
                  prefixText: '\$ ',
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final amount = double.tryParse(value) ?? 0.0;
                    context.read<AddIndividualBillCubit>().updateAmount(amount);
                  },
                ),
                const SizedBox(height: 20),

                // Payment Status
                _buildLabel(context, 'Payment Status'),
                const SizedBox(height: 12),
                _buildPaymentStatusSelector(context, state),
                const SizedBox(height: 20),

                // Due Date
                _buildLabel(context, 'Due date'),
                const SizedBox(height: 8),
                _buildDatePicker(context, state),
                const SizedBox(height: 20),

                // Reminder Frequency
                _buildLabel(context, 'Reminder frequency'),
                const SizedBox(height: 12),
                _buildReminderFrequencySelector(context, state),
                const SizedBox(height: 20),

                // Reminder Toggle
                _buildReminderToggle(context, state),
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
      style: TextStyles.f14(
        context,
      ).copyWith(color: const Color(0xFF2D3142), fontWeight: FontWeight.w500),
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
          hintStyle: TextStyles.f14(
            context,
          ).copyWith(color: ColorPalette.gray50),
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, color: ColorPalette.gray50, size: 20)
              : null,
          prefixText: prefixText,
          prefixStyle: TextStyles.f14(
            context,
          ).copyWith(color: ColorPalette.gray50),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentStatusSelector(
    BuildContext context,
    AddIndividualBillState state,
  ) {
    return Row(
      children: [
        _StatusRadio(
          label: 'Paid',
          isSelected: state.status == BillStatus.paid,
          onTap: () => context.read<AddIndividualBillCubit>().updateStatus(
            BillStatus.paid,
          ),
        ),
        const SizedBox(width: 32),
        _StatusRadio(
          label: 'Unpaid',
          isSelected: state.status == BillStatus.unpaid,
          onTap: () => context.read<AddIndividualBillCubit>().updateStatus(
            BillStatus.unpaid,
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker(BuildContext context, AddIndividualBillState state) {
    return GestureDetector(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: state.dueDate,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
        );
        if (date != null && context.mounted) {
          context.read<AddIndividualBillCubit>().updateDueDate(date);
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

  Widget _buildReminderFrequencySelector(
    BuildContext context,
    AddIndividualBillState state,
  ) {
    return Wrap(
      spacing: 16,
      runSpacing: 12,
      children: ReminderFrequency.values.map((frequency) {
        return _FrequencyRadio(
          label: frequency.name,
          isSelected: state.reminderFrequency == frequency,
          onTap: () => context
              .read<AddIndividualBillCubit>()
              .updateReminderFrequency(frequency),
        );
      }).toList(),
    );
  }

  Widget _buildReminderToggle(
    BuildContext context,
    AddIndividualBillState state,
  ) {
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
                  style: TextStyles.f14(
                    context,
                  ).copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  'Get notified before due date',
                  style: TextStyles.f12(
                    context,
                  ).copyWith(color: ColorPalette.gray50),
                ),
              ],
            ),
          ),
          Switch(
            value: state.reminderEnabled,
            onChanged: (value) =>
                context.read<AddIndividualBillCubit>().toggleReminder(value),
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
        child: BlocBuilder<AddIndividualBillCubit, AddIndividualBillState>(
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
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
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
    final cubit = context.read<AddIndividualBillCubit>();
    final success = await cubit.saveBill();

    if (success && context.mounted) {
      widget.billCubit.loadBills();
      Navigator.of(context).pop();
    }
  }
}

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

class _FrequencyRadio extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FrequencyRadio({
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
            width: 20,
            height: 20,
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
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ColorPalette.primary,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyles.f12(context).copyWith(
              color: isSelected ? ColorPalette.primary : ColorPalette.gray50,
            ),
          ),
        ],
      ),
    );
  }
}
