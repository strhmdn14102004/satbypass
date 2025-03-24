import "package:equatable/equatable.dart";

class SignUpEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SignUpSubmit extends SignUpEvent {
  final String username;
  final String password;
  final String fullName;
  final String address;
  final String phoneNumber;

  SignUpSubmit({
    required this.username,
    required this.password,
    required this.fullName,
    required this.address,
    required this.phoneNumber,
  });

  @override
  List<Object?> get props => [username, password, fullName, address, phoneNumber];
}
