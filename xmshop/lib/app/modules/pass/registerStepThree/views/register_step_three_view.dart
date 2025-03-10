import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:xmshop/app/models/message.dart';
import 'package:xmshop/app/services/screenAdapter.dart';
import 'package:xmshop/app/widget/PassButton.dart';
import 'package:xmshop/app/widget/PassTextField.dart';
import 'package:xmshop/app/widget/logo.dart';

import '../controllers/register_step_three_controller.dart';

class RegisterStepThreeView extends GetView<RegisterStepThreeController> {
  const RegisterStepThreeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text("手机号快速注册"),
        actions: [TextButton(onPressed: () {}, child: Text("帮助"))],
      ),
      body: ListView(
        padding: EdgeInsets.all(ScreenAdapter.width(40)),
        children: [
          const Logo(),
          //输入手机号
          PassTextFiled(
              controller: controller.passController,
              isPassWord: true,
              hintText: "请输入密码",
              keyboardType: TextInputType.text,
              onChanged: (value) {
                print(value);
              }),

          PassTextFiled(
              controller: controller.confirmController,
              isPassWord: true,
              keyboardType: TextInputType.text,
              hintText: "请输入确认密码",
              onChanged: (value) {
                print(value);
              }),

          SizedBox(height: ScreenAdapter.height(20)),
          PassButton(
              text: "完成注册",
              onPressed: () async {
                print("完成注册");
                if (controller.passController.text !=
                    controller.confirmController.text) {
                  Get.snackbar("提示信息!", "密码和确认密码不一致");
                } else if (controller.passController.text.length < 6) {
                  Get.snackbar("提示信息!", "密码长度不能小于6位");
                } else {
                  MessageModel result = await controller.doRegister();

                  if (result.success) {
                    /** 
                     * 使用Get.offAll(传入tabs_view 会没有路由了,TabsController就没法加载了)
                     * 
                     */
                    //执行跳转  回 到根  传值给tabs
                    Get.offAllNamed("/tabs", arguments: {
                      "initialPage": 4 //注册完成后会加载tabs第五个页面 (注意需要再tabsController里判断)
                    });
                  } else {
                    Get.snackbar("提示信息！", result.message);
                  }
                }
              }),
        ],
      ),
    );
  }
}
