import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:xmshop/app/modules/cart/views/cart_item_view.dart';
import 'package:xmshop/app/services/screenAdapter.dart';

import '../controllers/cart_controller.dart';

//注意CartView在多个地方调用了, 这里需要手动获取CartController
class CartView extends GetView {
  @override
  final CartController controller = Get.put(CartController());

  CartView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white, //导航背景色为白色
          elevation: 0, //阴影为0
          title: const Text('购物车'),
          centerTitle: true,
          actions: [
            Obx(() => controller.isEdit.value
                ? TextButton(
                    onPressed: () {
                      controller.changeEditState();
                    },
                    child: const Text("完成"))
                : TextButton(
                    onPressed: () {
                      controller.changeEditState();
                    },
                    child: const Text("编辑")))
          ],
        ),
        //通过GetBuilder来实时刷新数据 相当于fullwidget里的setstate
        body: GetBuilder<CartController>(
            initState: (state) {
              //这个方法会每次进来都会实时出发
              print("触发了");
              controller.getCartListData();
            },
            init: controller, //这里的Controller就是CartController
            builder: (controller) {
              //buider接收传过来的Controller
              return controller.cartList.isNotEmpty
                  ? Stack(
                      children: [
                        //获取数据列表,判断数据是否为空
                        ListView(
                          padding: EdgeInsets.only(
                              bottom: ScreenAdapter.height(200)),
                          children: controller.cartList.map((value) {
                            //传入数据item
                            return CartItemView(value);
                          }).toList(),
                        ),
                        Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Container(
                              padding: EdgeInsets.only(
                                  right: ScreenAdapter.width(20)),
                              width: ScreenAdapter.width(1080),
                              height: ScreenAdapter.height(190),
                              decoration: BoxDecoration(
                                  border: Border(
                                      top: BorderSide(
                                          color: Color.fromARGB(
                                              211, 240, 236, 236),
                                          width: ScreenAdapter.height(2))),
                                  color: Colors.white),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Obx(() => Checkbox(
                                          activeColor: Colors.red,
                                          value: controller.checkAllBox.value,
                                          onChanged: (value) {
                                            print(value);
                                            controller.checkedAllFunc(value);
                                          })),
                                      const Text("全选")
                                    ],
                                  ),
                                  Obx(() => controller.isEdit.value
                                      ? Row(
                                          children: [
                                            ElevatedButton(
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors.red),
                                                    foregroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors.white),
                                                    shape: MaterialStateProperty
                                                        .all(RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)))),
                                                onPressed: () {
                                                  // //判断用户有没有登录
                                                  // // Get.toNamed("/checkout");
                                                  // controller.de();
                                                  print("删除");
                                                  controller.deleteCartDate();
                                                },
                                                child: Text("删除")),
                                          ],
                                        )
                                      : Row(
                                          children: [
                                            Text("合计: "),
                                            Obx(() => Text(
                                                "¥${controller.allPrice.value}",
                                                style: TextStyle(
                                                    fontSize:
                                                        ScreenAdapter.fontSize(
                                                            58),
                                                    color: Colors.red))),
                                            SizedBox(
                                              width: ScreenAdapter.width(20),
                                            ),
                                            ElevatedButton(
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty.all(
                                                            const Color.fromRGBO(
                                                                255,
                                                                165,
                                                                0,
                                                                0.9)),
                                                    foregroundColor:
                                                        MaterialStateProperty.all(
                                                            Colors.white),
                                                    shape: MaterialStateProperty.all(
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    10)))),
                                                onPressed: () {
                                                  //判断用户有没有登录
                                                  // Get.toNamed("/checkout");
                                                  controller.chekout();
                                                },
                                                child: Text("结算")),
                                          ],
                                        ))
                                ],
                              ),
                            )),
                      ],
                    )
                  : const Center(
                      child: Text("购物车空空如也"),
                    );
            }));
  }
}
