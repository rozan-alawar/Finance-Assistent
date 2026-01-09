import 'package:finance_assistent/src/core/gen/app_assets.dart';
import 'package:finance_assistent/src/core/view/component/base/image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../../../utils/const/validator_fields.dart';
import '../base/app_text_field.dart';

class EmailTextField extends StatelessWidget {
  const EmailTextField({required this.controller, this.fillColor, super.key});

  final TextEditingController controller;
  final Color? fillColor;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      label: 'Email',
      textFieldType: TextFieldType.email,
      isRequired: true,
      maxLines: 1,
      validator: (email) {
        return ValidatorFields.isValidEmail(context)?.call(email);
      },
      prefixIcon: AppAssetsSvg(
        AppAssets.ASSETS_ICONS_EMAIL_SVG,
        fit: BoxFit.scaleDown,
      ),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
      autoFillHints: const [AutofillHints.email],
    );
  }
}

class PasswordTextField extends StatelessWidget {
  const PasswordTextField({
    required this.controller,
    this.fillColor,
    super.key, this.isConfirmPass = false,
  });

  final TextEditingController controller;
  final Color? fillColor;
  final bool isConfirmPass;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      label:isConfirmPass?"Confirm password": 'Password',
      obscureText: true,
      textFieldType: TextFieldType.password,
      isRequired: true,
      maxLines: 1,
      validator: isConfirmPass?    (value) {
        final passwordValidation =
        ValidatorFields.isValidPassword(context)?.call(value);
        if (passwordValidation != null) {
          return passwordValidation;
        }

        if (value != controller.text) {
          return 'Passwords do not match';
        }
        return null;
      }: (pass) {
        return ValidatorFields.isValidPassword(context)?.call(pass);
      },
      prefixIcon: AppAssetsSvg(
        AppAssets.ASSETS_ICONS_LOCK_SVG,
        fit: BoxFit.scaleDown,
      ),
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.next,
      inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
      autoFillHints: const [AutofillHints.email],
    );
  }
}

class NameTextField extends StatelessWidget {
  const NameTextField({required this.controller, this.fillColor, super.key});

  final TextEditingController controller;
  final Color? fillColor;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      label: 'Full name ',
      textFieldType: TextFieldType.name,
      isRequired: true,
      maxLines: 1,
      validator: (name) {
        return ValidatorFields.isValidName(context)?.call(name);
      },
      prefixIcon: AppAssetsSvg(
        AppAssets.ASSETS_ICONS_USER_SVG,
        fit: BoxFit.scaleDown,
      ),
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
      autoFillHints: const [AutofillHints.email],
    );
  }
}

class PhoneTextField extends StatelessWidget {
  const PhoneTextField({required this.controller, this.fillColor, super.key});

  final TextEditingController controller;
  final Color? fillColor;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      label: 'Phone',
      textFieldType: TextFieldType.phone,
      isRequired: true,
      maxLines: 1,
      validator: (phone) {
        return ValidatorFields.phoneValidator(context)?.call(phone);
      },
      prefixIcon: AppAssetsSvg(
        AppAssets.ASSETS_ICONS_PHONE_SVG,
        fit: BoxFit.scaleDown,
      ),
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
      autoFillHints: const [AutofillHints.telephoneNumber],
    );
  }
}
