class DetailTransaction {
  bool success;
  String message;
  Data data;

  DetailTransaction({
    required this.success,
    required this.message,
    required this.data,
  });

  factory DetailTransaction.fromJson(Map<String, dynamic> json) =>
      DetailTransaction(
        success: json["success"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  TransactionDetails transactionDetails;
  RawData rawData;

  Data({
    required this.transactionDetails,
    required this.rawData,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        transactionDetails:
            TransactionDetails.fromJson(json["transactionDetails"]),
        rawData: RawData.fromJson(json["rawData"]),
      );

  Map<String, dynamic> toJson() => {
        "transactionDetails": transactionDetails.toJson(),
        "rawData": rawData.toJson(),
      };
}

class RawData {
  String id;
  UserId userId;
  String itemType;
  String itemId;
  String itemName;
  int price;
  String status;
  DateTime createdAt;
  int v;
  String paymentUrl;

  RawData({
    required this.id,
    required this.userId,
    required this.itemType,
    required this.itemId,
    required this.itemName,
    required this.price,
    required this.status,
    required this.createdAt,
    required this.v,
    required this.paymentUrl,
  });

  factory RawData.fromJson(Map<String, dynamic> json) => RawData(
        id: json["_id"],
        userId: UserId.fromJson(json["userId"]),
        itemType: json["itemType"],
        itemId: json["itemId"],
        itemName: json["itemName"],
        price: json["price"],
        status: json["status"],
        createdAt: DateTime.parse(json["createdAt"]),
        v: json["__v"],
        paymentUrl: json["paymentUrl"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId.toJson(),
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

class UserId {
  String id;
  String fullName;
  String phoneNumber;

  UserId({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
  });

  factory UserId.fromJson(Map<String, dynamic> json) => UserId(
        id: json["_id"],
        fullName: json["fullName"],
        phoneNumber: json["phoneNumber"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "fullName": fullName,
        "phoneNumber": phoneNumber,
      };
}

class TransactionDetails {
  String idTransaksi;
  String pelanggan;
  String noHp;
  String produk;
  String harga;
  String waktu;
  String empty;
  String statusTerbaru;

  TransactionDetails({
    required this.idTransaksi,
    required this.pelanggan,
    required this.noHp,
    required this.produk,
    required this.harga,
    required this.waktu,
    required this.empty,
    required this.statusTerbaru,
  });

  factory TransactionDetails.fromJson(Map<String, dynamic> json) =>
      TransactionDetails(
        idTransaksi: json["ID Transaksi"],
        pelanggan: json["Pelanggan"],
        noHp: json["No. HP"],
        produk: json["Produk"],
        harga: json["Harga"],
        waktu: json["Waktu"],
        empty: json["------------------------"],
        statusTerbaru: json["Status Terbaru"],
      );

  Map<String, dynamic> toJson() => {
        "ID Transaksi": idTransaksi,
        "Pelanggan": pelanggan,
        "No. HP": noHp,
        "Produk": produk,
        "Harga": harga,
        "Waktu": waktu,
        "------------------------": empty,
        "Status Terbaru": statusTerbaru,
      };
}
