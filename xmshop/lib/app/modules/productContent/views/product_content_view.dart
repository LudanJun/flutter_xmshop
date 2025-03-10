import 'dart:async';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:xmshop/app/modules/productContent/views/first_page_view.dart';
import 'package:xmshop/app/modules/productContent/views/second_page_view.dart';
import 'package:xmshop/app/modules/productContent/views/third_page_view.dart';
import 'package:xmshop/app/services/screenAdapter.dart';

import '../controllers/product_content_controller.dart';
import './cart_item_num_view.dart';

class ProductContentView extends GetView<ProductContentController> {
  const ProductContentView({Key? key}) : super(key: key);

  //bottomSheet更新流数据需要使用 GetBuilder 来渲染数据
  //showBottomAttr 抽离属性弹框 共用
  //因为筛选属性,加入购物车,立即购买显示的界面不一样 需要传入参数区分
  //action=1 筛选属性 action=1 加入购物车 action=2  立即购买
  void showBottomAttr(int action) {
    Get.bottomSheet(
      GetBuilder<ProductContentController>(
          init: controller,
          builder: (controller) {
            return Container(
                color: Colors.white,
                padding: EdgeInsets.all(ScreenAdapter.width(20)),
                width: double.infinity,
                height: ScreenAdapter.height(1200),
                //在bottomSheet使用obx是有问题的! 没办法触发
                //需要使用 GetBuilder<ProductContentController>这种方式来监听数据变化
                child: Stack(
                  children: [
                    ListView(
                        //attr 可能为空 需要类型断言!
                        children: [
                          //数组里添加循环组件 后面想要继续添加控件 需要在前面添加...
                          ...controller.pcontent.value.attr!.map((v) {
                            return Wrap(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(
                                      top: ScreenAdapter.height(20),
                                      left: ScreenAdapter.width(20)),
                                  width: ScreenAdapter.width(1040),
                                  child: Text(
                                    "${v.cate}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      top: ScreenAdapter.height(20),
                                      left: ScreenAdapter.width(20)),
                                  width: ScreenAdapter.width(1040),
                                  child: Wrap(
                                      children: v.attrList!.map((value) {
                                    return InkWell(
                                      onTap: () {
                                        print(v.cate);
                                        print(value["title"]);
                                        controller.changeAttr(
                                            v.cate, value["title"]);
                                      },
                                      child: Container(
                                        margin: EdgeInsets.all(
                                            ScreenAdapter.width(20)),
                                        child: Chip(
                                            padding: EdgeInsets.only(
                                                left: ScreenAdapter.width(20),
                                                right: ScreenAdapter.width(20)),
                                            backgroundColor:
                                                value["checked"] == true
                                                    ? Colors.red
                                                    : const Color.fromARGB(
                                                        31, 223, 213, 213),
                                            label: Text(value["title"])),
                                      ),
                                    );
                                  }).toList()),
                                ),
                              ],
                            );
                          }).toList(),
                          //数量
                          Padding(
                            padding: EdgeInsets.all(ScreenAdapter.height(20)),
                            child:Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                               const Text(
                                  "数量",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                CartItemNumView(),
                              ],
                            ),
                          )
                        ]),
                    Positioned(
                        right: 2,
                        top: 0,
                        child: IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon:const Icon(Icons.close),
                        )),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: action == 1
                          ? Row(
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Container(
                                      height: ScreenAdapter.height(120), //按钮高度
                                      margin: EdgeInsets.only(
                                          right: ScreenAdapter.width(
                                              20)), //离右边按钮间距
                                      child: ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Color.fromRGBO(
                                                          255, 165, 0, 0.9)),
                                              foregroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.white),
                                              shape: MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10) //设置圆角按钮//默认是半圆形按钮
                                                      ))),
                                          onPressed: () {
                                            controller.addCart();
                                          },
                                          child: Text("加入购物车")),
                                    )),
                                Expanded(
                                    flex: 1,
                                    child: Container(
                                      height: ScreenAdapter.height(120), //按钮高度
                                      margin: EdgeInsets.only(
                                          right: ScreenAdapter.width(
                                              20)), //离右边按钮间距
                                      child: ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Color.fromRGBO(
                                                          255, 165, 0, 0.9)),
                                              foregroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.white),
                                              shape: MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10) //设置圆角按钮//默认是半圆形按钮
                                                      ))),
                                          onPressed: () {
                                            controller.buy();
                                          },
                                          child: Text("立即购买")),
                                    ))
                              ],
                            )
                          : Row(
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Container(
                                      height: ScreenAdapter.height(120), //按钮高度
                                      margin: EdgeInsets.only(
                                          right: ScreenAdapter.width(
                                              20)), //离右边按钮间距
                                      child: ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      const Color.fromRGBO(
                                                          255, 165, 0, 0.9)),
                                              foregroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.white),
                                              shape: MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10) //设置圆角按钮//默认是半圆形按钮
                                                      ))),
                                          onPressed: () {
                                            print("确定");
                                            if (action == 2) {
                                              print("加入购物车");
                                              controller.addCart();
                                            } else {
                                              print("立即购买");
                                              controller.buy();
                                            }
                                          },
                                          child: Text(" 确定")),
                                    ))
                              ],
                            ),
                    ),
                  ],
                ));
          }),
    );
  }

  //抽离appbar
  Widget _appBar(BuildContext context) {
    return Obx(
      () => AppBar(
        leading: Container(
          alignment: Alignment.center,
          child: SizedBox(
            width: ScreenAdapter.width(88),
            height: ScreenAdapter.width(88),
            child: ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                style: ButtonStyle(
                    //注意去掉button默认的padding值
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.all(0)), //设置按钮内边距整体为0,才能把按钮图标显示居中
                    alignment: Alignment.center,
                    backgroundColor: MaterialStateProperty.all(Colors.black12),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all(const CircleBorder())),
                child: const Icon(
                  Icons.arrow_back_ios_new_outlined,
                )),
          ),
        ),
        title: SizedBox(
          width: ScreenAdapter.width(400),
          height: ScreenAdapter.height(96),
          child: controller.showTabs.value
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center, //让行里面的内容上下居中
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, //排开对齐
                  children: controller.tabsList.map((value) {
                    return InkWell(
                      onTap: () {
                        controller.changeSelectedTabsindex(value["id"]);
                        //跳转到指定的容器
                        if (value["id"] == 1) {
                          Scrollable.ensureVisible(
                              controller.gk1.currentContext as BuildContext,
                              duration: const Duration(milliseconds: 300));
                        } else if (value["id"] == 2) {
                          Scrollable.ensureVisible(
                              controller.gk2.currentContext as BuildContext,
                              duration: const Duration(milliseconds: 300));
                          //修正
                          Timer.periodic(Duration(milliseconds: 301), (timer) {
                            controller.scrollController.jumpTo(
                                controller.scrollController.position.pixels -
                                    ScreenAdapter.height(120) -
                                    ScreenAdapter.getStatusBarHeight());
                            timer.cancel();
                          });
                        } else if (value["id"] == 3) {
                          Scrollable.ensureVisible(
                              controller.gk3.currentContext as BuildContext,
                              duration: const Duration(milliseconds: 300));
                          //修正
                          Timer.periodic(Duration(milliseconds: 301), (timer) {
                            controller.scrollController.jumpTo(
                                controller.scrollController.position.pixels -
                                    ScreenAdapter.height(120) -
                                    ScreenAdapter.getStatusBarHeight());
                            timer.cancel();
                          });
                        }
                      },
                      // padding: const EdgeInsets.all(0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center, //让列表内容组件居中
                        children: [
                          Text(
                            "${value["title"]}",
                            style:
                                TextStyle(fontSize: ScreenAdapter.fontSize(36)),
                          ),
                          value["id"] == controller.selectedTabsIndex.value
                              ? Container(
                                  margin: EdgeInsets.only(
                                      top: ScreenAdapter.height(10)),
                                  width: ScreenAdapter.width(100),
                                  height: ScreenAdapter.height(2),
                                  color: Colors.red,
                                )
                              : Container(
                                  margin: EdgeInsets.only(
                                      top: ScreenAdapter.height(10)),
                                  width: ScreenAdapter.width(100),
                                  height: ScreenAdapter.height(2),
                                ),
                        ],
                      ),
                    );
                  }).toList())
              : Text(""),
        ),
        centerTitle: true,
        backgroundColor:
            Colors.white.withOpacity(controller.opcity.value), //实现透明导航
        elevation: 0, //去掉阴影 //实现透明导航

        actions: [
          //创建圆形图标
          Container(
            margin: EdgeInsets.only(right: ScreenAdapter.width(20)),
            width: ScreenAdapter.width(88),
            height: ScreenAdapter.width(88),
            child: ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                    //注意去掉button默认的padding值
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.all(0)), //设置按钮内边距整体为0,才能把按钮图标显示居中
                    backgroundColor: MaterialStateProperty.all(Colors.black12),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all(const CircleBorder())),
                child: const Icon(
                  Icons.file_upload_outlined,
                )),
          ),

          Container(
            margin: EdgeInsets.only(right: ScreenAdapter.width(20)),
            width: ScreenAdapter.width(88),
            height: ScreenAdapter.width(88),
            child: ElevatedButton(
                onPressed: () {
                  showMenu(
                      color: Colors.black87.withOpacity(0.7),
                      context: context,
                      position: RelativeRect.fromLTRB(
                          ScreenAdapter.width(800),
                          ScreenAdapter.height(220),
                          ScreenAdapter.width(20),
                          0), //弹出菜单显示的位置
                      items: const [
                        PopupMenuItem(
                            child: Row(
                          children: [
                            Icon(Icons.home, color: Colors.white),
                            Text(
                              "首页",
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        )),
                        PopupMenuItem(
                            child: Row(
                          children: [
                            Icon(
                              Icons.message,
                              color: Colors.white,
                            ),
                            Text(
                              "消息",
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        )),
                        PopupMenuItem(
                            child: Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.white,
                            ),
                            Text(
                              "收藏",
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        )),
                      ]);
                },
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.all(0)), //设置按钮内边距整体为0,才能把按钮图标显示居中
                    backgroundColor: MaterialStateProperty.all(Colors.black12),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all(const CircleBorder())),
                child: const Icon(
                  Icons.more_horiz_rounded,
                )),
          ),
        ],
      ),
    );
  }

  Widget _subHeader() {
    return Obx(() => Container(
          color: Colors.white,
          //在外层包裹一个容器可以控制它的padding和背景颜色还有尺寸大小
          height: ScreenAdapter.height(100),
          child: Row(
              children: controller.subTabsList.map((value) {
            return Expanded(
                //需要再Container外层加 如果在Expanded外面加会破坏布局
                child: InkWell(
              onTap: () {
                //需要再最外层Container里加Obx 实时刷新选中功能
                controller.changeSelectedSubTabsindex(value["id"]);
              },
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  "${value["title"]}",
                  style: TextStyle(
                      color: controller.selectedSubTabsIndex == value["id"]
                          ? Colors.red
                          : Colors.black87),
                ),
              ),
            ));
          }).toList()),
        ));
  }

  Widget _body() {
    return SingleChildScrollView(
      controller: controller.scrollController, //绑定scrollController 不然监听不到滚动
      /*
      BouncingScrollPhysics ：允许滚动超出边界，但之后内容会反弹回来。iOS下弹性效果
      ClampingScrollPhysics ： 防止滚动超出边界，夹住 。
      AlwaysScrollableScrollPhysics ：始终响应用户的滚动。
      NeverScrollableScrollPhysics ：不响应用户的滚动。 
      */
      physics: const ClampingScrollPhysics(),
      child: Column(
        children: [
          //抽离成单独页面进行布局
          FirstPageView(showBottomAttr),
          SecondPageView(_subHeader),
          ThirdPageView(),
          //    ThirdPageView(),
          //  ThirdPageView(),
        ],
      ),
    );
  }

  Widget _bottom() {
    return Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          height: ScreenAdapter.height(180),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                top: BorderSide(
                    width: ScreenAdapter.width(2), color: Colors.black)),
          ),
          child: Row(
            children: [
              SizedBox(
                width: ScreenAdapter.width(200),
                height: ScreenAdapter.height(160),
                child: InkWell(
                  onTap: () {
                    Get.toNamed("/cart");
                  },
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.shopping_cart),
                    Text("购物车",
                        style: TextStyle(fontSize: ScreenAdapter.fontSize(32)))
                  ],
                ),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Container(
                    height: ScreenAdapter.height(120), //按钮高度
                    margin: EdgeInsets.only(
                        right: ScreenAdapter.width(20)), //离右边按钮间距
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Color.fromRGBO(255, 165, 0, 0.9)),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.white),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        10) //设置圆角按钮//默认是半圆形按钮
                                    ))),
                        onPressed: () {
                          showBottomAttr(2);
                        },
                        child: Text("加入购物车")),
                  )),
              Expanded(
                  flex: 1,
                  child: Container(
                    height: ScreenAdapter.height(120), //按钮高度
                    margin: EdgeInsets.only(right: ScreenAdapter.width(20)),
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Color.fromRGBO(253, 1, 0, 0.9)),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.white),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        10) //设置圆角按钮//默认是半圆形按钮
                                    ))),
                        onPressed: () {
                          showBottomAttr(3);
                        },
                        child: Text("立即购买")),
                  )),
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //该属性可以让appbar下面的控件在导航栏下面显示
      extendBodyBehindAppBar: true, //实现透明导航
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(ScreenAdapter.height(120)),
          child: _appBar(context)),
      body: Stack(
        //使用定位添加底部 加入购物车toolbar
        children: [
          _body(),
          _bottom(),
          Obx(() => controller.showSubHeaderTabs.value
              ? Positioned(
                  left: 0,
                  right: 0,
                  top: ScreenAdapter.getStatusBarHeight() +
                      ScreenAdapter.height(120), //需要后面进行计算
                  child: _subHeader()) //需要使用定位进行配置使用
              : const Text("")),
        ],
      ),
    );
  }
}
