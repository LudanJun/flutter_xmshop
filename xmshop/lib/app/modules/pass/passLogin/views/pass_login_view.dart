import 'dart:ffi';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:xmshop/app/models/message.dart';
import 'package:xmshop/app/services/screenAdapter.dart';
import 'package:xmshop/app/widget/PassButton.dart';
import 'package:xmshop/app/widget/PassTextField.dart';
import 'package:xmshop/app/widget/logo.dart';
import 'package:xmshop/app/widget/userAgreement.dart';

import '../controllers/pass_login_controller.dart';

class PassLoginView extends GetView<PassLoginController> {
  const PassLoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, //页面内容设置为白色
      appBar: AppBar(
        backgroundColor: Colors.white, //导航设置为白色
        elevation: 0,
        title: const Text(''),
        centerTitle: true,
        actions: [TextButton(onPressed: () {}, child: const Text("帮助"))],
      ),
      body: ListView(
        padding: EdgeInsets.all(ScreenAdapter.width(40)),
        children: [
          Logo(),
          //输入手机号
          PassTextFiled(
              controller: controller.telController,
              hintText: "请输入手机号",
              onChanged: (value) {
                print(value);
              }),

          PassTextFiled(
              controller: controller.passController,
              hintText: "请输入密码",
              onChanged: (value) {
                print(value);
              }),
          //用户协议
          UserAgreement(),
          //登录按钮
          PassButton(
              text: "登录",
              onPressed: () async {
                print("账号密码登录");
                //判断手机号是否合法
                if (!GetUtils.isPhoneNumber(controller.telController.text) ||
                    controller.telController.text.length != 11) {
                  Get.snackbar("提示信息!", "手机号格式不合法");
                } else if (controller.passController.text.length < 6) {
                  Get.snackbar("提示信息!", "密码长度不能小于6位");
                } else {
                  MessageModel result = await controller.doLogin();
                  if (result.success) {
                    //执行跳转  回到根
                    // Get.offAllNamed("/tabs", arguments: {
                    //   "initialPage": 4 //注册完成后会加载tabs第五个页面
                    // });
                    Get.back();
                  } else {
                    Get.snackbar("提示信息!", result.message);
                  }
                }
              }),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(onPressed: () {}, child: Text("忘记密码")),
              TextButton(
                  onPressed: () {
                    Get.toNamed("/code-login-step-one");
                  },
                  child: Text("验证码登录"))
            ],
          )
        ],
      ),
    );
  }
}
