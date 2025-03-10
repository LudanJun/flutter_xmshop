import './storage.dart';

class UserServices {
  //获取用户信息 加static 可以用类来调用
  static Future<List> getUserInfo() async {
    List? userInfo = await Storage.getData("userinfo");
    if (userInfo != null) {
      return userInfo;
    } else {
      return [];
    }
  }
  //获取用户登录状态
  static Future<bool> getUserLoginState() async{
    List userInfo = await getUserInfo();
    if (userInfo.isNotEmpty && userInfo[0]["username"] != "") {
      return true;
    } else {
      return false;
    }
  }
  //退出登录  移除保存的用户信息
  static  loginOut() async{
    Storage.removeData("userinfo");
  }
}
