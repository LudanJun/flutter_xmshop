import 'package:get/get.dart';

class PayController extends GetxController {
  //付款方式 以map形式添加到数组中
  RxList payList = [
    {
      "id": 1,
      "title": "支付宝支付",
      "chekced": true,
      "image": "https://www.itying.com/themes/itying/images/alipay.png"
    },
    {
      "id": 2,
      "title": "微信支付",
      "chekced": false,
      "image": "https://www.itying.com/themes/itying/images/weixinpay.png"
    }
  ].obs;

  //选择付款的类型
  int payType = 0;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }
  //传入索引值 改变付款方式
  changePayList(index) {
    //初始化一个空的 字典数组
    List<Map<String, Object>> tempList = [];
    //循环遍历 付款数组
    for (var i = 0; i < payList.length; i++) {
      //把每个付款方式都改为 false 不选中
      payList[i]["chekced"] = false;
      //然后把所有付款方式放入临时变量
      tempList.add(payList[i]);
    }
    //再把临时数组中的选中的付款方式的 选择属性改为true
    tempList[index]["chekced"] = true;
    //获取付款索引
    payType = index;
    //再把临时数组赋给付款数组
    payList.value = tempList;
    update();
  }
}
