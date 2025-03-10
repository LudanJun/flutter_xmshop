import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:xmshop/app/services/screenAdapter.dart';
import 'package:xmshop/app/services/stringTools.dart';
import 'package:xmshop/app/widget/PassButton.dart';
import 'package:xmshop/app/widget/logo.dart';

import '../controllers/register_step_two_controller.dart';

class RegisterStepTwoView extends GetView<RegisterStepTwoController> {
  const RegisterStepTwoView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('手机号快速注册'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(ScreenAdapter.width(40)),
        children: [
          const Logo(),
          Container(
            alignment: Alignment.center,
            child: Column(
              children: [
                const Text("请输入验证码",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: ScreenAdapter.height(20)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("已发送至"),
                    Text(maskPhoneNumber(controller.tel)),
                  ],
                )
                // Text("已发送至 ${controller.tel}")
              ],
            ),
          ),
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
                  //汉化dialog
                  dialogTitle: "黏贴验证码",
                  dialogContent: "确定要黏贴验证码",
                  affirmativeText: "确定",
                  negativeText: "取消"), //配置dialog
              pinTheme: PinTheme(
                //样式
                // 修改边框
                activeColor: Colors.black12, // 输入文字后边框的颜色
                selectedColor: Colors.orange, // 选中边框的颜色
                inactiveColor: Colors.black12, //默认的边框颜色
                //背景颜色
                activeFillColor: Colors.white,
                selectedFillColor: Colors.orange,
                inactiveFillColor: const Color.fromRGBO(245, 245, 245, 1),

                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(5),
                fieldHeight: 50,
                fieldWidth: 40,
              ),
              animationDuration: const Duration(milliseconds: 300),
              enableActiveFill: true,
              controller:
                  controller.editingController, //TextFiled控制器绑定给自定义文本框,这样
              onCompleted: (v) async {
                //输入完验证码调用该方法
                var flag = await controller.validateCode();
                if (flag) {
                  Get.toNamed("/register-step-three", arguments: {
                    "tel": controller.tel, //获取第一个页面传过来的手机号
                    "code": controller.editingController.text //把当前的验证码传过去
                  });
                } else {
                  Get.snackbar("提示信息!", "验证码输入错误");
                }
                print("Completed");
              },
              onChanged: (value) {
                print(value);
              },
              beforeTextPaste: (text) {
                print("Allowing to paste $text");
                return true;
              },
              appContext: context, //注意需要传入context
            ),
          ),
          SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => controller.seconds.value > 0
                    ? TextButton(
                        onPressed: null,
                        child: Text("${controller.seconds.value}秒后重新发送"))
                    : TextButton(
                        onPressed: () {
                          //重新发送验证码 请求调用
                          controller.sendCode();
                        },
                        child: const Text("重新发送验证码"))),
                TextButton(onPressed: () {}, child: Text("帮助")),
              ],
            ),
          ),
          PassButton(
              text: "下一步",//如果输入错误的话就不会执行自动跳转,所以有必要手动点击下一步
              onPressed: () async {
                // 隐藏键盘
                FocusScope.of(context).requestFocus(FocusNode());
                //验证验证码
                var flag = await controller.validateCode();
                if (flag) {
                  //通过
                  Get.toNamed("/register-step-three", arguments: {
                    "tel": controller.tel, //获取第一个页面传过来的手机号
                    "code": controller.editingController.text //把当前的验证码传过去
                  });
                } else {
                  Get.snackbar("提示信息!", "验证码输入错误");
                }
              })
        ],
      ),
    );
  }
}
