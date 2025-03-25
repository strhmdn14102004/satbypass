import "package:jiffy/jiffy.dart";
import "package:sasat_toko/helper/formats.dart";

class Performance {
  Jiffy? date;
  int achieved = 0;
  int missed = 0;

  Performance parse(Map<String, dynamic> json) {
    date = Formats.tryParseJiffy(json["date"]);
    achieved = Formats.tryParseNumber(json["achieved"]).toInt();
    missed = Formats.tryParseNumber(json["missed"]).toInt();

    return this;
  }
}
