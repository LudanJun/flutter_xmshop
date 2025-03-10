import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xmshop/app/models/user_model.dart';
import 'package:xmshop/app/modules/address/addressList/controllers/address_list_controller.dart';
import 'package:xmshop/app/services/httpsClient.dart';
import 'package:xmshop/app/services/signServices.dart';
import 'package:xmshop/app/services/userServices.dart';

class AddressAddController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  //保存选择的地址
  RxString area = "".obs;
  HttpsClient httpsClient = HttpsClient();

  AddressListController listController = Get.find<AddressListController>();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
    //销毁的时候更新listController.getAddressList
    listController.getAddressList();
  }

  //获取穿过来的地址信息
  setArea(String str) {
    area.value = str;
    update();
  }

  doAddAddress() async {
    List userList = await UserServices.getUserInfo();
    print(userList);
    UserModel userInfo = UserModel.fromJson(userList[0]);
    //对表单进行校验
    if (nameController.text.length < 2) {
      Get.snackbar("提示信息", "请把姓名填写完整");
    } else if (!GetUtils.isPhoneNumber(phoneController.text) ||
        phoneController.text.length != 11) {
      Get.snackbar("提示信息", "手机号不合法");
    } else if (area.value.length < 2) {
      Get.snackbar("提示信息", "请选择地区");
    } else if (addressController.text.length < 2) {
      Get.snackbar("提示信息", "请填写详细的地址");
    } else {
      Map tempJson = {
        "uid": userInfo.sId,
        "name": nameController.text,
        "phone": phoneController.text,
        "address": "${area.value} ${addressController.text}",
      };
      String sign = SignServices.getSign({
        ...tempJson, //合并对象 表示把 salt 放到 tempJson里面
        "salt": userInfo.salt, //登录成功后服务器返回的salt  私钥
      });
      var response = await httpsClient
          .post("api/addAddress", data: {...tempJson, "sign": sign});
      if (response.data["success"]) {
        Get.back();
      } else {
        Get.snackbar("提示信息", response.data["message"]);
      }
    }
  }
}
