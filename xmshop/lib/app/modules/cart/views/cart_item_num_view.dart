import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:xmshop/app/modules/cart/controllers/cart_controller.dart';
import 'package:xmshop/app/services/screenAdapter.dart';

class CartItemNumView extends GetView {
  @override
  final CartController controller = Get.find();
  final Map cartItem; //获取外界传来的参数
  CartItemNumView(this.cartItem, {Key? key}) : super(key: key);

  Widget _left() {
    return InkWell(
      onTap: () {
        //改变数量要不cartItem传入
        controller.decBuyNum(cartItem);
      },
      child: Container(
        alignment: Alignment.center,
        width: ScreenAdapter.width(80),
        height: ScreenAdapter.height(80),
        child: Text("-"),
      ),
    );
  }

  Widget _center() {
    return Container(
      decoration: BoxDecoration(
          border: Border(
        left: BorderSide(width: ScreenAdapter.width(2), color: Colors.black12),
        right: BorderSide(width: ScreenAdapter.width(2), color: Colors.black12),
      )),
      alignment: Alignment.center,
      width: ScreenAdapter.width(80),
      height: ScreenAdapter.height(80),
      child: Text("${cartItem["count"]}"),
    );
  }

  Widget _right() {
    return InkWell(
      onTap: () {
        //改变数量要不cartItem传入
        controller.incBuyNum(cartItem);
      },
      child: Container(
        alignment: Alignment.center,
        width: ScreenAdapter.width(80),
        height: ScreenAdapter.height(80),
        child: Text("+"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenAdapter.width(244),
      height: ScreenAdapter.height(80),
      decoration: BoxDecoration(
          border:
              Border.all(width: ScreenAdapter.width(2), color: Colors.black12)),
      child: Row(
        children: [
          _left(),
          _center(),
          _right(),
        ],
      ),
    );
  }
}
