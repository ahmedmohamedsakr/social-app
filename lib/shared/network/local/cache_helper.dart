import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper{
  static late SharedPreferences sharedPreference;

  static init()async=>sharedPreference=await SharedPreferences.getInstance();

   static dynamic getData({required String key}){
    return sharedPreference.get(key);
  }

  static Future <bool> setData({required String key,required dynamic value}){
     if(value is double) {
       return sharedPreference.setDouble(key, value);
     } else if(value is int) {
       return sharedPreference.setInt(key, value);
     }
     else if(value is String) {
       return sharedPreference.setString(key, value);
     }else{
      return sharedPreference.setBool(key, value);
     }
  }
}