import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:xmshop/app/models/message.dart';
import 'package:xmshop/app/services/screenAdapter.dart';
import 'package:xmshop/app/widget/PassButton.dart';
import 'package:xmshop/app/widget/logo.dart';

import '../controllers/code_login_step_two_controller.dart';

class CodeLoginStepTwoView extends GetView<CodeLoginStepTwoController> {
  const CodeLoginStepTwoView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text('手机号快速登录'),
          centerTitle: true,
        ),
        body: ListView(
          children: [
            const Logo(),
            Container(
              margin: EdgeInsets.only(top: ScreenAdapter.height(60)),
              padding: EdgeInsets.all(ScreenAdapter.width(40)),
              child: PinCodeTextField(
                autoFocus: true, //进入就弹出键盘
                keyboardType: TextInputType.number, //调用数字键盘
                length: 6,
                obscureText: false,
                animationType: AnimationType.fade,
                dialogConfig: DialogConfig(
                  //汉化复制粘贴弹框样式
                  dialogTitle: "粘贴验证码",
                  dialogContent: "确定盐粘贴此验证码吗?",
                  affirmativeText: "确定",
                  negativeText: "取消",
                ),
                pinTheme: PinTheme(
                  //样式
                  activeColor: Colors.orange, //边框颜色,输入文字后的边框颜色
                  selectedColor: Colors.black12, //边框颜色,选中后的边框颜色没有输入文字
                  inactiveColor: Colors.black, //默认边框颜色
                  //背景颜色
                  activeFillColor: Colors.white, //背景颜色,输入文字后变的颜色
                  selectedFillColor: Colors.orange,
                  inactiveFillColor: Colors.black12,

                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(5),
                  fieldHeight: 50,
                  fieldWidth: 40,
                ),

                animationDuration: const Duration(milliseconds: 300), //动画时间
                backgroundColor: Colors.white, //背景颜色
                enableActiveFill: true,
                // errorAnimationController: errorController,
                controller: controller.editingController, //指定控制器TextFiled
                onCompleted: (v) async {
                  //输入完成触发的方法
                  print("Completed");
                  // 隐藏键盘
                  FocusScope.of(context).requestFocus(FocusNode());
                  MessageModel result = await controller.doLogin();
                  if (result.success) {
                    //返回根 这个可以重新出发 Controller李的oninit方法
                    // Get.offAllNamed("/tabs", arguments: {"initialPage": 4});
                    Get.back();
                  } else {
                    Get.snackbar("提示信息", result.message);
                  }
                },
                onChanged: (value) {
                  print(value);
                  // setState(() {
                  //   currentText = value;
                  // });
                },
                beforeTextPaste: (text) {
                  print("Allowing to paste $text");
                  //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                  //but you can show anything you want here, like your pop up saying wrong paste format or etc
                  return true;
                },
                appContext: context, //注意需要传入context
              ),
            ),
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => controller.seconds.value == 0
                      ? TextButton(
                          onPressed: () {
                            controller.sendCode();
                          },
                          child: const Text("重新发送验证码"))
                      : TextButton(
                          onPressed: null,
                          child: Text("${controller.seconds.value}秒后重发送"))),
                  TextButton(onPressed: () {}, child: Text("帮助")),
                ],
              ),
            ),
     
          ],
        ));
  }
}
