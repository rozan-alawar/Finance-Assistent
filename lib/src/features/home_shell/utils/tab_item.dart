import 'package:flutter/cupertino.dart';

import '../../../core/gen/app_assets.dart';
import '../../../core/utils/const/sizes.dart';
import '../../../core/view/component/base/image.dart';



enum TabItem {
  home(
    AppAssets.ASSETS_ICONS_NAV_HOME_SVG,
    AppAssets.ASSETS_ICONS_NAV_HOME_FILLED_SVG,
  ),
  service(
    AppAssets.ASSETS_ICONS_NAV_SERVICE_SVG,
    AppAssets.ASSETS_ICONS_NAV_SERVICE_FILLED_SVG,
  ),
  reminder(
    AppAssets.ASSETS_ICONS_NAV_REMINDER_SVG,
    AppAssets.ASSETS_ICONS_NAV_REMINDER_FILLED_SVG,
  ),
  budget(
    AppAssets.ASSETS_ICONS_NAV_BUDGET_SVG,
    AppAssets.ASSETS_ICONS_NAV_BUDGET_FILLED_SVG,
  );

  const TabItem(this._iconPath, this._selectedIconPath);

  final String _iconPath;
  final String _selectedIconPath;

  Widget get icon => svg(_iconPath);
  Widget get selectedIcon => svg(_selectedIconPath);

  String getTabItemLabel(BuildContext context) {
    return switch (this) {
      TabItem.home => "Home",
      TabItem.service => "Service",
      TabItem.reminder => "Reminder",
      TabItem.budget => "Budget",
    };
  }

  AppAssetsSvg svg(String path) => AppAssetsSvg(
    path,
    height: Sizes.navBarIconR24,
    width: Sizes.navBarIconR24,
    fit: BoxFit.scaleDown,
  );
}
