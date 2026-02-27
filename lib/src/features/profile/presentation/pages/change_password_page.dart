import 'package:finance_assistent/src/core/config/theme/app_color/extensions_color.dart';
import 'package:finance_assistent/src/core/config/theme/styles/styles.dart';
import 'package:finance_assistent/src/core/utils/const/sizes.dart';
import 'package:finance_assistent/src/core/utils/const/validator_fields.dart';
import 'package:finance_assistent/src/core/utils/extensions/text_ex.dart';
import 'package:finance_assistent/src/core/view/component/base/app_logo.dart';
import 'package:finance_assistent/src/core/view/component/base/app_text_field.dart';
import 'package:finance_assistent/src/core/view/component/base/button.dart';
import 'package:finance_assistent/src/core/view/component/base/custom_toast.dart';
import 'package:finance_assistent/src/core/view/component/base/safe_scaffold.dart';
import 'package:finance_assistent/src/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:finance_assistent/src/features/auth/presentation/cubits/auth_state.dart';
import 'package:finance_assistent/src/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:finance_assistent/src/features/profile/presentation/cubits/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  late GlobalKey<FormState> formKey;
  late TextEditingController currentPasswordCtr;
  late TextEditingController newPasswordCtr;
  late TextEditingController confirmPasswordCtr;
  late ValueNotifier<bool> fieldsIsValidNotifier;
  late ValueNotifier<bool> loadingNotifier;

  void verifyValidation() {
    final isCurrentValid =
        ValidatorFields.isValidPassword(
          context,
        )?.call(currentPasswordCtr.text) ==
        null;

    final isNewValid =
        ValidatorFields.isValidPassword(context)?.call(newPasswordCtr.text) ==
        null;

    final isConfirmValid =
        ValidatorFields.isValidPassword(
          context,
          newPasswordCtr.text,
        )?.call(confirmPasswordCtr.text) ==
        null;

    fieldsIsValidNotifier.value =
        isCurrentValid && isNewValid && isConfirmValid;
  }

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    currentPasswordCtr = TextEditingController();
    newPasswordCtr = TextEditingController();
    confirmPasswordCtr = TextEditingController();
    fieldsIsValidNotifier = ValueNotifier<bool>(false);
    loadingNotifier = ValueNotifier<bool>(false);

    currentPasswordCtr.addListener(verifyValidation);
    newPasswordCtr.addListener(verifyValidation);
    confirmPasswordCtr.addListener(verifyValidation);
  }

  @override
  void dispose() {
    currentPasswordCtr.removeListener(verifyValidation);
    newPasswordCtr.removeListener(verifyValidation);
    confirmPasswordCtr.removeListener(verifyValidation);
    currentPasswordCtr.dispose();
    newPasswordCtr.dispose();
    confirmPasswordCtr.dispose();
    fieldsIsValidNotifier.dispose();
    loadingNotifier.dispose();
    super.dispose();
  }

  Future<void> _onSubmit(BuildContext context) async {
    if (!formKey.currentState!.validate() || !fieldsIsValidNotifier.value) {
      return;
    }

    final authState = context.read<AuthCubit>().state;
    String? userId;
    if (authState is AuthSuccess) {
      userId = authState.user?.id;
    }
    if (userId == null) {
      final profileState = context.read<ProfileCubit>().state;
      if (profileState is ProfileLoaded) {
        userId = profileState.user.id;
      }
    }
    if (userId == null) {
      CustomToast.showErrorMessage(context, 'Unable to resolve user id');
      return;
    }

    loadingNotifier.value = true;
    try {
      final message = await context.read<ProfileCubit>().changePassword(
        id: userId,
        currentPassword: currentPasswordCtr.text.trim(),
        newPassword: newPasswordCtr.text.trim(),
        confirmNewPassword: confirmPasswordCtr.text.trim(),
      );
      if (!mounted) return;
      CustomToast.showSuccessMessage(
        context,
        message.isNotEmpty ? message : 'Password changed successfully',
      );
      Navigator.of(context).canPop();
    } catch (e) {
      if (!mounted) return;
      CustomToast.showErrorMessage(context, e.toString());
    } finally {
      loadingNotifier.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Change Password', style: TextStyles.f20(context).bold),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bottomInset = MediaQuery.of(context).viewInsets.bottom;
          return SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: bottomInset + 16,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: Sizes.marginH24),
                    Center(child: AppLogo()),
                    SizedBox(height: Sizes.marginV24),

                    Text(
                      "Update your password",
                      style: TextStyles.f18(context).bold,
                    ),
                    SizedBox(height: Sizes.marginV12),
                    Text(
                      "Enter your current password and choose a new one.",
                      style: TextStyles.f14(context).medium.colorWith(
                        appSwitcherColors(context).neutralColors.shade80,
                      ),
                    ),

                    SizedBox(height: Sizes.marginV24),

                    AppTextField(
                      controller: currentPasswordCtr,
                      label: 'Current password',
                      textFieldType: TextFieldType.password,
                      obscureText: true,
                      maxLines: 1,
                      validator: ValidatorFields.isValidPassword(context),
                    ),

                    SizedBox(height: Sizes.marginV16),

                    AppTextField(
                      maxLines: 1,
                      controller: newPasswordCtr,
                      label: 'New password',
                      textFieldType: TextFieldType.password,
                      obscureText: true,
                      validator: ValidatorFields.isValidPassword(context),
                    ),

                    SizedBox(height: Sizes.marginV16),

                    AppTextField(
                      controller: confirmPasswordCtr,
                      label: 'Confirm password',
                      maxLines: 1,
                      textFieldType: TextFieldType.password,
                      obscureText: true,
                      validator: ValidatorFields.isValidPassword(
                        context,
                        newPasswordCtr.text,
                      ),
                    ),

                    SizedBox(height: Sizes.marginV24),

                    ValueListenableBuilder<bool>(
                      valueListenable: loadingNotifier,
                      builder: (context, isLoading, _) {
                        return ValueListenableBuilder<bool>(
                          valueListenable: fieldsIsValidNotifier,
                          builder: (context, fieldsIsValid, child) => AppButton(
                            isLoading: isLoading,
                            disableButton: isLoading || !fieldsIsValid,
                            onPressed: (isLoading || !fieldsIsValid)
                                ? null
                                : () => _onSubmit(context),
                            type: AppButtonType.primary,
                            child: Text("Change Password"),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
