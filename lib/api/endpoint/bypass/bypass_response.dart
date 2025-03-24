class BypassResponse {
  String id;
  String name;
  int price;

  BypassResponse({
    required this.id,
    required this.name,
    required this.price,
  });

  factory BypassResponse.fromJson(Map<String, dynamic> json) => BypassResponse(
        id: json["_id"],
        name: json["name"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "price": price,
      };
}
