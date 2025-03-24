import "package:sasat_toko/helper/formats.dart";

class TicketSummaryResponse {
  int? open;
  int? assigned;
  int? inProgress;
  int? readyToClose;
  int? closed;

  TicketSummaryResponse parse(Map<String, dynamic> json) {
    open = Formats.tryParseNumber(json["open"]).toInt();
    assigned = Formats.tryParseNumber(json["assigned"]).toInt();
    inProgress = Formats.tryParseNumber(json["inProgress"]).toInt();
    readyToClose = Formats.tryParseNumber(json["readyToClose"]).toInt();
    closed = Formats.tryParseNumber(json["closed"]).toInt();

    return this;
  }
}