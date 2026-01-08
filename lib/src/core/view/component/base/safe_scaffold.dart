import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SafeScaffold extends StatelessWidget {
  const SafeScaffold({
    required this.body,
    this.appBar,
    this.safeTop = true,
    this.safeBottom = true,
    this.extendBodyBehindAppBar = false,
    this.resizeToAvoidBottomInset = true,
    this.bottomNavigationBar,
    this.useGradient = true,
    this.persistentFooterButtons,
    this.color,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.systemUiOverlayStyle,
    super.key,
  });

  final PreferredSizeWidget? appBar;
  final Widget body;
  final bool safeTop;
  final bool safeBottom;
  final bool extendBodyBehindAppBar;
  final bool resizeToAvoidBottomInset;
  final Widget? bottomNavigationBar;
  final bool useGradient;
  final Color? color;
  final List<Widget>? persistentFooterButtons;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final SystemUiOverlayStyle? systemUiOverlayStyle;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultStyle = isDark
        ? SystemUiOverlayStyle.light.copyWith(
            statusBarColor: Colors.transparent,
          )
        : SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.transparent,
          );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemUiOverlayStyle ?? defaultStyle,
      child: Scaffold(
        extendBodyBehindAppBar: extendBodyBehindAppBar,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: appBar,
        body: SafeArea(
          maintainBottomViewPadding: true,
          top: safeTop,
          bottom: safeBottom,
          child: body,
        ),
        bottomNavigationBar: bottomNavigationBar,
        persistentFooterButtons: persistentFooterButtons,
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
      ),
    );
  }
}
