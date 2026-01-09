import 'package:finance_assistent/src/core/config/theme/app_color/extensions_color.dart';
import 'package:finance_assistent/src/core/config/theme/styles/styles.dart';
import 'package:finance_assistent/src/core/routing/app_route.dart';
import 'package:finance_assistent/src/core/utils/const/sizes.dart';
import 'package:finance_assistent/src/core/utils/const/validator_fields.dart';
import 'package:finance_assistent/src/core/utils/extensions/text_ex.dart';
import 'package:finance_assistent/src/core/view/component/base/app_logo.dart';
import 'package:finance_assistent/src/core/view/component/base/button.dart';
import 'package:finance_assistent/src/core/view/component/base/custom_toast.dart';
import 'package:finance_assistent/src/core/view/component/base/safe_scaffold.dart';
import 'package:finance_assistent/src/core/view/component/common/text_fields.dart';
import 'package:finance_assistent/src/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:finance_assistent/src/features/auth/presentation/cubits/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  // ========= Controllers ===========
  late GlobalKey<FormState> formKey;
  late TextEditingController newPasswordCtr;
  late TextEditingController confirmPasswordCtr;
  late ValueNotifier<bool> fieldsIsValidNotifier;

  // ========= Methods ===========
  void verifyValidation() {
    final isNewPasswordValid =
        ValidatorFields.isValidPassword(context)?.call(newPasswordCtr.text) ==
        null;

    final isConfirmPasswordValid =
        ValidatorFields.isValidPassword(
          context,
        )?.call(confirmPasswordCtr.text) ==
        null;

    final passwordsMatch = newPasswordCtr.text == confirmPasswordCtr.text;

    fieldsIsValidNotifier.value =
        isNewPasswordValid && isConfirmPasswordValid && passwordsMatch;
  }

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    fieldsIsValidNotifier = ValueNotifier<bool>(false);
    newPasswordCtr = TextEditingController();
    confirmPasswordCtr = TextEditingController();

    newPasswordCtr.addListener(verifyValidation);
    confirmPasswordCtr.addListener(verifyValidation);
  }

  @override
  void dispose() {
    newPasswordCtr.removeListener(verifyValidation);
    confirmPasswordCtr.removeListener(verifyValidation);

    newPasswordCtr.dispose();
    confirmPasswordCtr.dispose();
    fieldsIsValidNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is PasswordResetSuccess) {
            CustomToast.showSuccessMessage(
              context,
              'Password reset successfully',
            );
           LoginRoute().go(context);
          } else if (state is AuthFailure) {
            CustomToast.showErrorMessage(context, state.message);
          }
        },
        builder: (context, state) {
          final sectionSpace = SizedBox(height: Sizes.marginH16);

          return SafeScaffold(
            body: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: Sizes.marginH24),
                          Center(child: AppLogo()),
                          sectionSpace,

                          Text(
                            "Reset password",
                            style: TextStyles.f18(context).bold,
                          ),

                          sectionSpace,

                          Text(
                            "Enter the new password. Try to make it simple so that you can easily register later.",
                            style: TextStyles.f14(context).medium.colorWith(
                              appSwitcherColors(context).neutralColors.shade80,
                            ),
                          ),

                          sectionSpace,
                          sectionSpace,

                          PasswordTextField(controller: newPasswordCtr),

                          sectionSpace,

                          PasswordTextField(
                            controller: confirmPasswordCtr,
                            isConfirmPass:true,
                          ),

                          sectionSpace,
                          sectionSpace,

                          ValueListenableBuilder<bool>(
                            valueListenable: fieldsIsValidNotifier,
                            builder: (context, fieldsIsValid, child) =>
                                AppButton(
                                  isLoading: state is AuthLoading,
                                  disableButton:
                                      state is AuthLoading || !fieldsIsValid,
                                  onPressed:
                                      (state is AuthLoading || !fieldsIsValid)
                                      ? null
                                      : () {
                                          if (formKey.currentState!
                                              .validate()) {
                                            context
                                                .read<AuthCubit>()
                                                .resetPassword(
                                                  newPassword: newPasswordCtr
                                                      .text
                                                      .trim(),
                                                );
                                          }
                                        },
                                  type: AppButtonType.primary,
                                  child: Text("Confirm"),
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
