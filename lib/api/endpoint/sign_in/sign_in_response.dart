class SignInResponse {
  String message;
  String token;

  SignInResponse({
    required this.message,
    required this.token,
  });

  factory SignInResponse.fromJson(Map<String, dynamic> json) => SignInResponse(
        message: json["message"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "token": token,
      };
}
