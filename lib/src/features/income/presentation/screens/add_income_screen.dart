import 'package:finance_assistent/src/features/income/data/model/add_income_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/utils/const/sizes.dart';
import '../../../../core/utils/extensions/widget_ex.dart';
import '../../../../core/utils/extensions/text_ex.dart';
import '../../../../core/config/theme/styles/styles.dart';
import '../../../../core/view/component/base/button.dart';
import '../../../../core/view/component/base/custom_app_bar.dart';
import '../../../../core/view/component/base/app_text_field.dart';

import '../cubit/income_cubit.dart';
import '../cubit/income_state.dart';

class AddIncomeScreen extends StatefulWidget {
  const AddIncomeScreen({super.key});

  @override
  State<AddIncomeScreen> createState() => _AddIncomeScreenState();
}

class _AddIncomeScreenState extends State<AddIncomeScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _sourceController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  String _selectedRecurring = 'On time';
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _amountController.dispose();
    _sourceController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => IncomeCubit(),
      child: Builder(
        builder: (context) {
          return BlocListener<IncomeCubit, IncomeState>(
            listener: (context, state) {
              if (state is AddIncomeSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pop(context);
              } else if (state is IncomeError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Scaffold(
              backgroundColor: const Color(0xFFF8F9FD),
              appBar: CustomAppBar(
                title: "Add Income",
                showBackButton: true,
                onBackButtonPressed: () => Navigator.of(context).pop(),
              ),
              body: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: Sizes.screenPaddingH16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: Sizes.marginV20),
                          Text("Amount", style: TextStyles.f14(context).medium),
                          SizedBox(height: Sizes.marginV8),
                          AppTextField(
                            controller: _amountController,
                            textFieldType: TextFieldType.other,
                            keyboardType: TextInputType.number,
                            hint: "0.00",
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: SvgPicture.asset(
                                "icons/USD.svg",
                                width: 16,
                                height: 16,
                              ),
                            ),
                          ),
                          SizedBox(height: Sizes.marginV16),
                          Text("Source", style: TextStyles.f14(context).medium),
                          SizedBox(height: Sizes.marginV8),
                          AppTextField(
                            controller: _sourceController,
                            textFieldType: TextFieldType.name,
                            hint: "Salary",
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: SvgPicture.asset(
                                "icons/salary.svg",
                                width: 16,
                                height: 16,
                              ),
                            ),
                          ),
                          SizedBox(height: Sizes.marginV16),
                          Text("Date", style: TextStyles.f14(context).medium),
                          SizedBox(height: Sizes.marginV8),
                          AppTextField(
                            controller: _dateController,
                            textFieldType: TextFieldType.other,
                            hint: "mm/dd/yyyy",
                            readOnly: true,
                            onTap: () => _selectDate(context),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Image.asset(
                                "images/date.png",
                                width: 16,
                                height: 16,
                              ),
                            ),
                          ),
                          SizedBox(height: Sizes.marginV16),
                          Text(
                            "Recurring",
                            style: TextStyles.f14(context).medium,
                          ),
                          SizedBox(height: Sizes.marginV8),
                          _buildRecurringBox(),
                          SizedBox(height: Sizes.marginV20),
                        ],
                      ),
                    ),
                  ),
                  BlocBuilder<IncomeCubit, IncomeState>(
                    builder: (context, state) {
                      return AppButton(
                        type: AppButtonType.primary,
                        isLoading: state is IncomeLoading,
                        onPressed: () => _onSavePressed(context),
                        child: Text(
                          "Save Income",
                          style: TextStyles.f14(
                            context,
                          ).medium.colorWith(Colors.white),
                        ),
                      ).paddingAll(Sizes.screenPaddingH16);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = "${picked.month}/${picked.day}/${picked.year}";
      });
    }
  }

  Widget _buildRecurringBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Sizes.radius12),
        border: Border.all(color: const Color(0xFFF1F1F1)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              SvgPicture.asset("icons/rec.svg", width: 18),
              SizedBox(width: Sizes.paddingH8),
              Text(
                "Select Recurring",
                style: TextStyles.f14(context).normal.colorWith(Colors.grey),
              ),
            ],
          ),
          SizedBox(height: Sizes.marginV16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              'On time',
              'Weekly',
              'Monthly',
              'Yearly',
            ].map((type) => _buildRadioItem(type)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioItem(String type) {
    bool isSelected = _selectedRecurring == type;
    return GestureDetector(
      onTap: () => setState(() => _selectedRecurring = type),
      child: Row(
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF3F49A1)
                    : const Color(0xFFAEAEAE),
                width: 2,
              ),
            ),
            child: isSelected
                ? Center(
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Color(0xFF3F49A1),
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 6),
          Text(type, style: TextStyles.f12(context).medium),
        ],
      ),
    );
  }

  void _onSavePressed(BuildContext context) {
    if (_amountController.text.isEmpty) return;

    context.read<IncomeCubit>().addIncome(
      AddIncomeParams(
        amount: double.tryParse(_amountController.text) ?? 0.0,
        source: _sourceController.text.isEmpty
            ? "Salary"
            : _sourceController.text,
        date: _selectedDate,
        recurringType: _selectedRecurring,
      ),
    );
  }
}