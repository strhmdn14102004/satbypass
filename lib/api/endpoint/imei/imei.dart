class ImeiModel {
  final String id;
  final String name;
  final int price;

  ImeiModel({required this.id, required this.name, required this.price});

  factory ImeiModel.fromJson(Map<String, dynamic> json) {
    return ImeiModel(
      id: json["_id"],
      name: json["name"],
      price: json["price"],
    );
  }
}
