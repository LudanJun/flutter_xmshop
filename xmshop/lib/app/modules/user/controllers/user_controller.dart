import 'package:get/get.dart';
import 'package:xmshop/app/models/user_model.dart';
import 'package:xmshop/app/services/userServices.dart';

class UserController extends GetxController {
  //TODO: Implement UserController
  RxBool isLogin = false.obs;
  // RxList userList = [].obs;
  var userInfo = UserModel().obs;

  @override
  void onInit() {
    super.onInit();
    //获取用户信息
    getUserInfo();
  }

  @override
  void onClose() {
    super.onClose();
  }

  getUserInfo() async {
    var tempLoginState = await UserServices.getUserLoginState();
    isLogin.value = tempLoginState;
    var tempList = await UserServices.getUserInfo();
    if (tempList.isNotEmpty) {
      //把请求的数据 转换为 模型
      userInfo.value = UserModel.fromJson(tempList[0]);
      update();
    }
  }
  //退出登录
  loginOut() {
    UserServices.loginOut();
    isLogin.value = false;
    //清空用户模型
    userInfo.value = UserModel();
    update();
  }
}
