// ignore_for_file: always_specify_types, empty_constructor_bodies

import "package:sasat_toko/module/account/account_event.dart";
import "package:sasat_toko/module/account/account_state.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  AccountBloc() : super(AccountInitial()) {}
}
