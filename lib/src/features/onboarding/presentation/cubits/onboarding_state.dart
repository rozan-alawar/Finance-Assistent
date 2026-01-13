abstract class OnboardingState {}

class OnboardingInitial extends OnboardingState {}

class PageChangedState extends OnboardingState {
  final int pageIndex;

  PageChangedState(this.pageIndex);
}

class OnboardingFinished extends OnboardingState {}
