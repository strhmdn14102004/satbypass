class HistorytransactionResponse {
  List<HistoryTransactionItem> data;

  HistorytransactionResponse({
    required this.data,
  });

  factory HistorytransactionResponse.fromJson(Map<String, dynamic> json) =>
      HistorytransactionResponse(
        data: List<HistoryTransactionItem>.from(
          json["data"].map((x) => HistoryTransactionItem.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class HistoryTransactionItem {
  String id;
  String userId;
  String itemType;
  String itemId;
  String itemName;
  int price;
  String status;
  DateTime createdAt;
  int v;
  String? paymentUrl;

  HistoryTransactionItem({
    required this.id,
    required this.userId,
    required this.itemType,
    required this.itemId,
    required this.itemName,
    required this.price,
    required this.status,
    required this.createdAt,
    required this.v,
    this.paymentUrl,
  });

  factory HistoryTransactionItem.fromJson(Map<String, dynamic> json) =>
      HistoryTransactionItem(
        id: json["_id"] ?? "",
        userId: json["userId"] ?? "",
        itemType: json["itemType"] ?? "",
        itemId: json["itemId"] ?? "",
        itemName: json["itemName"] ?? "",
        price: json["price"] ?? 0,
        status: json["status"] ?? "unknown",
        createdAt: json["createdAt"] != null
            ? DateTime.parse(json["createdAt"])
            : DateTime.now(),
        v: json["__v"] ?? 0,
        paymentUrl: json["paymentUrl"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "itemType": itemType,
        "itemId": itemId,
        "itemName": itemName,
        "price": price,
        "status": status,
        "createdAt": createdAt.toIso8601String(),
        "__v": v,
        "paymentUrl": paymentUrl,
      };
}
