class SelectOtp {
  String? emailAddress;
  String? phoneNumber;

  SelectOtp parse(Map<String, dynamic> json) {
    emailAddress = json["emailAddress"];
    phoneNumber = json["phoneNumber"];

    return this;
  }
}