import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

@immutable
class ValidatorFields {
  const ValidatorFields();

  static String? Function(String?)? isValidEmail(BuildContext context) =>
      FormBuilderValidators.compose([
        FormBuilderValidators.required(errorText: "Email is required"),
        FormBuilderValidators.email(errorText: "Enter a valid email address"),
      ]);

  static String? Function(String?)? isValidName(BuildContext context) =>
      FormBuilderValidators.compose([
        FormBuilderValidators.required(errorText: "Name is required"),
        FormBuilderValidators.minLength(
          3,
          errorText: "Name must be at least 3 characters",
        ),
        FormBuilderValidators.maxLength(
          20,
          errorText: "Name must not exceed 20 characters",
        ),
      ]);

  static String? Function(String?) phoneValidator(BuildContext context) {
    return FormBuilderValidators.compose([
      FormBuilderValidators.match(
        RegExp(r'^[0-9]+$'),
        errorText: "Please enter a valid phone number",
      ),
      FormBuilderValidators.minLength(
        8,
        errorText: "Phone number must be between 8 and 10 digits",
      ),
      FormBuilderValidators.maxLength(
        10,
        errorText: "Phone number must be between 8 and 10 digits",
      ),
    ]);
  }

  static String? Function(String?)? isValidPassword(
    BuildContext context, [
    String? passwordToConfirm,
  ]) => FormBuilderValidators.compose([
    FormBuilderValidators.required(errorText: "Password is required"),
    FormBuilderValidators.minLength(
      6,
      errorText: "Password must be at least 6 characters",
    ),
    FormBuilderValidators.maxLength(
      50,
      errorText: "Password must be at most 50 characters",
    ),
    if (passwordToConfirm != null)
      FormBuilderValidators.equal(
        passwordToConfirm,
        errorText: "Passwords do not match",
      ),
  ]);
}
