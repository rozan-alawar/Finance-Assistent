import 'package:flutter/cupertino.dart';

import '../../../core/gen/app_assets.dart';
import '../../../core/utils/const/sizes.dart';
import '../../../core/view/component/base/image.dart';



enum TabItem {
  home(
    AppAssets.ASSETS_ICONS_NAV_HOME_SVG,
    AppAssets.ASSETS_ICONS_NAV_HOME_FILLED_SVG,
  ),
  budget(
    AppAssets.ASSETS_ICONS_NAV_BUDGET_SVG,
    AppAssets.ASSETS_ICONS_NAV_BUDGET_FILLED_SVG,
  ),
  reminder(
    AppAssets.ASSETS_ICONS_NAV_REMINDER_SVG,
    AppAssets.ASSETS_ICONS_NAV_REMINDER_FILLED_SVG,
  ),
  profile(
    AppAssets.ASSETS_ICONS_NAV_PROFILE_SVG,
    AppAssets.ASSETS_ICONS_NAV_PROFILE_FILLED_SVG,
  );

  const TabItem(this._iconPath, this._selectedIconPath);

  final String _iconPath;
  final String _selectedIconPath;

  Widget get icon => svg(_iconPath);
  Widget get selectedIcon => svg(_selectedIconPath);

  String getTabItemLabel(BuildContext context) {
    return switch (this) {
      TabItem.home => "Home",
      TabItem.budget => "Budget",
      TabItem.reminder => "Reminder",
      TabItem.profile => "Profile",

    };
  }

  AppAssetsSvg svg(String path) => AppAssetsSvg(
    path,
    height: Sizes.navBarIconR24,
    width: Sizes.navBarIconR24,
    fit: BoxFit.scaleDown,
  );
}
