import "package:sasat_toko/helper/formats.dart";
import "package:jiffy/jiffy.dart";

class BillingResponse {
  int amount = 0;
  int unpaid = 0;
  List<History> histories = [];

  BillingResponse parse(Map<String, dynamic> json) {
    amount = Formats.tryParseNumber(json["amount"]).toInt();
    unpaid = Formats.tryParseNumber(json["unpaid"]).toInt();
    histories = json["histories"] != null ? List<History>.from(json["histories"].map((x) => History().parse(x))) : [];

    return this;
  }
}

class History {
  Jiffy? date;
  int amount = 0;

  History parse(Map<String, dynamic> json) {
    date = Formats.tryParseJiffy(json["date"]);
    amount = Formats.tryParseNumber(json["amount"]).toInt();

    return this;
  }
}
