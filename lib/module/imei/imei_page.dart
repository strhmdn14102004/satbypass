import "package:base/base.dart";
import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:sasat_toko/api/endpoint/imei/imei.dart";
import "package:sasat_toko/module/imei/imei_bloc.dart";
import "package:sasat_toko/module/imei/imei_event.dart";
import "package:sasat_toko/module/imei/imei_state.dart";
import "package:smooth_corner/smooth_corner.dart";

class ImeiPage extends StatefulWidget {
  const ImeiPage({super.key});

  @override
  ImeiPageState createState() => ImeiPageState();
}

class ImeiPageState extends State<ImeiPage> {
  bool loading = false;
  List<ImeiModel>? imeiList;

  @override
  void initState() {
    super.initState();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ImeiBloc, ImeiState>(
      listener: (context, state) {
        if (state is ImeiLoadLoading) {
          setState(() {
            loading = true;
            imeiList = null;
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
        appBar: AppBar(title: Text("imei_price".tr())),
        body: body(),
      ),
    );
  }

  void refresh() {
    context.read<ImeiBloc>().add(LoadImei());
  }

  Widget body() {
    if (loading) {
      return BaseWidgets.shimmer();
    } else {
      if (imeiList != null && imeiList!.isNotEmpty) {
        return Padding(
          padding: EdgeInsets.all(Dimensions.size20),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
            ),
            itemCount: imeiList!.length,
            itemBuilder: (context, index) {
              final item = imeiList![index];
              return IntrinsicHeight(
                child: InkWell(
                  onTap: () {},
                  customBorder: SmoothRectangleBorder(
                    borderRadius: BorderRadius.circular(Dimensions.size15),
                    smoothness: 1,
                  ),
                  child: Card(
                    color: AppColors.onSecondaryContainer(),
                    shape: SmoothRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimensions.size15),
                      smoothness: 1,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(Dimensions.size20),
                      child: Column(
                        mainAxisSize:
                            MainAxisSize.min, // Menyesuaikan tinggi dengan isi
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.phone_android_rounded,
                            color: AppColors.surface(),
                            size: Dimensions.size50,
                          ),
                          SizedBox(height: Dimensions.size5),
                          Text(
                            item.name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.surface(),
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
                              color: AppColors.surface(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      } else {
        return imeiList == null
            ? BaseWidgets.loadingFail()
            : BaseWidgets.noData();
      }
    }
  }
}
