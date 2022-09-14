import 'package:hive/hive.dart';

class HiveServices {
  static String boxName = "Digital14";
  static String favoriteList = "favoriteList";
  static var digital14HiveBox;

  static openBox(String boxName) async {
    digital14HiveBox = await Hive.openBox(boxName);
  }

  static insertString(String key, String value) async {
    deleteString(key);
    digital14HiveBox.put(key, value);
  }

  static Future<String?> getString(String key) async {
    return digital14HiveBox.get(key);
  }

  static deleteString(String key) async {
    digital14HiveBox.delete(key);
  }
}
