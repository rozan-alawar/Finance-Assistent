import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../config/theme/app_color/extensions_color.dart';
import '../../../config/theme/styles/styles.dart';
import '../../../utils/extensions/text_ex.dart';
import '../../../utils/extensions/widget_ex.dart';

enum TextFieldType { email, name, multiline, other, phone, password }

class AppTextField extends StatefulWidget {
  final TextEditingController? controller;
  final TextFieldType textFieldType;

  final FocusNode? focus;
  final FormFieldValidator<String>? validator;
  final TextCapitalization? textCapitalization;
  final TextInputAction? textInputAction;
  final Function(String)? onFieldSubmitted;
  final Function(String)? onChanged;
  final FocusNode? nextFocus;
  final TextStyle? textStyle;
  final TextAlign textAlign;
  final int? maxLines;
  final int? minLines;
  final bool? enabled;
  final bool autoFocus;
  final bool readOnly;
  final bool? enableSuggestions;
  final int? maxLength;
  final Color? cursorColor;
  final Color? fillColor;
  final Widget? suffix;
  final Widget? prefixIcon;
  final Color? suffixIconColor;
  final TextInputType? keyboardType;
  final Iterable<String>? autoFillHints;
  final EdgeInsets? scrollPadding;
  final double? cursorWidth;
  final double? cursorHeight;
  final Function()? onTap;
  final InputCounterWidgetBuilder? buildCounter;
  final List<TextInputFormatter>? inputFormatters;
  final TextAlignVertical? textAlignVertical;
  final bool expands;
  final bool? showCursor;
  final TextSelectionControls? selectionControls;
  final StrutStyle? strutStyle;
  final String obscuringCharacter;
  final String? initialValue;
  final Brightness? keyboardAppearance;
  final Widget? suffixPasswordVisibleWidget;
  final Widget? suffixPasswordInvisibleWidget;
  final EditableTextContextMenuBuilder? contextMenuBuilder;
  final String? label;
  final String? hint;
  final bool isRequired;
  final String? errorMinimumPasswordLength;

  final String? title;
  final TextStyle? titleTextStyle;
  final double spacingBetweenTitleAndTextFormField;
  final bool obscureText;

  const AppTextField({
    this.controller,
    required this.textFieldType,
    this.focus,
    this.validator,
    this.buildCounter,
    this.textCapitalization,
    this.textInputAction,
    this.onFieldSubmitted,
    this.nextFocus,
    this.textStyle,
    this.textAlign = TextAlign.start,
    this.maxLines,
    this.minLines,
    this.enabled,
    this.onChanged,
    this.cursorColor,
    this.fillColor,
    this.suffix,
    this.suffixIconColor,
    this.enableSuggestions,
    this.autoFocus = false,
    this.readOnly = false,
    this.maxLength,
    this.keyboardType,
    this.autoFillHints,
    this.scrollPadding,
    this.onTap,
    this.cursorWidth,
    this.cursorHeight,
    this.inputFormatters,
    this.errorMinimumPasswordLength,

    this.textAlignVertical,
    this.expands = false,
    this.showCursor,
    this.selectionControls,
    this.strutStyle,
    this.obscuringCharacter = '•',
    this.initialValue,
    this.keyboardAppearance,
    this.suffixPasswordVisibleWidget,
    this.suffixPasswordInvisibleWidget,
    this.contextMenuBuilder,
    this.title,

    this.titleTextStyle,
    this.spacingBetweenTitleAndTextFormField = 4,

    super.key,
    this.label,
    this.isRequired = true,
    this.prefixIcon,
    this.hint,
    this.obscureText = false,
  });

  @override
  AppTextFieldState createState() => AppTextFieldState();
}

class AppTextFieldState extends State<AppTextField> {
  bool isPasswordVisible = false;

  void onPasswordVisibilityChange(bool val) {
    isPasswordVisible = val;
    setState(() {});
  }

  Widget? suffixIcon() {
    if (widget.textFieldType == TextFieldType.password) {
      if (widget.suffix != null) {
        return widget.suffix;
      } else {
        if (isPasswordVisible) {
          if (widget.suffixPasswordVisibleWidget != null) {
            return widget.suffixPasswordVisibleWidget!.onTap(() {
              onPasswordVisibilityChange(false);
            });
          } else {
            return Icon(
              Icons.visibility,
              color:
                  widget.suffixIconColor ??
                  appSwitcherColors(context).neutralColors.shade200,
            ).onTap(() {
              onPasswordVisibilityChange(false);
            });
          }
        } else {
          if (widget.suffixPasswordInvisibleWidget != null) {
            return widget.suffixPasswordInvisibleWidget!.onTap(() {
              onPasswordVisibilityChange(true);
            });
          } else {
            return Icon(
              Icons.visibility_off,
              color:
                  widget.suffixIconColor ??
                  appSwitcherColors(context).neutralColors.shade200,
            ).onTap(() {
              onPasswordVisibilityChange(true);
            });
          }
        }
      }
    } else {
      return widget.suffix;
    }
  }

  Widget textFormFieldWidget() {
    final textFieldColors = appTextFieldColors(context);

    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,

      obscureText:
          widget.textFieldType == TextFieldType.password &&
          !isPasswordVisible &&
          widget.obscureText,
      controller: widget.controller,
      validator: widget.validator,
      textCapitalization: widget.textCapitalization ?? TextCapitalization.none,
      textInputAction:
          widget.textInputAction ??
          (widget.nextFocus != null
              ? TextInputAction.next
              : TextInputAction.done),
      onFieldSubmitted: (s) {
        if (widget.nextFocus != null) {
          FocusScope.of(context).requestFocus(widget.nextFocus);
        }

        if (widget.onFieldSubmitted != null) widget.onFieldSubmitted!.call(s);
      },
      keyboardType: widget.keyboardType ?? TextInputType.text,
      decoration: InputDecoration(
        suffixIcon:
            widget.suffix ??
            (widget.textFieldType == TextFieldType.password
                ? suffixIcon()
                : SizedBox()),
        filled: true,
        fillColor: widget.fillColor ?? textFieldColors.fillColor,
        label: widget.label != null
            ? RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: widget.label,
                      style: TextStyles.f12(
                        context,
                      ).colorWith(textFieldColors.labelColor),
                    ),
                    if (widget.isRequired)
                      TextSpan(
                        text: ' *',
                        style: TextStyle(
                          color: textFieldColors.requiredMarkColor,
                          fontSize: TextStyles.f16(context).fontSize,
                        ),
                      ),
                  ],
                ),
              )
            : null,
        hint: widget.hint != null
            ? Text(
                widget.hint!,
                style: TextStyles.f12(
                  context,
                ).colorWith(textFieldColors.hintColor),
              )
            : null,
        prefixIcon: widget.prefixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(textFieldColors.borderRadius),
          borderSide: BorderSide(color: textFieldColors.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(textFieldColors.borderRadius),
          borderSide: BorderSide(color: textFieldColors.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(textFieldColors.borderRadius),
          borderSide: BorderSide(color: textFieldColors.focusedBorderColor),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      focusNode: widget.focus,
      style: widget.textStyle ?? TextStyles.f14(context),
      textAlign: widget.textAlign,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      autofocus: widget.autoFocus,
      enabled: widget.enabled,
      onChanged: widget.onChanged,
      cursorColor:
          widget.cursorColor ??
          Theme.of(context).textSelectionTheme.cursorColor,
      readOnly: widget.readOnly,
      maxLength: widget.maxLength,
      autofillHints: widget.autoFillHints,
      scrollPadding: widget.scrollPadding ?? const EdgeInsets.all(20),
      cursorWidth: widget.cursorWidth ?? 2.0,
      cursorHeight: widget.cursorHeight,
      cursorRadius: const Radius.circular(4),
      onTap: widget.onTap,
      buildCounter: widget.buildCounter,
      scrollPhysics: const BouncingScrollPhysics(),
      enableInteractiveSelection: true,
      inputFormatters: widget.inputFormatters,
      textAlignVertical: widget.textAlignVertical,
      expands: widget.expands,
      showCursor: widget.showCursor,
      selectionControls:
          widget.selectionControls ?? MaterialTextSelectionControls(),
      strutStyle: widget.strutStyle,
      obscuringCharacter: widget.obscuringCharacter,
      initialValue: widget.initialValue,
      keyboardAppearance: widget.keyboardAppearance,
      contextMenuBuilder: widget.contextMenuBuilder,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.title != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title!,
            style: widget.titleTextStyle ?? TextStyles.f16(context),
          ),
          SizedBox(height: widget.spacingBetweenTitleAndTextFormField),
          textFormFieldWidget(),
        ],
      );
    }

    return textFormFieldWidget();
  }
}
