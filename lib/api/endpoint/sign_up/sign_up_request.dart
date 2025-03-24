class SignUpRequest {
  final String username;
  final String password;
  final String fullName;
  final String address;
  final String phoneNumber;

  SignUpRequest({
    required this.username,
    required this.password,
    required this.fullName,
    required this.address,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "password": password,
      "fullName": fullName,
      "address": address,
      "phoneNumber": phoneNumber,
    };
  }
}
