import 'package:get/get.dart';
import 'package:xmshop/app/models/address_model.dart';
import 'package:xmshop/app/models/user_model.dart';
import 'package:xmshop/app/modules/checkout/controllers/checkout_controller.dart';
import 'package:xmshop/app/services/httpsClient.dart';
import 'package:xmshop/app/services/signServices.dart';
import 'package:xmshop/app/services/userServices.dart';

//地址列表
class AddressListController extends GetxController {
  //创建请求工具
  HttpsClient httpsClient = HttpsClient();
  //存放地址列表数据
  RxList<AddressItemModel> addressList = <AddressItemModel>[].obs;
  //导入
  CheckoutController checkoutController = Get.find<CheckoutController>();

  @override
  void onInit() {
    super.onInit();
    //获取地址列表
    getAddressList();
  }

  @override
  void onClose() {
    //当列表消失的时候 获取默认地址
    checkoutController.getDefaultAddress();
    super.onClose();
  }

  getAddressList() async {
    //获取保存在本地的用户信息数据
    List userList = await UserServices.getUserInfo();
    //把用户信息转成模型类
    UserModel userInfo = UserModel.fromJson(userList[0]);
    //取出用户id
    Map tempJson = {"uid": userInfo.sId};
    //把用户信息数据和私钥传入  进行MD5加密
    String sign = SignServices.getSign({
      ...tempJson, //合并对象 表示把 salt 放到 tempJson里面
      "salt": userInfo.salt //私钥
    });
    var response =
        await httpsClient.get("api/addressList?uid=${userInfo.sId}&sign=$sign");
    if (response != null) {
      var tempAddressList = AddressModel.fromJson(response.data);
      addressList.value = tempAddressList.result!;
      update();
    }
  }

  //改变默认地址
  changeDefaultAddress(id) async {
    List userList = await UserServices.getUserInfo();
    UserModel userInfo = UserModel.fromJson(userList[0]);
    Map tempJson = {"uid": userInfo.sId, "id": id};
    String sign = SignServices.getSign({
      ...tempJson,
      "salt": userInfo.salt //私钥
    });
    var response = await httpsClient
        .post("api/changeDefaultAddress", data: {...tempJson, "sign": sign});
    if (response != null) {
      Get.back();
    }
  }

  //删除收货地址
  deleteAddress(id) async {
    List userList = await UserServices.getUserInfo();
    UserModel userInfo = UserModel.fromJson(userList[0]);
    Map tempJson = {"uid": userInfo.sId, "id": id};
    String sign = SignServices.getSign({
      ...tempJson,
      "salt": userInfo.salt //私钥
    });
    var response = await httpsClient
        .post("api/deleteAddress", data: {...tempJson, "sign": sign});
    if (response != null) {
      //删除成功重新更新当前页面的数据
      getAddressList();
    }
  }

}
