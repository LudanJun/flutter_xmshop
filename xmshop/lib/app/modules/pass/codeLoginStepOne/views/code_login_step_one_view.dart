import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:xmshop/app/models/message.dart';
import 'package:xmshop/app/services/screenAdapter.dart';
import 'package:xmshop/app/widget/PassButton.dart';
import 'package:xmshop/app/widget/PassTextField.dart';
import 'package:xmshop/app/widget/logo.dart';
import 'package:xmshop/app/widget/userAgreement.dart';

import '../controllers/code_login_step_one_controller.dart';

class CodeLoginStepOneView extends GetView<CodeLoginStepOneController> {
  const CodeLoginStepOneView({Key? key}) : super(key: key);
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
        //在listView里加Container会把控件平铺
        padding: EdgeInsets.all(ScreenAdapter.width(40)),
        children: [
          //logo 抽离logo代码
          const Logo(),

          //输入手机号
          PassTextFiled(
            controller: controller.telController,
            hintText: "请输入手机号码",
            onChanged: (value) {
              print(value);
            },
          ),

          //用户协议
          UserAgreement(),

          //登录按钮
          PassButton(
            text: "获取验证码",
            onPressed: () async {
              if (!GetUtils.isPhoneNumber(controller.telController.text) ||
                  controller.telController.text.length != 11) {
                Get.snackbar("提示信息!", "手机号格式不合法");
              } else {
                MessageModel result = await controller.sendCode();
                if (result.success) {
                  // Get.toNamed("/code-login-step-two",
                  //     //给下个页面传入手机号
                  //     arguments: {"tel": controller.telController.text});
                  //点击购买跳转登录 登录成功返回 详情 使用 替换路由
                  Get.offAndToNamed("/code-login-step-two",
                      //给下个页面传入手机号
                      arguments: {"tel": controller.telController.text});
                } else {
                  Get.snackbar("提示信息!", result.message);
                }
              }
            },
          ),
          SizedBox(
            height: ScreenAdapter.height(40),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () {
                    Get.toNamed("/register-step-one");
                  },
                  child: Text("新用户注册")),
              TextButton(
                  onPressed: () {
                    // Get.toNamed("/pass-login");
                    //替换路由 替换当前页面
                    Get.offAndToNamed("/pass-login",
                        //给下个页面传入手机号
                        arguments: {"tel": controller.telController.text});
                  },
                  child: Text("账号密码登录"))
            ],
          )
        ],
      ),
    );
  }
}
