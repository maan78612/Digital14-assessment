import 'package:assessment/constants/app_constants.dart';
import 'package:assessment/constants/styles.dart';
import 'package:assessment/provider/text_form_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SearchBar extends StatefulWidget {
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TextFormProvider>(
        builder: (context, textFormProvider, child) {
      return Container(
        color: AppConfig.colors.themeColor,
        padding:
            EdgeInsets.only(top: MediaQuery.of(context).padding.top, left: 8.sp, right: 8.sp, bottom: 12.sp),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                // autofocus: true,
                style: latoRegular.copyWith(
                    fontSize: 16.sp, color: AppConfig.colors.whiteColor),
                controller: textFormProvider.textEditingController,
                decoration: InputDecoration(
                  hintText: 'Search for events',
                  filled: true,
                  hintStyle: latoBold.copyWith(
                      fontSize: 16.sp, color: AppConfig.colors.grey),
                  fillColor: AppConfig.colors.fillColor,
                  suffixIcon: (textFormProvider.searchField.isNotEmpty)
                      ? GestureDetector(
                          onTap: () {
                            textFormProvider.clearSearchText();
                          },
                          child: Icon(
                            Icons.cancel,
                            color: AppConfig.colors.whiteColor,
                            size: 14.sp,
                          ),
                        )
                      : null,
                  contentPadding: const EdgeInsets.all(0.0),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.sp)),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.sp)),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.sp)),
                    borderSide:
                        BorderSide(color: AppConfig.colors.enableBorderColor),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.sp)),
                    borderSide:
                        BorderSide(color: AppConfig.colors.fieldBorderColor),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    borderSide:
                        BorderSide(color: AppConfig.colors.fieldBorderColor),
                  ),
                  prefixIcon: Image.asset(
                    AppConfig.images.search,
                    scale: 3.sp,
                    width: 13.w,
                    height: 13.h,
                    fit: BoxFit.scaleDown,
                    color: AppConfig.colors.whiteColor,
                  ),
                ),
                textInputAction: TextInputAction.search,
                cursorColor: AppConfig.colors.whiteColor,
                onChanged: (val) {
                  textFormProvider.search();
                },
                onEditingComplete: () {
                  textFormProvider.onEditComplete();
                },
              ),
            ),
            TextButton(
                onPressed: () {
                  textFormProvider.clearSearchText();
                },
                child: Text(
                  "Cancel",
                  style: latoRegular.copyWith(
                      fontSize: 14.sp, color: AppConfig.colors.whiteColor),
                ))
          ],
        ),
      );
    });
  }
}
