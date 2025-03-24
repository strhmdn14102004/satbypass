import "package:sasat_toko/api/endpoint/home/billing_response.dart";
import "package:sasat_toko/api/endpoint/home/performance.dart";
import "package:sasat_toko/api/endpoint/home/ticket_summary_response.dart";

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeTicketSummaryLoadLoading extends HomeState {}

class HomeTicketSummaryLoadSuccess extends HomeState {
  final TicketSummaryResponse ticketSummaryResponse;

  HomeTicketSummaryLoadSuccess({
    required this.ticketSummaryResponse,
  });
}

class HomeTicketSummaryLoadFinished extends HomeState {}

class HomePerformanceLoadLoading extends HomeState {}

class HomePerformanceLoadSuccess extends HomeState {
  final List<Performance> performances;

  HomePerformanceLoadSuccess({
    required this.performances,
  });
}

class HomePerformanceLoadFinished extends HomeState {}

class HomeBillingLoadLoading extends HomeState {}

class HomeBillingLoadSuccess extends HomeState {
  final BillingResponse billingResponse;

  HomeBillingLoadSuccess({
    required this.billingResponse,
  });
}

class HomeBillingLoadFinished extends HomeState {}
