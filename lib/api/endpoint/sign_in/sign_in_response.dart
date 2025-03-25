
class SignInResponse {
    String message;
    String token;
    User user;

    SignInResponse({
        required this.message,
        required this.token,
        required this.user,
    });

    factory SignInResponse.fromJson(Map<String, dynamic> json) => SignInResponse(
        message: json["message"]??"",
        token: json["token"]??"",
        user: User.fromJson(json["user"]??""),
    );

    Map<String, dynamic> toJson() => {
        "message": message??"",
        "token": token??"",
        "user": user.toJson()??"",
    };
}

class User {
    String id;
    String username;
    String fullName;
    String address;
    String phoneNumber;

    User({
        required this.id,
        required this.username,
        required this.fullName,
        required this.address,
        required this.phoneNumber,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"]??"",
        username: json["username"]??"",
        fullName: json["fullName"]??"",
        address: json["address"]??"",
        phoneNumber: json["phoneNumber"]??"",
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "fullName": fullName,
        "address": address,
        "phoneNumber": phoneNumber,
    };
}
