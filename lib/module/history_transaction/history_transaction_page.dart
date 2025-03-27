import "dart:convert";

import "package:base/base.dart";
import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";
import "package:sasat_toko/helper/formats.dart";
import "package:sasat_toko/module/history_transaction/history_transaction_bloc.dart";
import "package:sasat_toko/module/history_transaction/history_transaction_event.dart";
import "package:sasat_toko/module/history_transaction/history_transaction_state.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:smooth_corner/smooth_corner.dart";

class HistoryTransactionPage extends StatefulWidget {
  const HistoryTransactionPage({super.key});

  @override
  HistoryTransactionPageState createState() => HistoryTransactionPageState();
}

class HistoryTransactionPageState extends State<HistoryTransactionPage>
    with WidgetsBindingObserver {
  Map<String, dynamic>? user;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    loadUserData();
    WidgetsBinding.instance.addObserver(this);
    context.read<HistoryTransactionBloc>().add(FetchHistoryTransaction());
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
    return BlocConsumer<HistoryTransactionBloc, HistoryTransactionState>(
      listener: (context, state) {
        if (state is HistoryTransactionError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: AppColors.inverseSurface(),
            statusBarIconBrightness: AppColors.brightness(),
          ),
          child: Scaffold(
            backgroundColor: AppColors.onPrimaryContainer(),
            body: SafeArea(
              child: Column(
                children: [
                  header(),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        context
                            .read<HistoryTransactionBloc>()
                            .add(FetchHistoryTransaction());
                      },
                      child: buildTransactionList(state),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    setState(() {});
  }

  Widget header() {
    return user == null
        ? BaseWidgets.shimmer()
        : Container(
            padding: EdgeInsets.all(Dimensions.size20),
            color: AppColors.onPrimaryContainer(),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Formats.spell("history_transaction".tr()),
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
                  width: Dimensions.size50,
                  height: Dimensions.size50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: Dimensions.size50,
                    height: Dimensions.size50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.size50),
                      color: AppColors.secondaryContainer(),
                      border: Border.all(
                        color: AppColors.onPrimaryContainer(),
                      ),
                    ),
                    child: Text(
                      Formats.initials(Formats.spell(user!["fullName"])),
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
                        borderRadius: BorderRadius.circular(Dimensions.size50),
                        border: Border.all(
                          color: AppColors.onPrimaryContainer(),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(Dimensions.size50),
                        child: child,
                      ),
                    );
                  },
                ),
              ],
            ),
          );
  }

  Widget buildTransactionList(HistoryTransactionState state) {
    if (state is HistoryTransactionLoading) {
      return Center(child: BaseWidgets.shimmer());
    }

    if (state is HistoryTransactionLoaded) {
      return state.transactions.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BaseWidgets.noData(),
                  SizedBox(height: Dimensions.size10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 120),
                    child: ListTile(
                      onTap: () async {
                        context
                            .read<HistoryTransactionBloc>()
                            .add(FetchHistoryTransaction());
                      },
                      shape: SmoothRectangleBorder(
                        borderRadius: BorderRadius.circular(Dimensions.size20),
                        smoothness: 1,
                        side: BorderSide(color: AppColors.outline()),
                      ),
                      tileColor: AppColors.surfaceContainerHighest(),
                      leading: const Icon(Icons.refresh_rounded),
                      title: Text(
                        "refresh".tr(),
                        style: TextStyle(
                          color: AppColors.onSurface(),
                          fontWeight: FontWeight.bold,
                          fontSize: Dimensions.text18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.only(
                left: Dimensions.size20,
                right: Dimensions.size20,
                bottom: Dimensions.size20,
              ),
              itemCount: state.transactions.length,
              itemBuilder: (context, index) {
                final transaction = state.transactions[index];

                IconData iconData = Icons.shopping_cart;
                if (transaction.itemType == "imei") {
                  iconData = Icons.phone_android_rounded;
                } else if (transaction.itemType == "bypass") {
                  iconData = Icons.security_rounded;
                }

                String formattedPrice = NumberFormat.currency(
                  locale: "id_ID",
                  symbol: "Rp ",
                  decimalDigits: 0,
                ).format(transaction.price);

                String formattedDate =
                    DateFormat("dd MMMM yyyy HH:mm", "id_ID").format(
                  DateTime.parse(transaction.createdAt.toString()).toLocal(),
                );

                Color statusColor;
                switch (transaction.status.toLowerCase()) {
                  case "sukses":
                    statusColor = Colors.green;
                    break;
                  case "pending":
                    statusColor = Colors.orange;
                    break;
                  case "gagal":
                    statusColor = AppColors.error();
                    break;
                  default:
                    statusColor = Colors.grey;
                }

                return Padding(
                  padding: EdgeInsets.only(top: Dimensions.size10),
                  child: InkWell(
                    customBorder: SmoothRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimensions.size15),
                      smoothness: 1,
                    ),
                    onTap: () async {
                      context.pushNamed(
                        "transaction-detail",
                        pathParameters: {"id": transaction.id},
                      );
                    },
                    child: Ink(
                      padding: EdgeInsets.all(Dimensions.size15),
                      decoration: ShapeDecoration(
                        color: AppColors.surface(),
                        shape: SmoothRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(Dimensions.size20),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                iconData,
                                color: AppColors.primary(),
                                size: 24,
                              ),
                              SizedBox(width: Dimensions.size15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          transaction.itemName,
                                          style: TextStyle(
                                            color: AppColors.onSurface(),
                                            fontWeight: FontWeight.bold,
                                            fontSize: Dimensions.text16,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: Dimensions.size4),
                                        Text(
                                          formattedPrice,
                                          style: TextStyle(
                                            fontSize: Dimensions.text14,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.onSurface(),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: Dimensions.size10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          formattedDate,
                                          style: TextStyle(
                                            fontSize: Dimensions.text12,
                                            color: AppColors.onSurfaceVariant(),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: Dimensions.size10,
                                            vertical: Dimensions.size4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: statusColor.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(
                                                Dimensions.size15),
                                          ),
                                          child: Text(
                                            transaction.status,
                                            style: TextStyle(
                                              fontSize: Dimensions.text12,
                                              color: statusColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
    }

    if (state is HistoryTransactionError) {
      return Center(child: BaseWidgets.loadingFail());
    }

    return Center(child: Text("Mulai dengan menarik transaksi..."));
  }
}
