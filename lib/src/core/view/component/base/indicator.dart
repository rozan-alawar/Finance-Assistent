import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingAppIndicator extends StatelessWidget {
  const LoadingAppIndicator({
    super.key,
    this.size = 24,
    this.indicatorColor,
  });
  final double size;
  final Color? indicatorColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: size,
        width: size,
        child: Platform.isAndroid
            ? CupertinoActivityIndicator(
          color: indicatorColor,
        )
            : CupertinoActivityIndicator(
          color: indicatorColor,
        ),
      ),
    );
  }
}
