import 'package:finance_assistent/src/core/config/theme/app_color/extensions_color.dart';
import 'package:finance_assistent/src/features/debts/data/model/debt_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/config/theme/styles/styles.dart';
import '../../../../core/utils/const/sizes.dart';
import '../../../../core/utils/extensions/text_ex.dart';

class DebtListItem extends StatelessWidget {
  final DebtModel model;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const DebtListItem({
    required this.model,
    required this.onDelete,
    required this.onEdit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final commonColors = appCommonUIColors(context);
    final statusColor = _getStatusColor(context, model.status);

    String firstName = model.name.split(' ').first;
    String initials = firstName.length >= 2
        ? firstName[0].toUpperCase() + firstName[1].toLowerCase()
        : firstName[0].toUpperCase();

    return Container(
      padding: const EdgeInsets.all(Sizes.paddingV16),
      margin: const EdgeInsets.only(bottom: Sizes.marginV12),
      decoration: BoxDecoration(
        color: commonColors.white,
        borderRadius: BorderRadius.circular(Sizes.radius16),
        border: Border.all(color: statusColor.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  initials,
                  style: TextStyles.f14(
                    context,
                  ).semiBold.colorWith(statusColor),
                ),
              ),
              const SizedBox(width: Sizes.marginH12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(model.name, style: TextStyles.f14(context).semiBold),
                    Text(
                      "Due: ${model.date}",
                      style: TextStyles.f10(context).neutral80(context),
                    ),
                  ],
                ),
              ),
              _buildActionButton(
                context,
                "assets/icons/delete.svg",
                appSwitcherColors(context).dangerColor,
                onDelete,
              ),
              const SizedBox(width: Sizes.marginH8),
              _buildActionButton(
                context,
                "assets/icons/edit.svg",
                appSwitcherColors(context).neutralColors.shade500,
                onEdit,
              ),
            ],
          ),
          const SizedBox(height: Sizes.marginV12),
          Text(
            model.description ?? "",
            style: TextStyles.f14(context).neutral80(context),
          ),
          const SizedBox(height: Sizes.marginV12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("\$${model.amount}", style: TextStyles.f16(context).bold),
              Container(
                constraints: const BoxConstraints(minWidth: 70),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(Sizes.radius20),
                  border: Border.all(
                    color: statusColor.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  model.status,
                  style: TextStyles.f14(context).bold.colorWith(statusColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String svg,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: SvgPicture.asset(
          svg,
          width: 14,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        ),
      ),
    );
  }

  Color _getStatusColor(BuildContext context, String status) {
    final switcher = appSwitcherColors(context);
    switch (status.toLowerCase().replaceAll(" ", "")) {
      case 'paid':
        return switcher.successColor;
      case 'overdue':
        return switcher.warningColor;
      default:
        return switcher.dangerColor;
    }
  }
}
