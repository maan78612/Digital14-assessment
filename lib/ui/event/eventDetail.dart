import 'package:assessment/constants/app_constants.dart';
import 'package:assessment/constants/styles.dart';
import 'package:assessment/model_classes/event_model.dart';
import 'package:assessment/provider/app_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EventDetail extends StatelessWidget {
  Events event;

  EventDetail({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(builder: (context, appProvider, child) {
      return Scaffold(
        appBar: appBar(appProvider),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 20.sp),
              eventImage(event),
              SizedBox(height: 20.h),
              if (event.datetimeLocal != null)
                Text(
                  DateFormat('EEE, dd MMMM y hh:mm aaa')
                      .format(DateTime.parse(event.datetimeLocal!)),
                  style: latoBold.copyWith(
                      fontSize: 20.sp, color: AppConfig.colors.titleColor),
                  textAlign: TextAlign.start,
                ),
              SizedBox(height: 5.h),
              Text(
                event.venue?.name ?? "",
                style: latoRegular.copyWith(
                    fontSize: 14.sp, color: AppConfig.colors.grey),
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
      );
    });
  }

  PreferredSize appBar(AppProvider appProvider) {
    return PreferredSize(
        preferredSize: Size.fromHeight(90.h),
        child: AppBar(
          elevation: 0,
          backgroundColor: AppConfig.colors.whiteColor,
          centerTitle: false,
          leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(Icons.arrow_back_ios,
                color: AppConfig.colors.themeColor, size: 20.sp),
          ),
          title: Text(
            event.title!,
            style: latoBold.copyWith(
                fontSize: 22.sp, color: AppConfig.colors.titleColor),
            textAlign: TextAlign.start,
            maxLines: 2,
          ),
          actions: [
            GestureDetector(
              onTap: () {
                appProvider.tabFavIcon(event);
              },
              child: Padding(
                padding: EdgeInsets.all(8.0.sp),
                child: Icon(Icons.favorite,
                    size: 24.sp,
                    color: appProvider.checkFavEvent(event)
                        ? AppConfig.colors.redColor
                        : AppConfig.colors.grey),
              ),
            ),
          ],
          bottom: PreferredSize(
              preferredSize: Size.fromHeight(10.h),
              child: Divider(
                  color: AppConfig.colors.grey,
                  endIndent: 30.sp,
                  thickness: 1.2.sp,
                  indent: 30.sp)),
        ),
      );
  }

  Widget eventImage(Events? event) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(8.sp),
        child: CachedNetworkImage(
          imageUrl: event!.performers!.first.image!,
          imageBuilder: (context, imageProvider) => Container(
            height: 220.sp,
            decoration: BoxDecoration(
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ),
          ),
          placeholder: (context, url) => CircularProgressIndicator(),
        ));
  }
}
