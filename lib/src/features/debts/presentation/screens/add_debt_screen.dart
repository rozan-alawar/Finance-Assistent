import 'package:finance_assistent/src/core/config/theme/app_color/extensions_color.dart';
import 'package:finance_assistent/src/core/config/theme/styles/styles.dart';
import 'package:finance_assistent/src/core/gen/app_assets.dart';
import 'package:finance_assistent/src/core/utils/const/sizes.dart';
import 'package:finance_assistent/src/core/utils/extensions/text_ex.dart';
import 'package:finance_assistent/src/core/view/component/base/app_text_field.dart';
import 'package:finance_assistent/src/core/view/component/base/button.dart';
import 'package:finance_assistent/src/core/view/component/base/image.dart';
import 'package:finance_assistent/src/core/view/component/base/safe_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddDebtScreen extends StatefulWidget {
  const AddDebtScreen({super.key});

  @override
  State<AddDebtScreen> createState() => _AddDebtScreenState();
}

class _AddDebtScreenState extends State<AddDebtScreen> {
  late GlobalKey<FormState> formKey;
  late TextEditingController nameCtr;
  late TextEditingController amountCtr;
  late TextEditingController dueDateCtr;
  late ValueNotifier<bool> fieldsIsValidNotifier;

  void verifyValidation() {
    final nameValid = nameCtr.text.trim().isNotEmpty;
    final amountValid = double.tryParse(amountCtr.text.trim()) != null;
    final dateValid = dueDateCtr.text.trim().isNotEmpty;
    fieldsIsValidNotifier.value = nameValid && amountValid && dateValid;
  }

  String formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  Future<void> selectDueDate() async {
    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 10),
    );
    if (selected != null) {
      dueDateCtr.text = formatDate(selected);
      verifyValidation();
    }
  }

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    nameCtr = TextEditingController();
    amountCtr = TextEditingController();
    dueDateCtr = TextEditingController();
    fieldsIsValidNotifier = ValueNotifier<bool>(false);
    nameCtr.addListener(verifyValidation);
    amountCtr.addListener(verifyValidation);
    dueDateCtr.addListener(verifyValidation);
  }

  @override
  void dispose() {
    nameCtr.removeListener(verifyValidation);
    amountCtr.removeListener(verifyValidation);
    dueDateCtr.removeListener(verifyValidation);
    nameCtr.dispose();
    amountCtr.dispose();
    dueDateCtr.dispose();
    fieldsIsValidNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sectionSpace = SizedBox(height: Sizes.marginV16);

    return SafeScaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text("Add Debts"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Personal Info", style: TextStyles.f16(context).bold),
              sectionSpace,
              AppTextField(
                controller: nameCtr,
                label: 'Personal Name',
                textFieldType: TextFieldType.name,
                isRequired: true,
                maxLines: 1,
                prefixIcon: AppAssetsSvg(
                  AppAssets.ASSETS_ICONS_USER_SVG,
                  fit: BoxFit.scaleDown,
                ),
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
              ),
              sectionSpace,
              AppTextField(
                controller: amountCtr,
                label: 'Amount',
                textFieldType: TextFieldType.other,
                isRequired: true,
                maxLines: 1,
                prefixIcon: AppAssetsSvg(
                  AppAssets.ASSETS_ICONS_MONEY_RECIVE_SVG,
                  fit: BoxFit.scaleDown,
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                textInputAction: TextInputAction.next,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
              ),
              sectionSpace,
              AppTextField(
                controller: dueDateCtr,
                label: 'Due date',
                textFieldType: TextFieldType.other,
                isRequired: true,
                maxLines: 1,
                readOnly: true,
                onTap: selectDueDate,
                suffix: Icon(
                  Icons.calendar_month,
                  color: appSwitcherColors(context).neutralColors.shade200,
                ),
              ),
              SizedBox(height: Sizes.marginV24),
              ValueListenableBuilder<bool>(
                valueListenable: fieldsIsValidNotifier,
                builder: (context, fieldsIsValid, child) => AppButton(
                  onPressed: fieldsIsValid ? () => Navigator.of(context).maybePop() : null,
                  type: AppButtonType.primary,
                  disableButton: !fieldsIsValid,
                  child: Text("Save Debt"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
