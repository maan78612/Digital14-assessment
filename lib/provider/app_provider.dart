import 'dart:convert';

import 'package:assessment/constants/app_constants.dart';
import 'package:assessment/hive/hive_services.dart';
import 'package:assessment/model_classes/error_response.dart';
import 'package:assessment/model_classes/event_model.dart';
import 'package:assessment/utilities/api_functions.dart';
import 'package:assessment/utilities/show_message.dart';
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

  Future<void> tabFavIcon(Events event) async {
    bool checkFav = checkFavEvent(event);
    if (checkFav) {
      await removeFav(event);
    } else {
      await addFav(event);
    }

    notifyListeners();
  }

  Future<void> addFav(Events event) async {
    ShowMessage.snackBar(
        "Added to Favorite", "This Event has been added to favorite", false);

    favoriteEvents.add(event);
    await insertFavoriteToHive();
  }

  Future<void> removeFav(Events event) async {
    ShowMessage.snackBar("Removed from Favorite",
        "This Event has been removed from favorite", false);

    favoriteEvents.removeWhere((element) => element.id == event.id);
    await insertFavoriteToHive();
  }

  Future<void> insertFavoriteToHive() async {
    await HiveServices.insertString(
        HiveServices.favoriteList, (json.encode(favoriteEvents)));
    await getFavoriteList();
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

  Future<void> getFavoriteList() async {
    String? favHiveData =
        await HiveServices.getString(HiveServices.favoriteList);
    if (favHiveData != null) {
      print("Get hive data");
      print(json.decode(favHiveData).toString());
      favoriteEvents = List<Events>.from(
          json.decode(favHiveData).map((model) => Events.fromJson(model)));

      print(
          "length of Favorite Events items from hive is ${favoriteEvents.length}");
    }
  }
}
