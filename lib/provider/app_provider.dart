import 'package:assessment/constants/app_constants.dart';
import 'package:assessment/model_classes/error_response.dart';
import 'package:assessment/model_classes/event_model.dart';
import 'package:assessment/utilities/api_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppProvider extends ChangeNotifier {
  EventModelClass? events;
  bool isLoading = false;

  void startLoader() {
    isLoading = true;
    notifyListeners();
  }

  void stopLoader() {
    isLoading = false;
    notifyListeners();
  }

/*     API Call For Location */

  Future<void> getEvents({String? parameter}) async {
    startLoader();

    Map<String, dynamic> params = {};
    ApiRequests api = ApiRequests();
    String url = "https://api.seatgeek.com/2/events";
    if (parameter != null) {
      params = {
        "client_id": "MjkwNTM4NjF8MTY2Mjk3NjMzOC4zNTg1Mjg5",
        'q': parameter
      };
    } else {
      params = {"client_id": "MjkwNTM4NjF8MTY2Mjk3NjMzOC4zNTg1Mjg5"};
    }

    print("parameter is ${params}");
    dynamic res = await api.getRequest(url: url, params: params);
    stopLoader();
    notifyListeners();
    if (res is ErrorResponse) {
      print('Error from Api is ${res.errorDescription}');
    } else {
      print("-------- hereeee");
      events = EventModelClass.fromJson(res);
      print("data is ${events?.toJson()}");
      print(" ${events?.events?.length}");
    }
    notifyListeners();
  }

  /*========================= Favorite Events =================================*/

  List<Events> favoriteEvents = [];

  void tabFavIcon(Events event) {
    if (favoriteEvents.contains(event)) {
      removeFav(event);
    } else {
      addFav(event);
    }

    notifyListeners();
  }

  void removeFav(Events event) {
    Get.snackbar("Removed from Favorite", "This Event has been removed from favorite",
        colorText: AppConfig.colors.whiteColor,
        backgroundColor: AppConfig.colors.themeColor);
    favoriteEvents.remove(event);
  }

  void addFav(Events event) {
    Get.snackbar("Added to Favorite", "This Event has been added to favorite",
        colorText: AppConfig.colors.whiteColor,
        backgroundColor: AppConfig.colors.themeColor);
    favoriteEvents.add(event);
  }

  bool checkFavEvent(Events eventToBeChecked) {
    bool isFav = false;

    for (Events event in favoriteEvents) {
      if (eventToBeChecked.id == event.id) {
        isFav = true;
        break;
      }
    }
    return isFav;
  }
}
