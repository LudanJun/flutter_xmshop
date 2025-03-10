import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:xmshop/app/services/screenAdapter.dart';
import 'package:xmshop/app/widget/PassButton.dart';

import '../controllers/pay_controller.dart';

class PayView extends GetView<PayController> {
  const PayView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, //导航背景颜色
        elevation: 0, //去掉阴影
        title: const Text('去支付'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(ScreenAdapter.width(20)),
        children: [
          Obx(
            () => ListView.builder(
              itemCount: controller.payList.length,
              shrinkWrap: true, //收缩
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      //添加选择事件
                      onTap: () {
                        controller.changePayList(index);
                      },
                      leading:
                          Image.network(controller.payList[index]["image"]),
                      title: Text("${controller.payList[index]["title"]}"),
                      trailing: controller.payList[index]["chekced"]
                          ? Icon(Icons.check)
                          : Text(""),
                    ),
                    const Divider()
                  ],
                );
              },
            ),
          ),
          SizedBox(
            height: ScreenAdapter.height(200),
          ),
          PassButton(
              text: "支付",
              onPressed: () {
                // print("支付");
                if (controller.payType == 0) {
                  print("支付宝支付");
                } else {
                  print("微信支付");
                }
              })
        ],
      ),
    );
  }
}
