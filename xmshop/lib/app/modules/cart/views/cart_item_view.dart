import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:xmshop/app/modules/cart/controllers/cart_controller.dart';
import 'package:xmshop/app/modules/cart/views/cart_item_num_view.dart';
import 'package:xmshop/app/services/httpsClient.dart';
import 'package:xmshop/app/services/screenAdapter.dart';

class CartItemView extends GetView {
  //先找到控制器,再调用对应view的方法
  @override
  final CartController controller = Get.find();

  final Map cartItem;//外接调用者传入
  CartItemView(this.cartItem,{Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ScreenAdapter.height(20)),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(
            color: Color.fromARGB(178, 240, 236, 236),
            width: ScreenAdapter.height(2),
          ))),
      child: Row(
        children: [
          Container(
            width: ScreenAdapter.width(100),
            child: Checkbox(
                activeColor: Colors.red, value: cartItem["checked"], onChanged: (value) {
                  controller.checkCartItem(cartItem);
                }),
          ),
          Container(
            width: ScreenAdapter.width(260),
            margin: EdgeInsets.only(right: ScreenAdapter.width(20)),
            padding: EdgeInsets.all(ScreenAdapter.height(24)),
            child: Image.network(HttpsClient.replaeUri(cartItem["pic"]),
                fit: BoxFit.fitHeight),
          ),
          Expanded(
            flex: 1,
            child: Column(
              //内容都居左显示
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${cartItem["title"]}",
                  style: TextStyle(
                      fontSize: ScreenAdapter.fontSize(36),
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: ScreenAdapter.height(20),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Chip(label: Text("${cartItem["selectedAttr"]}"))],
                ),
                SizedBox(
                  height: ScreenAdapter.height(20),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "¥${cartItem["price"]}",
                      style: TextStyle(
                        fontSize: ScreenAdapter.fontSize(58),
                        color: Colors.red,
                      ),
                    ),
                    CartItemNumView(cartItem),//传入数据给 加减控件 
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
