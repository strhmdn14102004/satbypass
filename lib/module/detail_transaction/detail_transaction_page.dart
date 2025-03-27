// transaction_detail_page.dart
import "dart:convert";

import "package:base/base.dart";
import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:sasat_toko/api/endpoint/detail_transaction/detail_transaction_response.dart";
import "package:sasat_toko/helper/formats.dart";
import "package:sasat_toko/module/detail_transaction/detail_transaction_bloc.dart";
import "package:sasat_toko/module/detail_transaction/detail_transaction_event.dart";
import "package:sasat_toko/module/detail_transaction/detail_transaction_state.dart";
import "package:sasat_toko/module/payment/payment_page.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:smooth_corner/smooth_corner.dart";

class TransactionDetailPage extends StatefulWidget {
  final String transactionId;

  const TransactionDetailPage({required this.transactionId, super.key});

  @override
  TransactionDetailPageState createState() => TransactionDetailPageState();
}

class TransactionDetailPageState extends State<TransactionDetailPage> {
  bool loading = true;
  Map<String, dynamic>? user;

  @override
  void initState() {
    super.initState();
    loadUserData();
    context
        .read<TransactionDetailBloc>()
        .add(FetchTransactionDetail(widget.transactionId));
  }

  void loadUserData() async {
    user = await getUserData();
    setState(() {});
  }

  Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString("user_data");

    if (userJson != null) {
      return jsonDecode(userJson);
    }

    return {"fullName": "User"};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.onPrimaryContainer(),
      body: SafeArea(
        child: BlocConsumer<TransactionDetailBloc, TransactionDetailState>(
          listener: (context, state) {
            if (state is TransactionDetailLoaded ||
                state is TransactionDetailError) {
              setState(() => loading = false);
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                header(),
                if (loading)
                  Expanded(child: Center(child: BaseWidgets.shimmer()))
                else if (state is TransactionDetailError)
                  Expanded(child: Center(child: Text(state.message)))
                else if (state is TransactionDetailLoaded)
                  _buildBody(state.transaction)
                else
                  Expanded(child: Center(child: BaseWidgets.noData())),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget header() {
    return user == null
        ? BaseWidgets.shimmer()
        : Padding(
            padding: EdgeInsets.only(
              right: Dimensions.size20,
              left: Dimensions.size20,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.turn_left_outlined,
                            color: AppColors.surface(),
                            size: Dimensions.size40,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        SizedBox(
                          width: Dimensions.size15,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                Formats.spell("Detail_transaction".tr()),
                                style: TextStyle(
                                  color: AppColors.surface(),
                                  fontSize: Dimensions.text16,
                                ),
                              ),
                              Text(
                                Formats.spell(
                                  user!["fullName"].toString().toUpperCase(),
                                ),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.surface(),
                                  fontSize: Dimensions.text16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Image.network(
                          Formats.spell(user!["fullName"]),
                          width: Dimensions.size70,
                          height: Dimensions.size70,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            width: Dimensions.size50,
                            height: Dimensions.size50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(Dimensions.size50),
                              color: AppColors.secondaryContainer(),
                              border: Border.all(
                                color: AppColors.onPrimaryContainer(),
                              ),
                            ),
                            child: Text(
                              Formats.initials(
                                Formats.spell(user!["fullName"]),
                              ),
                              style: TextStyle(
                                fontSize: Dimensions.text20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.onPrimaryContainer(),
                              ),
                            ),
                          ),
                          frameBuilder:
                              (context, child, frame, wasSynchronouslyLoaded) {
                            return Container(
                              width: Dimensions.size50,
                              height: Dimensions.size50,
                              decoration: BoxDecoration(
                                color: AppColors.primaryContainer(),
                                borderRadius:
                                    BorderRadius.circular(Dimensions.size50),
                                border: Border.all(
                                  color: AppColors.onPrimaryContainer(),
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(Dimensions.size50),
                                child: child,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: Dimensions.size20),
                  ],
                ),
              ],
            ),
          );
  }

  Widget _buildBody(DetailTransaction transaction) {
    final details = transaction.data.transactionDetails;
    final rawData = transaction.data.rawData;

    return Expanded(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(Dimensions.size20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailSection("Transaction_information".tr(), [
              _buildDetailItem("ID_transaction".tr(), details.idTransaksi),
              _buildDetailItem("Customer".tr(), details.pelanggan),
              _buildDetailItem("Number_phone".tr(), details.noHp),
              _buildDetailItem("Product".tr(), details.produk),
              _buildDetailItem("Price".tr(), details.harga),
              _buildDetailItem("Time".tr(), details.waktu),
              _buildDetailItem("Payment_status".tr(), details.statusTerbaru),
            ]),
            SizedBox(height: Dimensions.size20),
            _buildDetailSection("detail".tr(), [
              _buildDetailItem("Item_type".tr(), rawData.itemType),
              _buildDetailItem("Item_id".tr(), rawData.itemId),
              _buildDetailItem("Item_name".tr(), rawData.itemName),
              _buildDetailItem("status".tr(), rawData.status),
              _buildDetailItem("Created_At".tr(), rawData.createdAt.toString()),
            ]),
            if (rawData.paymentUrl.isNotEmpty) ...[
              SizedBox(height: Dimensions.size20),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentWebViewPage(
                          paymentUrl: rawData.paymentUrl.toString(),
                        ),
                      ),
                    );
                  },
                  child: Text("View_payment".tr()),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> items) {
    return Card(
      margin: EdgeInsets.only(bottom: Dimensions.size20),
      shape: SmoothRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.size15),
        smoothness: 1,
      ),
      color: AppColors.surfaceContainer(),
      child: Padding(
        padding: EdgeInsets.all(Dimensions.size15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: Dimensions.text16,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface(),
              ),
            ),
            SizedBox(height: Dimensions.size10),
            ...items,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Dimensions.size10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: Dimensions.text14,
                color: AppColors.onSurfaceVariant(),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: Dimensions.text14,
                fontWeight: FontWeight.w500,
                color: AppColors.onSurface(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
