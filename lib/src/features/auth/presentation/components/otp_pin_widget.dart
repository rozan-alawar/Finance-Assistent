import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';

import '../../../../core/config/theme/app_color/extensions_color.dart';
import '../../../../core/config/theme/styles/styles.dart';
import '../../../../core/utils/extensions/text_ex.dart';
import '../cubits/auth_cubit.dart';

class OtpPinWidget extends StatelessWidget {
  const OtpPinWidget({super.key, required this.otpCtr, required this.fieldsIsValidNotifier});
final TextEditingController otpCtr;
final ValueNotifier fieldsIsValidNotifier ;
  @override
  Widget build(BuildContext context) {
    return
      Pinput(
        length: 4,
        controller: otpCtr,
        defaultPinTheme: PinTheme(
          width: 64,
          height: 64,
          textStyle: TextStyles.f20(context).semiBold
              .colorWith(
            appCommonUIColors(context).onSurface,
          ),
          decoration: BoxDecoration(
            color: appCommonUIColors(context).surface,
            border: Border.all(
              color: appCommonUIColors(context).border,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        focusedPinTheme: PinTheme(
          width: 64,
          height: 64,
          textStyle: TextStyles.f20(context).semiBold
              .colorWith(
            appCommonUIColors(context).onSurface,
          ),
          decoration: BoxDecoration(
            color: appCommonUIColors(context).surface,
            border: Border.all(
              color: appSwitcherColors(context).primaryColor,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        errorPinTheme: PinTheme(
          width: 64,
          height: 64,
          textStyle: TextStyles.f20(context).semiBold
              .colorWith(
            appCommonUIColors(context).dangerLight,
          ),
          decoration: BoxDecoration(
            color: appCommonUIColors(context).surface,
            border: Border.all(
              color: appCommonUIColors(context).dangerLight,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onCompleted: (pin) {
          if (fieldsIsValidNotifier.value) {
            context.read<AuthCubit>().verifyOtp(code: pin);
          }
        },
      );
  }
}
