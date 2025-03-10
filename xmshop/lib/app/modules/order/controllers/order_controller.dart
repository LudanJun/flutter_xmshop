import 'package:get/get.dart';
import 'package:xmshop/app/models/order_model.dart';
import 'package:xmshop/app/services/httpsClient.dart';

import '../../../models/user_model.dart';
import '../../../services/signServices.dart';
import '../../../services/userServices.dart';

class OrderController extends GetxController {
  HttpsClient httpsClient = HttpsClient();
  //订单item信息列表
  RxList<OrderInfoModel> orderList = <OrderInfoModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    getOrderList();
  }

  @override
  void onClose() {
    super.onClose();
  }

  //获取订单列表
  getOrderList() async {
    //获取用户信息
    List userList = await UserServices.getUserInfo();
    //取出用户模型信息
    UserModel userInfo = UserModel.fromJson(userList[0]);
    //获取用户id
    Map tempJson = {"uid": userInfo.sId};
    //签名
    String sign = SignServices.getSign({
      ...tempJson,
      "salt": userInfo.salt //私钥
    });

    //请求订单列表
    var response =
        await httpsClient.get("/api/orderList?uid=${userInfo.sId}&sign=$sign");
    print(response.data);

    if (response != null) {
      OrderModel tempList = OrderModel.fromJson(response.data);

      orderList.value = tempList.result!;
      update();
    }
  }

  
}
