// ignore_for_file: library_private_types_in_public_api

import "dart:convert";

import "package:base/base.dart";
import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:sasat_toko/helper/formats.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:webview_flutter/webview_flutter.dart";

class PaymentWebViewPage extends StatefulWidget {
  final String paymentUrl;

  const PaymentWebViewPage({required this.paymentUrl, super.key});

  @override
  _PaymentWebViewPageState createState() => _PaymentWebViewPageState();
}

class _PaymentWebViewPageState extends State<PaymentWebViewPage> {
  late final WebViewController _controller;
  bool isLoading = true;
  Map<String, dynamic>? user;
  @override
  void initState() {
    super.initState();
    _loadUserData();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) {
            setState(() {
              isLoading = false;
            });

            if (url.contains("payment_success")) {
              Navigator.pop(
                context,
                true,
              );
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
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
    return Scaffold(
      // backgroundColor: AppColors.onPrimaryContainer(),
      body: SafeArea(
        child: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (isLoading)
              Center(
                child: BaseWidgets.shimmer(),
              ),
          ],
        ),
      ),
    );
    
  }

  Widget header() {
    return user == null
        ? BaseWidgets.shimmer()
        : Padding(
            padding: EdgeInsets.only(
              left: Dimensions.size20,
              right: Dimensions.size20,
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
}
