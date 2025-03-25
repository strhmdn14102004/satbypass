import "package:base/base.dart";
import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:sasat_toko/api/endpoint/bypass/bypass_response.dart";
import "package:sasat_toko/module/bypass/bypass_bloc.dart";
import "package:sasat_toko/module/bypass/bypass_event.dart";
import "package:sasat_toko/module/bypass/bypass_state.dart";
import "package:smooth_corner/smooth_corner.dart";

class BypassPage extends StatefulWidget {
  const BypassPage({super.key});

  @override
  BypassPageState createState() => BypassPageState();
}

class BypassPageState extends State<BypassPage> {
  bool loading = false;
  List<BypassModel>? bypassList;

  @override
  void initState() {
    super.initState();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BypassBloc, BypassState>(
      listener: (context, state) {
        if (state is BypassLoadLoading) {
          setState(() {
            loading = true;
            bypassList = null;
          });
        } else if (state is BypassLoadSuccess) {
          bypassList = state.bypassList;
          setState(() {});
        } else if (state is BypassLoadFinished) {
          setState(() {
            loading = false;
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text("bypass_price".tr())),
        body: body(),
      ),
    );
  }

  void refresh() {
    context.read<BypassBloc>().add(LoadBypass());
  }

  Widget body() {
    if (loading) {
      return BaseWidgets.shimmer();
    } else {
      if (bypassList != null && bypassList!.isNotEmpty) {
        return Padding(
          padding: EdgeInsets.all(Dimensions.size20),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
            ),
            itemCount: bypassList!.length,
            itemBuilder: (context, index) {
              final item = bypassList![index];
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
        return bypassList == null
            ? BaseWidgets.loadingFail()
            : BaseWidgets.noData();
      }
    }
  }
}
