import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:xmshop/app/services/httpsClient.dart';

class RegisterStepTwoController extends GetxController {
  final TextEditingController editingController = TextEditingController();
  HttpsClient httpsClient = HttpsClient();
  //监听上级页面传来的数据
  String tel = Get.arguments["tel"];
  RxInt seconds = 30.obs;

  @override
  void onInit() {
    super.onInit();
    countDown();

  }

  @override
  void onClose() {
    super.onClose();
  }

 //倒计时的方法
  countDown() {
    //每隔一秒触发一次方法
    Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      seconds.value--;
      if (seconds.value == 0) {
        timer.cancel();
      }
      update();
    });
  }

 //重新发送验证码
  void sendCode() async {
    var response = await httpsClient.post("api/sendCode", data: {"tel": tel});
    if (response != null) {
      print(response);
      if (!response.data["success"]) {
        Get.snackbar("提示信息!", "非法请求");
      }else{

         //测试：把验证码复制到剪切板上面，正式上线不需要这句话,这个为了方便测试
         Clipboard.setData(ClipboardData(text: response.data["code"]));

        seconds.value=30;
        countDown();
        update();
      }
    } else {
      Get.snackbar("提示信息!", "网络异常请重试");
    }
  }

  //验证验证码
  Future<bool> validateCode() async {
    var response = await httpsClient.post("api/validateCode", data: {
      "tel": tel, //上一个页面穿过来的手机号
      "code": editingController.text//密码框绑定了Controller 所以这里可以获取密码框的值
    });
    if (response != null) {
      if (response.data["success"]) {
        return true;
      }
      return false;
    } else {
      return false;
    }
  }

}
