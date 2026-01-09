import 'dart:developer';

import 'package:finance_assistent/src/core/config/theme/app_color/extensions_color.dart';
import 'package:finance_assistent/src/core/routing/app_route.dart';
import 'package:finance_assistent/src/core/utils/extensions/text_ex.dart';
import 'package:finance_assistent/src/core/view/component/base/button.dart';
import 'package:finance_assistent/src/core/view/component/common/text_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:finance_assistent/src/core/config/theme/styles/styles.dart';
import 'package:finance_assistent/src/core/gen/app_assets.dart';
import 'package:finance_assistent/src/core/utils/const/sizes.dart';
import 'package:finance_assistent/src/core/utils/const/validator_fields.dart';
import 'package:finance_assistent/src/core/utils/extensions/num_ex.dart';
import 'package:finance_assistent/src/core/view/component/base/app_logo.dart';
import 'package:finance_assistent/src/core/view/component/base/safe_scaffold.dart';
import 'package:finance_assistent/src/core/view/component/base/custom_toast.dart';
import '../components/social_login_buttons.dart';
import '../cubits/auth_cubit.dart';
import '../cubits/auth_state.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // ========= Controllers ===========
  late GlobalKey<FormState> formKey;
  late TextEditingController emailCtr;
  late TextEditingController nameCtr;
  late TextEditingController phoneCtr;
  late TextEditingController passwordCtr;

  late ValueNotifier<bool> fieldsIsValidNotifier;

  // ========= Methods ===========
  void verifyValidation() {
    final isNameValid =
        ValidatorFields.isValidName(context)?.call(nameCtr.text) ==
        null;

    final isEmailValid =
        ValidatorFields.isValidEmail(context)?.call(emailCtr.text.trim()) ==
        null;

    final isPasswordValid =
        ValidatorFields.isValidPassword(context)?.call(passwordCtr.text) ==
        null;

    final isValidPhone =
        ValidatorFields.phoneValidator(context)?.call(phoneCtr.text) == null;

    fieldsIsValidNotifier.value =
        isNameValid && isEmailValid && isPasswordValid && isValidPhone;
  }

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    fieldsIsValidNotifier = ValueNotifier<bool>(false);
    emailCtr = TextEditingController();
    phoneCtr = TextEditingController();
    nameCtr = TextEditingController();
    passwordCtr = TextEditingController();

    // ✅ Add listeners to all text controllers
    nameCtr.addListener(verifyValidation);
    emailCtr.addListener(verifyValidation);
    phoneCtr.addListener(verifyValidation);
    passwordCtr.addListener(verifyValidation);
  }

  @override
  void dispose() {
    nameCtr.removeListener(verifyValidation);
    emailCtr.removeListener(verifyValidation);
    phoneCtr.removeListener(verifyValidation);
    passwordCtr.removeListener(verifyValidation);

    nameCtr.dispose();
    phoneCtr.dispose();
    emailCtr.dispose();
    passwordCtr.dispose();
    fieldsIsValidNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            CustomToast.showSuccessMessage(context, "Registration Successful!");
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
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 20),
                          const Center(child: AppLogo()),
                          sectionSpace,

                          Text("Sign Up", style: TextStyles.f18(context).bold),
                          sectionSpace,

                          NameTextField(controller: nameCtr),
                          sectionSpace,

                          EmailTextField(controller: emailCtr),
                          sectionSpace,

                          PhoneTextField(controller: phoneCtr),
                          sectionSpace,

                          PasswordTextField(controller: passwordCtr),
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
                                            context.read<AuthCubit>().register(
                                              name: nameCtr.text.trim(),
                                              email: emailCtr.text.trim(),
                                              phone: phoneCtr.text.trim(),
                                              password: passwordCtr.text,
                                            );
                                          }
                                        },
                                  type: AppButtonType.primary,
                                  child: Text(
                                    'Sign Up',
                                    style: TextStyles.f16(context).medium
                                        .colorWith(
                                          appCommonUIColors(context).white,
                                        ),
                                  ),
                                ),
                          ),

                          const SizedBox(height: 24),

                          const Row(
                            children: [
                              Expanded(child: Divider()),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Text('OR'),
                              ),
                              Expanded(child: Divider()),
                            ],
                          ),


                          sectionSpace,

                          SocialLoginButton(
                            providerName: "Google",
                            providerIcon: AppAssets.ASSETS_IMAGES_GOOGLE_PNG,
                            onPressed: () {},
                          ),

                          8.height,
                          SocialLoginButton(
                            providerName: "Apple",
                            providerIcon: AppAssets.ASSETS_IMAGES_APPLE_PNG,
                            onPressed: () {},
                          ),

                          const Spacer(),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Already have an account? "),
                              TextButton(
                                onPressed: () => context.pop(),
                                child: const Text('Login'),
                              ),
                            ],
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
