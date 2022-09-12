import 'package:assessment/provider/app_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class TextFormProvider extends ChangeNotifier {
  TextEditingController textEditingController = TextEditingController();

  String searchField = "";

  void search() {
    searchField = textEditingController.text.toLowerCase();
    if (kDebugMode) {
      print("search value is $searchField");
    }
    notifyListeners();
  }

  void onEditComplete() {
    if (kDebugMode) {
      print("editing complete");
    }
    FocusManager.instance.primaryFocus?.unfocus();
    Provider.of<AppProvider>(Get.context!, listen: false)
        .getEvents(parameter: searchField);
    notifyListeners();
  }

  void clearSearchText() {
    FocusManager.instance.primaryFocus?.unfocus();
    searchField = "";
    textEditingController.clear();
    Provider.of<AppProvider>(Get.context!, listen: false).getEvents();
    notifyListeners();
  }
}
