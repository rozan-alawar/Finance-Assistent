import 'package:flutter/material.dart';

import '../../config/theme/app_color/color_palette.dart';

enum PaymentStatus { paid, unpaid, overdue }

extension StatusStringExtension on String {
  PaymentStatus get toPaymentStatus {
    switch (toLowerCase()) {
      case 'paid':
        return PaymentStatus.paid;
      case 'unpaid':
        return PaymentStatus.unpaid;
      case 'overdue':
        return PaymentStatus.overdue;
      default:
        return PaymentStatus.unpaid;
    }
  }
}

extension StatusColorExtension on PaymentStatus {
  Color get color {
    switch (this) {
      case PaymentStatus.paid:
        return ColorPalette.paidButtonColor;
      case PaymentStatus.unpaid:
        return ColorPalette.unPaidButtonColor;
      case PaymentStatus.overdue:
        return ColorPalette.overdueButtonColor;
    }
  }
}

extension StatusTextColorExtension on PaymentStatus {
  Color get textColor {
    switch (this) {
      case PaymentStatus.paid:
        return ColorPalette.paidTextColor;
      case PaymentStatus.unpaid:
        return ColorPalette.unPaidTextColor;
      case PaymentStatus.overdue:
        return ColorPalette.overdueTextColor;
    }
  }
}
