import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart'; 
import 'package:finance_assistent/src/core/gen/app_assets.dart';
import 'package:finance_assistent/src/core/config/theme/styles/styles.dart';
import 'package:finance_assistent/src/core/utils/const/sizes.dart';
import 'package:finance_assistent/src/core/view/component/base/image.dart';
import 'package:finance_assistent/src/core/view/component/base/custom_toast.dart';
import 'package:finance_assistent/src/core/services/local_storage/hive_service.dart';
import 'package:finance_assistent/src/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:finance_assistent/src/features/auth/presentation/cubits/auth_state.dart';
import 'package:finance_assistent/src/core/routing/app_route.dart';
import 'package:go_router/go_router.dart';
import '../components/logout_dialog.dart';
import 'package:finance_assistent/src/features/profile/presentation/pages/profile_page.dart';

class AccountingPage extends StatefulWidget {
  const AccountingPage({super.key});
  @override
  State<AccountingPage> createState() => _AccountingPageState();
}

class _AccountingPageState extends State<AccountingPage> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  
  Future<void> _loadThemeMode() async {
    final isDark = HiveService.get(
      HiveService.settingsBoxName,
      'is_dark_mode',
      defaultValue: false,
    ) as bool;
    setState(() {
      _isDarkMode = isDark;
    });
  }

  
  Future<void> _confirmLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => LogoutDialog(),
    );

    if (shouldLogout != true) return;
    if (!mounted) return;
    
    await context.read<AuthCubit>().logout();
    
    if (!mounted) return;
    CustomToast.showSuccessMessage(context, 'Logged out successfully');
    const LoginRoute().go(context);
  }

  @override
  Widget build(BuildContext context) {

    final authState = context.watch<AuthCubit>().state;
    final user = authState is AuthSuccess ? authState.user : null;

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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      
                      Text(
                        user?.fullName ?? 'Guest User', 
                        style: TextStyles.f18(context).bold,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      
                      Text(
                        user?.email ?? '',
                        style: TextStyles.f12(
                          context,
                        ).medium.copyWith(color: Colors.grey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
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
                context.push(const ProfileRoute().location); 
               
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
              onSwitchChanged: (value) async {
                setState(() {
                  _isDarkMode = value;
                });
           
                await HiveService.put(
                  HiveService.settingsBoxName,
                  'is_dark_mode',
                  value,
                );
              },
            ),

            _buildSettingItem(
              context,
              icon: Icons.logout_rounded,
              iconColor: const Color(0xFFD32F2F),
              bgColor: const Color(0xFFFFEBEE),
              title: 'Log Out',
              hasArrow: false,
              onTap: _confirmLogout, 
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
                  activeThumbColor: Colors.white,
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