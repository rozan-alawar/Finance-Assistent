import 'dart:async';

import 'package:finance_assistent/src/core/config/theme/app_color/extensions_color.dart';
import 'package:finance_assistent/src/core/config/theme/styles/styles.dart';
import 'package:finance_assistent/src/core/utils/const/sizes.dart';
import 'package:finance_assistent/src/core/utils/extensions/num_ex.dart';
import 'package:finance_assistent/src/core/utils/extensions/text_ex.dart';
import 'package:finance_assistent/src/core/utils/extensions/widget_ex.dart';
import 'package:finance_assistent/src/core/view/component/base/app_logo.dart';
import 'package:finance_assistent/src/core/view/component/base/button.dart';
import 'package:finance_assistent/src/core/view/component/base/custom_toast.dart';
import 'package:finance_assistent/src/core/view/component/base/safe_scaffold.dart';
import 'package:finance_assistent/src/features/auth/presentation/components/otp_pin_widget.dart';
import 'package:finance_assistent/src/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:finance_assistent/src/features/auth/presentation/cubits/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_route.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String? email;

  const OtpVerificationScreen({super.key, this.email});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  late String email;

  // ========= Controllers ===========
  late TextEditingController otpCtr;
  late ValueNotifier<bool> fieldsIsValidNotifier;
  late ValueNotifier<int> timerNotifier;
  Timer? _timer;

  // ========= Constants ===========
  static const int _countdownDuration = 180;

  // ========= Methods ===========
  void verifyValidation() {
    final isOtpValid = otpCtr.text.trim().length == 4;
    fieldsIsValidNotifier.value = isOtpValid;
  }

  void startTimer() {
    timerNotifier.value = _countdownDuration;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timerNotifier.value > 0) {
        timerNotifier.value--;
      } else {
        timer.cancel();
      }
    });
  }

  String formatTime(int seconds) {
    final minutes = (seconds / 60).floor();
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void resendCode() {
    if (timerNotifier.value == 0) {
      context.read<AuthCubit>().sendOtp(email: email);
      startTimer();
    }
  }

  @override
  void initState() {
    super.initState();

    email = widget.email ?? '';

    fieldsIsValidNotifier = ValueNotifier<bool>(false);
    timerNotifier = ValueNotifier<int>(_countdownDuration);
    otpCtr = TextEditingController();

    otpCtr.addListener(verifyValidation);
    startTimer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (widget.email == null || widget.email!.isEmpty) {
      try {
        final state = GoRouterState.of(context);
        final extra = state.extra;

        if (extra is String) {
          email = extra;
        } else if (extra is Map) {
          email = (extra['email'] as String?) ?? '';
        }
      } catch (e) {
        email = '';
      }
    }
  }

  @override
  void dispose() {
    otpCtr.removeListener(verifyValidation);

    otpCtr.dispose();
    fieldsIsValidNotifier.dispose();
    timerNotifier.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is OtpVerified) {
          CustomToast.showSuccessMessage(
            context,
            'OTP Verified Successfully',
          );
          const ResetPasswordRoute().go(context);
        } else if (state is AuthGuest) {
          if (mounted) {
            HomeRoute().go(context);
          }
        } else if (state is OtpSent) {
          CustomToast.showSuccessMessage(context, 'Code sent successfully');
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: Sizes.marginH24),
                      Center(child: AppLogo()),
                      sectionSpace,

                      Text(
                        "Check your email",
                        style: TextStyles.f18(context).bold,
                      ),

                      6.height,

                      Text(
                        'A four-digit code has been sent to your email:  ${email.isNotEmpty ? email : 'your email'}',
                        style: TextStyles.f14(context).medium.colorWith(
                          appSwitcherColors(context).neutralColors.shade80,
                        ),
                      ),

                      sectionSpace,
                      sectionSpace,

                      OtpPinWidget(
                        otpCtr: otpCtr,
                        fieldsIsValidNotifier: fieldsIsValidNotifier,
                      ),

                      sectionSpace,
                      sectionSpace,

                      ValueListenableBuilder<bool>(
                        valueListenable: fieldsIsValidNotifier,
                        builder: (context, fieldsIsValid, child) => AppButton(
                          isLoading: state is AuthLoading,
                          disableButton:
                              state is AuthLoading || !fieldsIsValid,
                          onPressed: (state is AuthLoading || !fieldsIsValid)
                              ? null
                              : () {
                                  context.read<AuthCubit>().verifyOtp(
                                    code: otpCtr.text.trim(),
                                  );
                                },
                          type: AppButtonType.primary,
                          child: Text("Confirm"),
                        ),
                      ),

                      sectionSpace,

                      ValueListenableBuilder<int>(
                        valueListenable: timerNotifier,
                        builder: (context, timeLeft, child) {
                          return Center(
                            child: RichText(
                              text: TextSpan(
                                style: TextStyles.f14(context).medium
                                    .colorWith(
                                      appSwitcherColors(
                                        context,
                                      ).neutralColors.shade80,
                                    ),
                                children: [
                                  const TextSpan(text: 'Code expires in : '),
                                  TextSpan(
                                    text: formatTime(timeLeft),
                                    style: TextStyles.f14(context).semiBold
                                        .colorWith(
                                          appSwitcherColors(
                                            context,
                                          ).dangerColor,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                      sectionSpace,

                      ValueListenableBuilder<int>(
                        valueListenable: timerNotifier,
                        builder: (context, timeLeft, child) {
                          final canResend = timeLeft == 0;
                          return Center(
                            child: RichText(
                              text: TextSpan(
                                style: TextStyles.f14(context).medium
                                    .colorWith(
                                      appSwitcherColors(
                                        context,
                                      ).neutralColors.shade80,
                                    ),
                                children: [
                                  const TextSpan(
                                    text:
                                        'I did not receive the code by email, ',
                                  ),
                                  WidgetSpan(
                                    child: Text(
                                      'please resend',
                                      style: TextStyles.f14(context)
                                          .semiBold
                                          .colorWith(
                                            canResend &&
                                                    state is! AuthLoading
                                                ? appCommonUIColors(
                                                    context,
                                                  ).blueText
                                                : appSwitcherColors(
                                                    context,
                                                  ).primaryColor,
                                          ),
                                    ).onTap(
                                      canResend && state is! AuthLoading
                                          ? resendCode
                                          : null,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
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
