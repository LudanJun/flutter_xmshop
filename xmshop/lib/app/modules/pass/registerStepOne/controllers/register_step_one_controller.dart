import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:xmshop/app/models/message.dart';
import 'package:xmshop/app/services/httpsClient.dart';

class RegisterStepOneController extends GetxController {
  //TODO: Implement RegisterStepOneController
  TextEditingController editingController=TextEditingController();
  HttpsClient httpsClient = HttpsClient();  

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
 //发送验证码 
 //Future<加个返回值类型> 只有需要返回值的时候才加Future
  Future<MessageModel> sendCode() async{
    //传入手机号
      var response = await httpsClient.post("api/sendCode",data:{
        "tel":editingController.text//从自定义文本框里获取数值,需要把当前控制器绑定给自定义文本框控件
      });
      if (response != null) {
         print(response);
         if(response.data["success"]){
          //测试：把验证码复制到剪切板上面，正式上线不需要这句话,这个为了方便测试
          Clipboard.setData(ClipboardData(text: response.data["code"]));

          return MessageModel(message: "发送验证码成功", success: true);
         }
        return MessageModel(message: response.data["message"], success: false);
      }else{
        return MessageModel(message:"网络异常", success: false);
       }
  }
}
