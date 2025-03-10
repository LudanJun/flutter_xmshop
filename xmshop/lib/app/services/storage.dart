import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  //设置添加数据
  static setData(String key, dynamic value) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  //获取存储数据
  static getData(String key) async {
    //本地存储不存在抛出异常
    try {
      var prefs = await SharedPreferences.getInstance();
      String? tempData = prefs.getString(key);
      //如果没有数据 返回空
      if (tempData != null) {
        return json.decode(tempData!);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  //移除存储的数据
  static removeData(String key) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  //清空数据
  static clear(String key) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
