import 'package:finance_assistent/src/core/config/theme/app_color/extensions_color.dart';
import 'package:finance_assistent/src/core/config/theme/styles/styles.dart';
import 'package:finance_assistent/src/core/gen/app_assets.dart';
import 'package:finance_assistent/src/core/routing/app_route.dart';
import 'package:finance_assistent/src/core/utils/extensions/num_ex.dart';
import 'package:finance_assistent/src/core/utils/extensions/text_ex.dart';
import 'package:finance_assistent/src/core/utils/extensions/widget_ex.dart';
import 'package:finance_assistent/src/core/view/component/base/app_logo.dart';
import 'package:finance_assistent/src/core/view/component/base/button.dart';
import 'package:finance_assistent/src/core/view/component/base/safe_scaffold.dart';
import 'package:finance_assistent/src/features/auth/presentation/components/social_login_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/dependency_injection.dart' as di;
import '../../../../core/services/local_storage/hive_service.dart';
import '../../../../core/services/social/google_sign_in_service.dart';
import '../../../../core/utils/const/sizes.dart';
import '../../../../core/utils/const/validator_fields.dart';
import '../../../../core/view/component/base/custom_toast.dart';
import '../../../../core/view/component/base/divider.dart';
import '../../../../core/view/component/common/text_fields.dart';
import '../cubits/auth_cubit.dart';
import '../cubits/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // ========= Controllers ===========
  late TextEditingController emailCtr;
  late TextEditingController passwordCtr;
  late GlobalKey<FormState> formKey;

  late ValueNotifier<bool> fieldsIsValidNotifier;
  late bool rememberMe;

  // ========= Methods ===========
  void verifyValidation() {
    final isEmailValid =
        ValidatorFields.isValidEmail(context)?.call(emailCtr.text.trim()) ==
        null;
    final isPasswordValid =
        ValidatorFields.isValidPassword(context)?.call(passwordCtr.text) ==
        null;

    fieldsIsValidNotifier.value = isEmailValid && isPasswordValid;
  }

  @override
  void initState() {
    super.initState();

    formKey = GlobalKey<FormState>();
    fieldsIsValidNotifier = ValueNotifier<bool>(false);
    emailCtr = TextEditingController();
    passwordCtr = TextEditingController();

    // Load saved credentials
    rememberMe = HiveService.get(
      HiveService.settingsBoxName,
      'remember_me',
      defaultValue: false,
    );

    if (rememberMe) {
      emailCtr.text = HiveService.get(
        HiveService.settingsBoxName,
        'saved_email',
        defaultValue: '',
      );
      passwordCtr.text = HiveService.get(
        HiveService.settingsBoxName,
        'saved_password',
        defaultValue: '',
      );
      // Trigger validation for pre-filled data
      fieldsIsValidNotifier.value = true;
    }

    emailCtr.addListener(verifyValidation);
    passwordCtr.addListener(verifyValidation);
  }

  @override
  void dispose() {
    emailCtr.removeListener(verifyValidation);
    passwordCtr.removeListener(verifyValidation);

    emailCtr.dispose();
    passwordCtr.dispose();
    fieldsIsValidNotifier.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sectionSpace = SizedBox(height: Sizes.marginH16);

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) async {
        if (state is AuthSuccess) {
          if (rememberMe) {
            await HiveService.put(
              HiveService.settingsBoxName,
              'remember_me',
              true,
            );
            await HiveService.put(
              HiveService.settingsBoxName,
              'saved_email',
              emailCtr.text,
            );
            await HiveService.put(
              HiveService.settingsBoxName,
              'saved_password',
              passwordCtr.text,
            );
          } else {
            await HiveService.put(
              HiveService.settingsBoxName,
              'remember_me',
              false,
            );
            await HiveService.delete(
              HiveService.settingsBoxName,
              'saved_email',
            );
            await HiveService.delete(
              HiveService.settingsBoxName,
              'saved_password',
            );
          }
          if (mounted) {
            CustomToast.showSuccessMessage(context, "Login Successful!");
            HomeRoute().go(context);
          }
        } else if (state is AuthGuest) {
          if (mounted) {
            HomeRoute().go(context);
          }
        } else if (state is AuthFailure) {
          CustomToast.showErrorMessage(context, state.message);
        }
      },
      builder: (context, state) {
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
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Form(
                    key: formKey,
                    onChanged: verifyValidation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: Sizes.marginH24),
                        Center(child: AppLogo()),

                        sectionSpace,
                        Text("Login", style: TextStyles.f18(context).bold),

                        sectionSpace,
                        EmailTextField(controller: emailCtr),

                        sectionSpace,
                        PasswordTextField(controller: passwordCtr),

                        Row(
                          children: [
                            Checkbox(
                              value: rememberMe,
                              onChanged: (val) {
                                setState(() {
                                  rememberMe = val ?? false;
                                });
                              },
                            ),
                            Text(
                              "Remember me",
                              style: TextStyles.f12(context).medium,
                            ),
                            Spacer(),
                            Text(
                              "Did you Forget password ?",
                              style: TextStyles.f12(context).medium.colorWith(
                                appCommonUIColors(context).blueText,
                              ),
                            ).onTap(() {
                              ForgetPasswordRoute().go(context);
                            }),
                          ],
                        ),

                        sectionSpace,
                        sectionSpace,

                        ValueListenableBuilder<bool>(
                          valueListenable: fieldsIsValidNotifier,
                          builder: (_, fieldsIsValid, _) => AppButton(
                            isLoading: state is AuthLoading,
                            disableButton:
                                state is AuthLoading || !fieldsIsValid,
                            onPressed: state is AuthLoading
                                ? null
                                : () {
                                    if (formKey.currentState!.validate() &&
                                        fieldsIsValid) {
                                      context.read<AuthCubit>().login(
                                        email: emailCtr.text,
                                        password: passwordCtr.text,
                                      );
                                    }
                                  },
                            type: AppButtonType.primary,
                            child: const Text("Login"),
                          ),
                        ),

                        sectionSpace,

                        Row(
                          children: [
                            Expanded(child: AppDivider()),
                            SizedBox(width: Sizes.paddingH12),
                            Text("OR"),
                            SizedBox(width: Sizes.paddingH12),
                            Expanded(child: AppDivider()),
                          ],
                        ),

                        sectionSpace,
                        SocialLoginButton(
                          providerName: "Google",
                          providerIcon: AppAssets.ASSETS_IMAGES_GOOGLE_PNG,
                          onPressed: () async {
                            final service = di.sl<GoogleSignInService>();
                            final result = await service.signInToken();
                            if (result.token == null || result.token!.isEmpty) {
                              CustomToast.showErrorMessage(
                                context,
                                result.error ?? "Google sign-in failed",
                              );
                              return;
                            }
                            if (mounted) {
                              context.read<AuthCubit>().socialLogin(
                                token: result.token!,
                                socialType: 'google',
                              );
                            }
                          },
                        ),

                        8.height,
                        SocialLoginButton(
                          providerName: "Apple",
                          providerIcon: AppAssets.ASSETS_IMAGES_APPLE_PNG,
                          onPressed: () {},
                        ),

                        SizedBox(height: 24),

                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text("Don't have an account? "),
                              TextButton(
                                onPressed: () =>
                                    const RegisterRoute().go(context),
                                child: const Text('Sign Up'),
                              ),
                            ],
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
