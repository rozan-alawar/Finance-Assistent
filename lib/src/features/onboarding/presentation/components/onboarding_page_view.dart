import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../core/config/theme/app_color/color_palette.dart';
import '../../../../core/config/theme/styles/styles.dart';
import '../../../../core/utils/const/sizes.dart';
import '../../../../core/view/component/base/image.dart';
import '../cubits/onboarding_cubit.dart';

class OnboardingPageView extends StatelessWidget {
  const OnboardingPageView({
    super.key,
    required this.image,
    required this.title,
    required this.cubit,
  });

  final String image, title;
  final OnboardingCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.screenPaddingH16,
          ),
          child: Column(
            children: [
              const SizedBox(height: Sizes.paddingV40),
              // Title
              Text(title, style: TextStyles.f18(context).bold),
              const SizedBox(height: Sizes.paddingV30),
            ],
          ),
        ),

        // Image
        Stack(
          alignment: AlignmentGeometry.bottomCenter,
          children: [
            AppAssetsImage(image, fit: BoxFit.contain, width: double.infinity),
            SmoothPageIndicator(
              controller: cubit.pageController,
              count: 3,
              onDotClicked: cubit.dotNavigationClick,
              effect: CustomizableEffect(
                activeDotDecoration: DotDecoration(
                  width: 27,
                  height: 4,
                  color: ColorPalette.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
                dotDecoration: DotDecoration(
                  width: 16,
                  height: 4,
                  color: ColorPalette.coldGray30,
                  borderRadius: BorderRadius.circular(2),
                ),
                spacing: 8,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
