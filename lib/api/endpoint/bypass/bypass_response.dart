class BypassModel {
  final String id;
  final String name;
  final int price;

  BypassModel({required this.id, required this.name, required this.price});

  factory BypassModel.fromJson(Map<String, dynamic> json) {
    return BypassModel(
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      price: json["price"] ?? "",
    );
  }
}
