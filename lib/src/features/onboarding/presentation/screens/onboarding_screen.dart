import 'package:finance_assistent/src/core/utils/const/sizes.dart';
import 'package:finance_assistent/src/core/utils/extensions/text_ex.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../core/config/theme/app_color/color_palette.dart';
import '../../../../core/config/theme/styles/styles.dart';
import '../../../../core/gen/app_assets.dart';
import '../../../../core/utils/const/app_strings.dart';
import '../../../../core/view/component/base/button.dart';
import '../../../../core/view/component/base/safe_scaffold.dart';
import '../components/onboarding_page_view.dart';
import '../cubits/onboarding_cubit.dart';
import '../cubits/onboarding_state.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnboardingCubit(),
      child: BlocConsumer<OnboardingCubit, OnboardingState>(
        listener: (context, state) {},
        builder: (context, state) {
          final cubit = context.read<OnboardingCubit>();
          return SafeScaffold(
            body: Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: cubit.pageController,
                    children: [
                      OnboardingPageView(
                        image: AppAssets.ASSETS_IMAGES_ONBOARDING_PNG,
                        title: AppStrings.onboardingText1,
                        cubit: cubit,
                      ),
                      OnboardingPageView(
                        image: AppAssets.ASSETS_IMAGES_ONBOARDING_PNG,
                        title: AppStrings.onboardingText2,
                        cubit: cubit,
                      ),
                      OnboardingPageView(
                        image: AppAssets.ASSETS_IMAGES_ONBOARDING_PNG,
                        title: AppStrings.onboardingText3,
                        cubit: cubit,
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Sizes.paddingH16,
                    vertical: Sizes.paddingV40,
                  ),
                  child: AppButton(
                    onPressed: () {},
                    type: AppButtonType.primary,
                    child: Text(
                      AppStrings.getStarted,
                      style: TextStyles.f14(
                        context,
                      ).colorWith(ColorPalette.white),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
