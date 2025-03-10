import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:get/get.dart';
import 'package:xmshop/app/services/httpsClient.dart';
import 'package:xmshop/app/services/screenAdapter.dart';

import '../controllers/checkout_controller.dart';

class CheckoutView extends GetView<CheckoutController> {
  //封装单个选择的商品控件
  Widget _checkoutItem(value) {
    return Container(
      padding: EdgeInsets.only(
          top: ScreenAdapter.height(20),
          bottom: ScreenAdapter.height(20),
          right: ScreenAdapter.height(20)),
      child: Row(
        children: [
          Container(
            alignment: Alignment.center,
            width: ScreenAdapter.width(200),
            height: ScreenAdapter.width(200),
            padding: EdgeInsets.all(ScreenAdapter.width(20)),
            child: Image.network(
              HttpsClient.replaeUri(value["pic"]),
              fit: BoxFit.fitHeight,
            ), //垂直方向占满
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${value["title"]}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: ScreenAdapter.height(10),
                ),
                Text("${value["selectedAttr"]}"),
                SizedBox(height: ScreenAdapter.height(10)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "¥ ${value["price"]}",
                      style: TextStyle(color: Colors.red),
                    ),
                    Text(
                      "x ${value["count"]}",
                      style: TextStyle(color: Colors.black87),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _body() {
    return ListView(
      padding: EdgeInsets.all(ScreenAdapter.width(30)),
      children: [
        Obx(() => controller.addressList.isEmpty
            ? Container(
                padding: EdgeInsets.only(
                    top: ScreenAdapter.height(20),
                    bottom: ScreenAdapter.height(20)),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(ScreenAdapter.width(20))),
                child: ListTile(
                  onTap: () {
                    Get.toNamed("/address-add");
                  },
                  leading: const Icon(Icons.add_location),
                  title: const Text("新建收货地址"),
                  trailing: const Icon(Icons.navigate_next),
                ),
              )
            : Container(
                padding: EdgeInsets.only(
                    top: ScreenAdapter.height(20),
                    bottom: ScreenAdapter.height(20)),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(ScreenAdapter.width(20))),
                child: ListTile(
                  onTap: () {
                    Get.toNamed("/address-list");
                  },
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "${controller.addressList[0].name} ${controller.addressList[0].phone}"),
                      SizedBox(
                        height: ScreenAdapter.height(10),
                      ),
                      Text("${controller.addressList[0].address}"),
                    ],
                  ),
                  trailing: Icon(Icons.navigate_next),
                ),
              )),
        SizedBox(
          height: ScreenAdapter.height(40),
        ),
        Container(
          padding: EdgeInsets.only(
              top: ScreenAdapter.height(20), bottom: ScreenAdapter.height(20)),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(ScreenAdapter.width(15))),
          child: Obx(() => controller.checkoutList.isNotEmpty
              ? Column(
                  children: controller.checkoutList.map((value) {
                    return _checkoutItem(value);
                  }).toList(),
                )
              : Text("")),
        ),
        SizedBox(
          height: ScreenAdapter.height(40),
        ),
        Container(
            padding: EdgeInsets.only(
                top: ScreenAdapter.height(20),
                bottom: ScreenAdapter.height(20)),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(ScreenAdapter.width(15))),
            child: const Column(
              children: [
                ListTile(
                    title: Text("运费"),
                    trailing: Wrap(
                      children: [
                        Text("包邮"),
                      ],
                    )),
                ListTile(
                  title: Text("优惠券"),
                  trailing: Wrap(
                    //trailing无法加Row 可以使用wrap组件代替
                    children: [
                      Text("无可用"),
                      Icon(Icons.navigate_next),
                    ],
                  ),
                ),
                ListTile(
                  title: Text("卡券"),
                  trailing: Wrap(
                    //trailing无法加Row 可以使用wrap组件代替
                    children: [
                      Text("无可用"),
                      Icon(Icons.navigate_next),
                    ],
                  ),
                ),
              ],
            )),
        SizedBox(
          height: ScreenAdapter.height(40),
        ),
        Container(
            padding: EdgeInsets.only(
                top: ScreenAdapter.height(20),
                bottom: ScreenAdapter.height(20)),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(ScreenAdapter.width(15))),
            child:const ListTile(
              title: const Text("发票"),
              trailing: Icon(Icons.navigate_next),
            )),
      ],
    );
  }

  Widget _bottom() {
    return Positioned(
        left: 0,
        right: 0,
        bottom: 0,
        child: Container(
          padding: EdgeInsets.only(
              left: ScreenAdapter.width(20), right: ScreenAdapter.width(20)),
          width: ScreenAdapter.width(1080), //设计稿宽度
          height: ScreenAdapter.height(190),
          decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(
                      color: Color.fromARGB(211, 240, 236, 236),
                      width: ScreenAdapter.height(2))),
              color: Colors.white),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: ScreenAdapter.width(20),
                  ),
                  Obx(() => Text("共${controller.allNum.value}件,合计:")),
                  Obx(() => Text("${controller.allPrice.value}",
                      style: TextStyle(
                          fontSize: ScreenAdapter.fontSize(58),
                          color: Colors.red))),
                  SizedBox(
                    width: ScreenAdapter.width(20),
                  )
                ],
              ),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromRGBO(255, 165, 0, 0.9)),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)))),
                  onPressed: () {
                    //判断用户有没有登录
                    controller.doCheckOut();
                  },
                  child: Text("结算")),
            ],
          ),
        ));
  }

  const CheckoutView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(238, 238, 238, 1),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('确认订单'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          _body(),
          _bottom(),
        ],
      ),
    );
  }
}
