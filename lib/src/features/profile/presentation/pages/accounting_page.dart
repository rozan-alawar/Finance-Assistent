import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; 
import 'package:finance_assistent/src/core/gen/app_assets.dart';
import 'package:finance_assistent/src/core/config/theme/styles/styles.dart';
import 'package:finance_assistent/src/core/utils/const/sizes.dart';
import 'package:finance_assistent/src/core/utils/extensions/widget_ex.dart';
import 'package:finance_assistent/src/core/view/component/base/image.dart';
import 'package:finance_assistent/src/core/config/theme/app_color/extensions_color.dart';
import 'package:finance_assistent/src/features/profile/presentation/pages/profile_page.dart';

class AccountingPage extends StatefulWidget {
  const AccountingPage({Key? key}) : super(key: key);
  @override
  State<AccountingPage> createState() => _AccountingPageState();
}

class _AccountingPageState extends State<AccountingPage> {
  bool _isDarkMode = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Accounting & Setting',
          style: TextStyles.f20(context).bold,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: Sizes.marginV20),
            Row(
              children: [
                Container(
                  width: 80,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFE8EAF6),
                        Color(0xFF5C6BC0),
                        Color(0xFF3949AB),
                      ],
                    ),
                  ),
                  child: ClipOval(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: AppAssetsImage(
                        AppAssets.ASSETS_IMAGES_AVATAR_PNG,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ghydaa Ahmed', style: TextStyles.f18(context).bold),
                    const SizedBox(height: 4),
                    Text(
                      'ghydaaahmed@gmail.com',
                      style: TextStyles.f12(
                        context,
                      ).medium.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: Sizes.marginV18),
            Text('General', style: TextStyles.f18(context).bold),
            SizedBox(height: Sizes.marginV32),

            _buildSettingItem(
              context,
              icon: Icons.person_outline,
              iconColor: const Color(0xFFFF4081),
              bgColor: const Color(0xFFFCE4EC),
              title: 'profile',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
            ),
              SizedBox(height: Sizes.marginV18),
            _buildSettingItem(
              context,
              svgIcon:
                  AppAssets.ASSETS_ICONS_VIRTUAL_CURRENCY_SVG, 
              iconColor: const Color(0xFF3F51B5),
              bgColor: const Color(0xFFE8EAF6),
              title: 'Currencies',
            ),

            SizedBox(height: Sizes.marginV24),

            Text('Finances', style: TextStyles.f18(context).bold),
            SizedBox(height: Sizes.marginV16),

            _buildSettingItem(
              context,
              icon: Icons.credit_card_rounded,
              iconColor: const Color(0xFFFF4081),
              bgColor: const Color(0xFFFCE4EC),
              title: 'Payment Methods',
            ),

            SizedBox(height: Sizes.marginV24),

            Text('App Setting', style: TextStyles.f18(context).bold),
            SizedBox(height: Sizes.marginV16),

            _buildSettingItem(
              context,
              icon: Icons.dark_mode_rounded,
              iconColor: Colors.black87,
              bgColor: const Color(0xFFEEEEEE),
              title: 'Dark Mode',
              isSwitch: true,
              switchValue: _isDarkMode,
              onSwitchChanged: (value) {
                setState(() {
                  _isDarkMode = value;
                });
              },
            ),

            _buildSettingItem(
              context,
              icon: Icons.logout_rounded,
              iconColor: const Color(0xFFD32F2F),
              bgColor: const Color(0xFFFFEBEE),
              title: 'Log Out',
              hasArrow: false,
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
  Widget _buildSettingItem(
    BuildContext context, {
    IconData? icon,
    String? svgIcon,
    required Color iconColor,
    required Color bgColor,
    required String title,
    bool hasArrow = true,
    bool isSwitch = false,
    bool switchValue = false,
    ValueChanged<bool>? onSwitchChanged,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        color: Colors.transparent,
        child: Row(
          children: [
            Container(
              width: 45,
              height: 45,
              padding: svgIcon != null
                  ? const EdgeInsets.all(10)
                  : null,
              decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
              child: svgIcon != null
                  ? AppAssetsSvg(svgIcon, color: iconColor)
                  : Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 16),

            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),

            if (isSwitch)
              Transform.scale(
                scale: 0.8,
                child: Switch(
                  value: switchValue,
                  onChanged: onSwitchChanged,
                  activeColor: Colors.white,
                  activeTrackColor: const Color(0xFF3F51B5),
                ),
              )
            else if (hasArrow)
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
