// ignore_for_file: always_specify_types, empty_constructor_bodies

import "package:flutter_bloc/flutter_bloc.dart";
import "package:sasat_toko/module/account/account_event.dart";
import "package:sasat_toko/module/account/account_state.dart";

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  AccountBloc() : super(AccountInitial()) {}
}
