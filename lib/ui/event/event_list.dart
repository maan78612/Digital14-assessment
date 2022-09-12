import 'package:assessment/constants/app_constants.dart';
import 'package:assessment/constants/styles.dart';
import 'package:assessment/model_classes/event_model.dart';
import 'package:assessment/provider/app_provider.dart';
import 'package:assessment/ui/event/event_detail.dart';
import 'package:assessment/ui/event/widgets/search_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class EventList extends StatefulWidget {
  const EventList({Key? key}) : super(key: key);

  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<AppProvider>(context, listen: false).getEvents();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(builder: (context, appProvider, child) {
      return ModalProgressHUD(
        inAsyncCall: appProvider.isLoading,
        child: Scaffold(
            backgroundColor: AppConfig.colors.whiteColor,
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(85.h), child: SearchBar()),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 10.sp),
                  Column(
                      children: List.generate(
                          appProvider.events?.events?.length ?? 0, (index) {
                    Events? event = appProvider.events?.events![index];
                    return eventCard(event, appProvider);
                  })),
                  SizedBox(height: 10.sp),
                ],
              ),
            )),
      );
    });
  }
}

Widget eventCard(Events? event, AppProvider appProvider) {
  return InkWell(
    onTap: () {
      Get.to(() => EventDetail(event: event!));
    },
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin:
              EdgeInsets.only(top: 8.sp, left: 8.sp, right: 8.sp, bottom: 4.sp),
          padding: EdgeInsets.symmetric(horizontal: 8.sp),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              (event?.performers ?? "") != ""
                  ? eventImage(event, appProvider)
                  : errorImage(),
              SizedBox(width: 20.w),
              eventInfo(event),
            ],
          ),
        ),
        Divider(color: AppConfig.colors.grey),
      ],
    ),
  );
}

Widget eventInfo(Events? event) {
  return Expanded(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          event?.title ?? "",
          style: latoBold.copyWith(
              fontSize: 14.sp, color: AppConfig.colors.titleColor),
          textAlign: TextAlign.start,
        ),
        SizedBox(height: 5.h),
        Text(
          event?.venue?.name ?? "",
          style: latoRegular.copyWith(
              fontSize: 10.sp, color: AppConfig.colors.grey),
          textAlign: TextAlign.start,
        ),
        SizedBox(height: 5.h),
        if (event!.datetimeLocal != null)
          Text(
            DateFormat('EEE, dd MMMM y hh:mm aaa')
                .format(DateTime.parse(event.datetimeLocal!)),
            style: latoRegular.copyWith(
                fontSize: 10.sp, color: AppConfig.colors.grey),
            textAlign: TextAlign.start,
          ),
      ],
    ),
  );
}

Widget eventImage(Events? event, AppProvider appProvider) {
  double iconSize = 14.sp;
  return Stack(
    clipBehavior: Clip.none,
    children: [
      ClipRRect(
          borderRadius: BorderRadius.circular(8.sp),
          child: CachedNetworkImage(
            imageUrl: event!.performers!.first.image!,
            imageBuilder: (context, imageProvider) => Container(
              width: 50.sp,
              height: 50.sp,
              decoration: BoxDecoration(
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => errorImage(),
          )),
      if (appProvider.checkFavEvent(event))
        Positioned(
            left: -iconSize / 2.sp,
            top: -iconSize / 2.sp,
            child: Container(
              decoration: BoxDecoration(
                  color: AppConfig.colors.whiteColor,
                  borderRadius: BorderRadius.all(Radius.circular(20.sp))),
              padding: EdgeInsets.all(1.sp),
              child: GestureDetector(
                onTap: () {
                  appProvider.tabFavIcon(event);
                },
                child: Icon(Icons.favorite,
                    size: iconSize, color: AppConfig.colors.redColor),
              ),
            ))
    ],
  );
}

Widget errorImage() {
  return Padding(
    padding: EdgeInsets.all(5.sp),
    child: Image.asset(
      AppConfig.images.noImage,
      fit: BoxFit.contain,
      width: 50.sp,
      height: 50.sp,
    ),
  );
}
