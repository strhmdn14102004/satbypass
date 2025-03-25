// ignore_for_file: always_put_required_named_parameters_first

import "dart:convert";

import "package:base/base.dart";
import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:sasat_toko/api/endpoint/create_transcation/create_transaction.dart";
import "package:sasat_toko/helper/formats.dart";
import "package:sasat_toko/module/create_transaction/create_transaction_bloc.dart";
import "package:sasat_toko/module/create_transaction/create_transaction_event.dart";
import "package:sasat_toko/module/create_transaction/create_transaction_state.dart";
import "package:sasat_toko/module/payment/payment_page.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:smooth_corner/smooth_corner.dart";

class TransactionPage extends StatefulWidget {
  final String itemId;
  final String name;
  final String itemType;
  final double price;

  const TransactionPage({
    super.key,
    required this.itemId,
    required this.itemType,
    required this.name,
    required this.price,
  });

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  bool isLoading = false;
  Map<String, dynamic>? user;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString("user_data");

    setState(() {
      user = userJson != null ? jsonDecode(userJson) : {"fullName": "User"};
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TransactionBloc(),
      child: Scaffold(
        backgroundColor: AppColors.onPrimaryContainer(),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(Dimensions.size20),
            child: Column(
              children: [
                header(),
                SizedBox(height: Dimensions.size20),
                _body(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget header() {
    return user == null
        ? BaseWidgets.shimmer()
        : Padding(
            padding: EdgeInsets.only(right: Dimensions.size20),
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
                                Formats.spell("Pembayaran".tr()),
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

  Widget _body() {
    return BlocConsumer<TransactionBloc, TransactionState>(
      listener: (context, state) {
        if (state is TransactionLoading) {
          setState(() => isLoading = true);
        } else {
          setState(() => isLoading = false);
        }

        if (state is TransactionSuccess) {
          final paymentUrl = state.paymentUrl;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentWebViewPage(paymentUrl: paymentUrl),
            ),
          );
          BaseOverlays.success(message: state.message);

          Navigator.pop(context);
        } else if (state is TransactionFailure) {
          BaseOverlays.error(message: state.error);
        }
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Detail_transaksi".tr(),
              style: TextStyle(
                color: AppColors.surface(),
                fontWeight: FontWeight.bold,
                fontSize: Dimensions.text16,
              ),
            ),
            SizedBox(height: Dimensions.size15),
            _detailPembelian(),
            SizedBox(height: Dimensions.size35),
            _submitButton(context),
          ],
        );
      },
    );
  }

  Widget _detailPembelian() {
    return Container(
      padding: EdgeInsets.all(Dimensions.size20),
      decoration: ShapeDecoration(
        shape: SmoothRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.size20),
          side: BorderSide(
            color: AppColors.onPrimaryContainer(),
            width: 1.5,
          ),
        ),
        color: AppColors.primaryContainer(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _detailRow("name_item".tr(), widget.name),
          SizedBox(height: Dimensions.size10),
          _detailRow(
            "price".tr(),
            NumberFormat.currency(locale: "id", symbol: "Rp ")
                .format(widget.price),
          ),
        ],
      ),
    );
  }

  Widget _submitButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: isLoading
            ? null
            : () {
                final transaction = CreateTransaction(
                  itemType: widget.itemType,
                  itemId: widget.itemId,
                );
                context
                    .read<TransactionBloc>()
                    .add(CreateTransactionEvent(transaction));
              },
        child:
            isLoading ? BaseWidgets.shimmer() : Text("Create_transaction".tr()),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text(label), Text(value)],
    );
  }
}
