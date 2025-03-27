import "dart:convert";

import "package:base/base.dart";
import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";
import "package:sasat_toko/api/endpoint/imei/imei.dart";
import "package:sasat_toko/helper/formats.dart";
import "package:sasat_toko/module/imei/imei_bloc.dart";
import "package:sasat_toko/module/imei/imei_event.dart";
import "package:sasat_toko/module/imei/imei_state.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:smooth_corner/smooth_corner.dart";

class ImeiPage extends StatefulWidget {
  const ImeiPage({super.key});

  @override
  ImeiPageState createState() => ImeiPageState();
}

class ImeiPageState extends State<ImeiPage> {
  bool loading = false;
  List<ImeiModel>? imeiList;
  List<ImeiModel>? filteredImeiList;
  Map<String, dynamic>? user;
  bool isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadUserData();
    refresh();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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

  void _filterImeiList(String query) {
    if (imeiList == null) {
      return;
    }

    setState(() {
      filteredImeiList = imeiList!
          .where(
            (imei) => imei.name.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    });
  }

  void _toggleSearch() {
    setState(() {
      isSearching = !isSearching;
      if (!isSearching) {
        _searchController.clear();
        filteredImeiList = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ImeiBloc, ImeiState>(
      listener: (context, state) {
        if (state is ImeiLoadLoading) {
          setState(() {
            loading = true;
            imeiList = null;
            filteredImeiList = null;
          });
        } else if (state is ImeiLoadSuccess) {
          imeiList = state.imeiList;
          setState(() {});
        } else if (state is ImeiLoadFinished) {
          setState(() {
            loading = false;
          });
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.onPrimaryContainer(),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(
                bottom: Dimensions.size20,
              ),
              child: Column(
                children: [
                  isSearching ? searchHeader() : header(),
                  body(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void refresh() {
    context.read<ImeiBloc>().add(LoadImei());
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
                                Formats.spell("imei".tr()),
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
                        IconButton(
                          icon: Icon(
                            Icons.search_rounded,
                            color: AppColors.surface(),
                            size: Dimensions.size30,
                          ),
                          onPressed: _toggleSearch,
                        ),
                        SizedBox(width: Dimensions.size10),
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

  Widget searchHeader() {
    return Padding(
      padding: EdgeInsets.only(
        left: Dimensions.size20,
        right: Dimensions.size20,
        top: Dimensions.size10,
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.turn_left_rounded,
              color: AppColors.surface(),
              size: Dimensions.size30,
            ),
            onPressed: _toggleSearch,
          ),
          Expanded(
            child: Container(
              height: Dimensions.size50,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest(),
                borderRadius: BorderRadius.circular(Dimensions.size15),
              ),
              child: Center(
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    hintText: "Search IMEI...",
                    hintStyle: TextStyle(color: AppColors.onSurfaceVariant()),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: Dimensions.size15,
                      vertical: Dimensions.size10,
                    ),
                    isDense: true,
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: AppColors.onSurface(),
                      ),
                      onPressed: () {
                        _searchController.clear();
                        _filterImeiList("");
                      },
                    ),
                  ),
                  style: TextStyle(color: AppColors.onSurface()),
                  onChanged: _filterImeiList,
                ),
              ),
            ),
          ),
          SizedBox(width: Dimensions.size10),
        ],
      ),
    );
  }

  Widget body() {
    if (loading) {
      return BaseWidgets.shimmer();
    } else {
      final displayList = filteredImeiList ?? imeiList;

      if (displayList != null && displayList.isNotEmpty) {
        return Padding(
          padding: EdgeInsets.all(Dimensions.size20),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
              ),
              itemCount: displayList.length,
              itemBuilder: (context, index) {
                final item = displayList[index];
                return InkWell(
                  onTap: () async {
                    context.push(
                      "/transaction/${item.id}",
                      extra: {
                        "name": item.name,
                        "price": item.price,
                        "itemType": "imei",
                      },
                    );
                  },
                  customBorder: SmoothRectangleBorder(
                    borderRadius: BorderRadius.circular(Dimensions.size15),
                    smoothness: 1,
                  ),
                  child: Card(
                    color: AppColors.surfaceContainerLowest(),
                    shape: SmoothRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimensions.size15),
                      smoothness: 1,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(Dimensions.size20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.phone_android_rounded,
                            color: AppColors.primary(),
                            size: Dimensions.size50,
                          ),
                          SizedBox(height: Dimensions.size5),
                          Text(
                            item.name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.onSurface(),
                              fontSize: Dimensions.text18,
                            ),
                          ),
                          SizedBox(height: Dimensions.size3),
                          Text(
                            NumberFormat.currency(locale: "id", symbol: "Rp ")
                                .format(item.price),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: Dimensions.text16,
                              color: AppColors.onSurface(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      } else {
        return displayList == null
            ? BaseWidgets.loadingFail()
            : BaseWidgets.noData();
      }
    }
  }
}
