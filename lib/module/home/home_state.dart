abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeTicketSummaryLoadLoading extends HomeState {}

class HomeTicketSummaryLoadSuccess extends HomeState {
  HomeTicketSummaryLoadSuccess();
}

class HomeTicketSummaryLoadFinished extends HomeState {}

class HomePerformanceLoadLoading extends HomeState {}

class HomePerformanceLoadSuccess extends HomeState {
  HomePerformanceLoadSuccess();
}

class HomePerformanceLoadFinished extends HomeState {}

class HomeBillingLoadLoading extends HomeState {}

class HomeBillingLoadSuccess extends HomeState {
  HomeBillingLoadSuccess();
}

class HomeBillingLoadFinished extends HomeState {}
