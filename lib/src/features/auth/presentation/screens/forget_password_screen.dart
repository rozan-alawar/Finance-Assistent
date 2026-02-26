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

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  // ========= Controllers ===========
  late GlobalKey<FormState> formKey;
  late TextEditingController emailCtr;
  late ValueNotifier<bool> fieldsIsValidNotifier;

  // ========= Methods ===========
  void verifyValidation() {
    final isEmailValid =
        ValidatorFields.isValidEmail(context)?.call(emailCtr.text.trim()) == null;

    fieldsIsValidNotifier.value = isEmailValid;
  }

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    fieldsIsValidNotifier = ValueNotifier<bool>(false);
    emailCtr = TextEditingController();

    emailCtr.addListener(verifyValidation);
  }

  @override
  void dispose() {
    emailCtr.removeListener(verifyValidation);

    emailCtr.dispose();
    fieldsIsValidNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is OtpSent) {
          if (!mounted) return;
          CustomToast.showSuccessMessage(context, 'Code was sent to email');
          context.push(
            const OtpVerificationRoute().location,
            extra: {'email': emailCtr.text.trim()},
          );
        } else if (state is AuthGuest) {
          if (mounted) {
            HomeRoute().go(context);
          }
        } else if (state is AuthFailure) {
          CustomToast.showErrorMessage(context, state.message);
        }
      },
      builder: (context, state) {
        final sectionSpace = SizedBox(height: Sizes.marginH16);

        return SafeScaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: TextButton(
                  onPressed: () {
                    context.read<AuthCubit>().loginAsGuest();
                  },
                  child: Container(
                    padding: EdgeInsets.all(Sizes.paddingH8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 1),
                          spreadRadius: 1,
                          blurRadius: 4,
                          color: Colors.black.withValues(alpha: 0.16),
                        ),
                      ],
                    ),
                    child: Icon(Icons.close, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
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
                          "Forget password",
                          style: TextStyles.f18(context).bold,
                        ),

                        sectionSpace,

                        Text(
                          "We will send you a 4-digit verification code. Enter your email address so we can send you the verification code.",
                          style: TextStyles.f14(context).medium.colorWith(
                            appSwitcherColors(context).neutralColors.shade80,
                          ),
                        ),

                        sectionSpace,
                        sectionSpace,

                        EmailTextField(controller: emailCtr),

                        sectionSpace,
                        sectionSpace,

                        ValueListenableBuilder<bool>(
                          valueListenable: fieldsIsValidNotifier,
                          builder: (context, fieldsIsValid, child) => AppButton(
                            isLoading: state is AuthLoading,
                            disableButton: state is AuthLoading || !fieldsIsValid,
                            onPressed: (state is AuthLoading || !fieldsIsValid)
                                ? null
                                : () {
                                    if (formKey.currentState!.validate()) {
                                      context.read<AuthCubit>().sendOtp(
                                        email: emailCtr.text.trim(),
                                      );
                                    }
                                  },
                            type: AppButtonType.primary,
                            child: Text("Send"),
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
    );
  }
}
