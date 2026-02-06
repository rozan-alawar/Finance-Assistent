import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
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
                  const AppTextField(
                    textFieldType: TextFieldType.other,
                    keyboardType: TextInputType.number,
                    hint: "0.00",
                    prefixIcon: Icon(Icons.attach_money, color: Colors.grey, size: 16),
                  ),
                  SizedBox(height: Sizes.marginV16),
                  Text("Due date", style: TextStyles.f14(context).medium),
                  SizedBox(height: Sizes.marginV8),
                  AppTextField(
                    textFieldType: TextFieldType.other,
                    hint: "mm//dd//yyyy",
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Image.asset("images/date.png", width: 16, height: 16),
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
                  const AppTextField(
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
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "Save Debt",
              style: TextStyles.f14(context).medium.colorWith(Colors.white),
            ),
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