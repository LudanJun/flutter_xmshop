import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xmshop/app/models/user_model.dart';
import 'package:xmshop/app/modules/address/addressList/controllers/address_list_controller.dart';
import 'package:xmshop/app/services/httpsClient.dart';
import 'package:xmshop/app/services/signServices.dart';
import 'package:xmshop/app/services/userServices.dart';

class AddressEditController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  RxString area = "".obs;
  String addressId = Get.arguments["id"];
  HttpsClient httpsClient = HttpsClient();

  AddressListController listController = Get.find<AddressListController>();

  @override
  void onInit() {
    super.onInit();

    initAddressData();
  }
  //初始化从上个页面获取的数据
  initAddressData() {
    //接收上级页面传的数据
    nameController.text = Get.arguments["name"];
    phoneController.text = Get.arguments["phone"];

    String address = Get.arguments["address"];
    //地址字符串里以空格为分隔 把地址字符串改成数组list
    List addressList = address.split(" ");
    print(addressList);//flutter: [河北省, 石家庄市, 长安区, ggggasasdasda]
    print("---");
    //把省市区赋值给area
    area.value = "${addressList[0]} ${addressList[1]} ${addressList[2]}";
    //把数组地址的前3项删除保留最后一个详细地址
    addressList.removeRange(0, 3);
    print(addressList);//删除省市区的list [ggggasasdasda]
    //然后再把数组添加空格 转成字符串
    addressController.text = addressList.join(" ");
  }

  @override
  void onClose() {
    super.onClose();
        //返回的时候及时更新收货地址列表里面的数据
    listController.getAddressList();
  }

  setArea(String str) {
    area.value = str;
    update();
  }
  //修改收货地址 请求
  doEditAddress() async {
    List userList = await UserServices.getUserInfo();
    UserModel userInfo = UserModel.fromJson(userList[0]);

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
        "id":addressId,
        "uid": userInfo.sId,
        "name": nameController.text,
        "phone": phoneController.text,
        "address": "${area.value} ${addressController.text}",       
      };
      String sign = SignServices.getSign({
         ...tempJson,    //合并对象
         "salt": userInfo.salt, //登录成功后服务器返回的salt  私钥
      });
   print("sign");
      print(sign);
      var response=await httpsClient.post("api/editAddress", data: {
           ...tempJson,    
           "sign":sign
      });
      if(response.data["success"]){
         Get.back();
      }else{
        Get.snackbar("提示信息", response.data["message"]);
      }
    }
  }
  
}
