import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static late SharedPreferences sharedPreferences;

  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool> putBoolData(
      {required String key, required bool value}) async {
    return await sharedPreferences.setBool(key, value);
  }

  static dynamic getData({required String key}) {
    return sharedPreferences.get(key);
  }

static List<String> setStringList({required String key}) {
  List<Object?>? data = sharedPreferences.get(key) as List<Object?>?;
  List<String> result = [];
  
  if (data != null) {
    for (var item in data) {
      if (item is String) {
        result.add(item);
      }
    }
  }
  
  return result;
}


  static Future<bool> saveData(
      {required String key, required dynamic value}) async {
    if (value is bool) {
      return await sharedPreferences.setBool(key, value);
    } else if (value is String) {
      return await sharedPreferences.setString(key, value);
    } else if (value is int) {
      return await sharedPreferences.setInt(key, value);
    } else if (value is List<int>) {
      return await sharedPreferences.setStringList(
          key, value.map((e) => e.toString()).toList());
    } else {
      return await sharedPreferences.setDouble(key, value);
    }
  }

  static Future<bool> removeData({required String key}) async {
    return await sharedPreferences.remove(key);
  }

  static Future clearData() {
    return sharedPreferences.clear();
  }
}
