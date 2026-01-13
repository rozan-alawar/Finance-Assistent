import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(OnboardingInitial());

  final PageController pageController = PageController();
  int currentPageIndex = 0;

  void nextPage() {
    if (currentPageIndex < 2) {
      currentPageIndex++;
      pageController.animateToPage(
        currentPageIndex,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void onPageChanged(int pageIndex) {
    currentPageIndex = pageIndex;
    emit(PageChangedState(currentPageIndex));
  }

  void dotNavigationClick(int pageIndex) {
    currentPageIndex = pageIndex;
    pageController.animateToPage(
      currentPageIndex,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _completeOnboarding() {
    //_appSettings.setOutBoardingViewed();
    emit(OnboardingFinished());
  }
}
