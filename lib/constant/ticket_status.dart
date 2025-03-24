// ignore_for_file: non_constant_identifier_names, constant_identifier_names

enum TicketStatus {
  OPEN("OPEN"),
  ASSIGNED("ASSIGNED"),
  IN_PROGRESS("IN PROGRESS"),
  READY_TO_CLOSE("READY TO CLOSE"),
  CLOSED("CLOSED");

  final String label;

  const TicketStatus(this.label);
}