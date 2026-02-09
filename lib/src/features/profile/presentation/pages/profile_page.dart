import 'package:flutter/material.dart';
import 'package:finance_assistent/src/core/gen/app_assets.dart';
import 'package:finance_assistent/src/core/config/theme/styles/styles.dart';
import 'package:finance_assistent/src/core/utils/const/sizes.dart';
import 'package:finance_assistent/src/core/utils/extensions/widget_ex.dart';
import 'package:finance_assistent/src/core/view/component/base/image.dart';
import 'package:finance_assistent/src/core/utils/extensions/text_ex.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finance_assistent/src/core/di/dependency_injection.dart';
import 'package:finance_assistent/src/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:finance_assistent/src/features/auth/presentation/cubits/auth_state.dart';
import 'package:finance_assistent/src/features/profile/data/repo/profile_repository.dart';
import 'package:finance_assistent/src/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:finance_assistent/src/features/profile/presentation/cubits/profile_state.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    final isAuthenticated = authState is AuthSuccess;
    final seedUser = authState is AuthSuccess ? authState.user : null;

    if (!isAuthenticated) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text('My profile', style: TextStyles.f20(context).bold),
          centerTitle: true,
        ),
        body: Center(
          child: Text(
            'Please log in to view your profile.',
            style: TextStyles.f16(context).medium,
          ),
        ),
      );
    }

    return BlocProvider(
      create: (_) => ProfileCubit(
        sl<ProfileRepository>(),
        seedUser: seedUser,
      )..loadProfile(showLoading: seedUser == null),
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading || state is ProfileInitial) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Text('My profile', style: TextStyles.f20(context).bold),
                centerTitle: true,
              ),
              body: const Center(child: CircularProgressIndicator()),
            );
          }

          if (state is ProfileFailure) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Text('My profile', style: TextStyles.f20(context).bold),
                centerTitle: true,
              ),
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: TextStyles.f14(context).medium,
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () =>
                            context.read<ProfileCubit>().loadProfile(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          final user = (state as ProfileLoaded).user;

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text('My profile', style: TextStyles.f20(context).bold),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: Sizes.marginV20),
                  Center(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 110,
                              height: 110,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 3),
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
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF3F51B5),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: const AppAssetsSvg(
                                  AppAssets.ASSETS_ICONS_EDIT_SVG,
                                  width: 12,
                                  height: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: Sizes.marginV12),
                        Text(user.fullName, style: TextStyles.f20(context).bold),
                        SizedBox(height: Sizes.marginV4),
                        Text(
                          user.email,
                          style: TextStyles.f14(context)
                              .medium
                              .colorWith(Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: Sizes.marginV32),
                  Text(
                    'profile',
                    style: TextStyles.f18(context).bold,
                  ).paddingSymmetric(horizontal: Sizes.paddingH20),
                  SizedBox(height: Sizes.marginV16),
                  _buildInfoTile(context, 'Full Name', user.fullName),
                  _buildInfoTile(context, 'Email Address', user.email),
                  _buildInfoTile(
                    context,
                    'Phone Number',
                    user.phone?.isNotEmpty == true ? user.phone! : '-',
                  ),
                  SizedBox(height: Sizes.marginV24),
                  Text(
                    'Security',
                    style: TextStyles.f18(context).bold,
                  ).paddingSymmetric(horizontal: Sizes.paddingH20),
                  SizedBox(height: Sizes.marginV12),
                  Column(
                    children: [
                      _buildSecurityItem(
                        context,
                        svgIcon: AppAssets.ASSETS_ICONS_LOCK_SVG,
                        title: 'Change Password',
                        subtitle: 'Last Change 3 months ago',
                      ),
                      _buildSecurityItem(
                        context,
                        svgIcon: AppAssets.ASSETS_ICONS_VIRTUAL_CURRENCY_SVG,
                        title: 'Virtual currency',
                        subtitle: user.defaultCurrency.isNotEmpty
                            ? user.defaultCurrency
                            : 'USD',
                        hasArrow: false,
                        trailing: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey,
                          size: 28,
                        ),
                      ),
                      _buildSecurityItem(
                        context,
                        svgIcon: AppAssets.ASSETS_ICONS_REPORTS_SVG,
                        title: 'Reports',
                      ),
                      _buildSecurityItem(
                        context,
                        iconData: Icons.card_giftcard,
                        title: 'Rewards',
                      ),
                      _buildSecurityItem(
                        context,
                        iconData: Icons.star,
                        title: 'Rate App',
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoTile(BuildContext context, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityItem(
    BuildContext context, {
    required String title,
    String? subtitle,
    String? svgIcon,
    IconData? iconData,
    Widget? trailing,
    bool hasArrow = true,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFFE8EAF6),
              shape: BoxShape.circle,
            ),

            child: svgIcon != null
                ? AppAssetsSvg(svgIcon, color: const Color(0xFF3F51B5))
                : Icon(iconData, color: const Color(0xFF3F51B5), size: 24),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null)
            trailing
          else if (hasArrow)
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    );
  }
}
