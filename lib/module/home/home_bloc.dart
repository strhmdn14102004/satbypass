import "package:flutter_bloc/flutter_bloc.dart";
import "package:sasat_toko/module/home/home_event.dart";
import "package:sasat_toko/module/home/home_state.dart";

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeTicketSummaryLoad>((event, emit) async {});
  }
}
