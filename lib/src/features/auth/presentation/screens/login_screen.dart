import 'package:finance_assistent/src/core/config/theme/app_color/extensions_color.dart';
import 'package:finance_assistent/src/core/gen/app_assets.dart';
import 'package:finance_assistent/src/core/routing/app_route.dart';
import 'package:finance_assistent/src/core/config/theme/styles/styles.dart';
import 'package:finance_assistent/src/core/utils/extensions/num_ex.dart';
import 'package:finance_assistent/src/core/utils/extensions/text_ex.dart';
import 'package:finance_assistent/src/core/utils/extensions/widget_ex.dart';
import 'package:finance_assistent/src/core/view/component/base/app_logo.dart';
import 'package:finance_assistent/src/core/view/component/base/button.dart';
import 'package:finance_assistent/src/core/view/component/base/image.dart';
import 'package:finance_assistent/src/core/view/component/base/safe_scaffold.dart';
import 'package:finance_assistent/src/features/auth/presentation/components/social_login_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  // ========= Methods ===========
  void verifyValidation() {
      final isEmailValid =
          ValidatorFields.isValidEmail(
            context,
          )?.call(emailCtr.text.trim()) ==
              null;
      final isPasswordValid =
          ValidatorFields.isValidPassword(
            context,
          )?.call(passwordCtr.text) ==
              null;

      fieldsIsValidNotifier.value =
              isEmailValid &&
              isPasswordValid ;
  }



  @override
  void initState() {
    super.initState();

    formKey = GlobalKey<FormState>();
    fieldsIsValidNotifier = ValueNotifier<bool>(false);
    emailCtr = TextEditingController();
    passwordCtr = TextEditingController();

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


    return BlocProvider(
        create: (context) => AuthCubit(),
        child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthSuccess) {
                CustomToast.showSuccessMessage( context,"Login Successful!");
                HomeRoute().go(context);
              } else if (state is AuthFailure) {
                CustomToast.showErrorMessage( context, state.message);
              }
            },
            builder: (context, state) {
        return SafeScaffold(
          body: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Form(
                    onChanged: verifyValidation,
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Checkbox(value: false, onChanged: (val) {}),
                            Text(
                              "Remember me",
                              style: TextStyles.f12(context).medium,
                            ),
                            Spacer(),
                            Text(
                              "Did you Forget password ?",
                              style: TextStyles.f12(
                                context,
                              ).medium.colorWith(appCommonUIColors(context).blueText),
                            ).onTap(() {
                              ForgetPasswordRoute().go(context);
                            }),
                          ],
                        ),

                        sectionSpace,
                        sectionSpace,

                    ValueListenableBuilder<bool>(
                      valueListenable: fieldsIsValidNotifier,
                      builder: (BuildContext context, fieldsIsValid, Widget? child) =>
                           AppButton(
                               isLoading: state is AuthLoading,
                               disableButton: state is AuthLoading ||!fieldsIsValid ,
                               onPressed: state is AuthLoading
                                   ? null
                                   :
                    () {
                      if (formKey.currentState!.validate()&& fieldsIsValid ==true) {
                        context.read<AuthCubit>().login(
                          email: emailCtr.text,
                          password: passwordCtr.text,
                        );
                      }
                    },
                            type: AppButtonType.primary,
                            child: Text("Login"),
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
                        SocialLoginButton(providerName: "Google", providerIcon: AppAssets.ASSETS_IMAGES_GOOGLE_PNG, onPressed: (){},),

                        8.height,
                        SocialLoginButton(providerName: "Apple", providerIcon: AppAssets.ASSETS_IMAGES_APPLE_PNG, onPressed: (){},),

                        const Spacer(),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an account? "),
                            TextButton(
                              onPressed: () => const RegisterRoute().go(context),
                              child: const Text('Sign Up'),
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
      }
        ),

    );
  }

}
