import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/tabs_controller.dart';

//在这里配置底部TabBar
class TabsView extends GetView<TabsController> {
  const TabsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(//外面添加Obx 重新进行页面渲染刷新
      () => Scaffold(
        // appBar: AppBar(
        //   title: const Text( 'TabsView'),
        //   centerTitle: true,
        // ),controller.pages[controller.currentIndex.value],
        body: PageView(//实现左右滑动tabs,因为想要实现页面换成,所以需改造一下
          controller:controller.pageController,//默认加载控制器
          physics: const NeverScrollableScrollPhysics(),//禁止左右滑动
          children: controller.pages,
          onPageChanged: (index){
            controller.setCurrentIndex(index);
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          fixedColor: Colors.red, //选中的颜色
          currentIndex: controller.currentIndex.value, //第几个菜单选中
          type: BottomNavigationBarType.fixed, //如果底部有>=4个需要设置这个属性
          onTap: (index) {
            //底部点击方法
            controller.setCurrentIndex(index); //把索引值传入
            //修改了可以左右滑动tabs 但是底部点击不会切换页面需加如下👇🏻代码
            controller.pageController.jumpToPage(index);
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "首页"),
            BottomNavigationBarItem(icon: Icon(Icons.category), label: "分类"),
            BottomNavigationBarItem(
                icon: Icon(Icons.room_service), label: "服务"),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart), label: "购物车"),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: "用户"),
          ],
        ),
      ),
    );
  }
}
