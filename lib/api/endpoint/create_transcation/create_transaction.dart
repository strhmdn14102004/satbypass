class CreateTransaction {
  final String itemType;
  final String itemId;

  CreateTransaction({
    required this.itemType,
    required this.itemId,
  });

  Map<String, dynamic> toJson() {
    return {
      "itemType": itemType,
      "itemId": itemId,
    };
  }
}
