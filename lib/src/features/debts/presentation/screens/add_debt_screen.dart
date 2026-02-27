import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:finance_assistent/src/features/debts/data/model/debt_model.dart';
import 'package:finance_assistent/src/features/debts/presentation/cubit/debt_cubit.dart';
import '../../../../core/utils/const/sizes.dart';
import '../../../../core/utils/extensions/widget_ex.dart';
import '../../../../core/utils/extensions/text_ex.dart';
import '../../../../core/config/theme/styles/styles.dart';
import '../../../../core/view/component/base/button.dart';
import '../../../../core/view/component/base/custom_app_bar.dart';
import '../../../../core/view/component/base/app_text_field.dart';


class AddDebtScreen extends StatefulWidget {
  const AddDebtScreen({super.key});

  @override
  State<AddDebtScreen> createState() => _AddDebtScreenState();
}

class _AddDebtScreenState extends State<AddDebtScreen> {
  bool isReminderEnabled = true;
  bool isSaving = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    amountController.dispose();
    dateController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Add Debts",
        showBackButton: true,
        onBackButtonPressed: () => Navigator.of(context).pop(),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: Sizes.screenPaddingH16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Sizes.marginV20),
                  Text("Personal Name", style: TextStyles.f14(context).medium),
                  SizedBox(height: Sizes.marginV8),
                  AppTextField(
                    controller: nameController,
                    textFieldType: TextFieldType.name,
                    hint: "Personal Name",
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SvgPicture.asset("assets/icons/user.svg", width: 16, height: 16),
                    ),
                  ),
                  SizedBox(height: Sizes.marginV16),
                  Text("Amount", style: TextStyles.f14(context).medium),
                  SizedBox(height: Sizes.marginV8),
                  AppTextField(
                    controller: amountController,
                    textFieldType: TextFieldType.other,
                    keyboardType: TextInputType.number,
                    hint: "0.00",
                    prefixIcon: const Icon(Icons.attach_money, color: Colors.grey, size: 16),
                  ),
                  SizedBox(height: Sizes.marginV16),
                  Text("Due date", style: TextStyles.f14(context).medium),
                  SizedBox(height: Sizes.marginV8),
                  AppTextField(
                    controller: dateController,
                    textFieldType: TextFieldType.other,
                    hint: "yyyy-mm-dd",
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Image.asset("assets/images/date.png", width: 16, height: 16),
                    ),
                  ),
                  SizedBox(height: Sizes.marginV16),
                  Row(
                    children: [
                      Text("Description ", style: TextStyles.f14(context).medium),
                      Text("(Optional)", style: TextStyles.f14(context).normal.colorWith(Colors.grey.shade400)),
                    ],
                  ),
                  SizedBox(height: Sizes.marginV8),
                  AppTextField(
                    controller: descController,
                    textFieldType: TextFieldType.other,
                    hint: "Add short note about this debt...",
                    maxLines: 4,
                  ),
                  SizedBox(height: Sizes.marginV20),
                  _buildReminderCard(context),
                  SizedBox(height: Sizes.marginV20),
                ],
              ),
            ),
          ),
          AppButton(
            type: AppButtonType.primary,
            onPressed: isSaving ? null : () async {
              setState(() => isSaving = true);
              final debt = DebtModel(
                id: "",
                name: nameController.text,
                amount: amountController.text,
                date: dateController.text,
                status: "UNPAID",
                description: descController.text,
              );

              final success = await context.read<DebtCubit>().addDebt(debt);

              if (mounted) {
                setState(() => isSaving = false);
                if (success) {
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Error: Check fields or Token")),
                  );
                }
              }
            },
            child: isSaving 
              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : Text("Save Debt", style: TextStyles.f14(context).medium.colorWith(Colors.white)),
          ).paddingAll(Sizes.screenPaddingH16),
        ],
      ),
    );
  }

  Widget _buildReminderCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFDECEE),
        borderRadius: BorderRadius.circular(Sizes.radius12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isReminderEnabled ? Icons.notifications_active : Icons.notifications_none,
              color: const Color(0xFF3F51B5),
              size: 24,
            ),
          ),
          SizedBox(width: Sizes.paddingH12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Reminder", style: TextStyles.f16(context).medium),
                Text(
                  "Get notified before due date",
                  style: TextStyles.f14(context).normal.colorWith(Colors.grey),
                ),
              ],
            ),
          ),
          Switch(
            value: isReminderEnabled,
            activeColor: Colors.white,
            activeTrackColor: const Color(0xFF3F51B5),
            onChanged: (value) {
              setState(() {
                isReminderEnabled = value;
              });
            },
          ),
        ],
      ),
    );
  }
}