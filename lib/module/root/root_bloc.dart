import "package:flutter_bloc/flutter_bloc.dart";
import "package:sasat_toko/module/root/root_event.dart";
import "package:sasat_toko/module/root/root_state.dart";

class RootBloc extends Bloc<RootEvent, RootState> {
  RootBloc() : super(RootInitial());
}
