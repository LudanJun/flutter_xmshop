import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:xmshop/app/services/httpsClient.dart';
import 'package:xmshop/app/services/screenAdapter.dart';

import '../controllers/category_controller.dart';

class CategoryView extends GetView<CategoryController> {
  const CategoryView({Key? key}) : super(key: key);
  //左边分类控件
  Widget _leftCate() {
    return SizedBox(
      width: ScreenAdapter.width(280),
      height: double.infinity,
      child: Obx(() => ListView.builder(
          itemCount: controller.leftCategoryList.length,
          itemBuilder: (context, index) {
            return SizedBox(
                width: double.infinity,
                height: ScreenAdapter.height(180),
                child: Obx(
                  () => InkWell(
                    //点击事件
                    onTap: () {
                      //点击把当前分类的id传进去
                      controller.changeIndex(
                          index, controller.leftCategoryList[index].sId);
                    },
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            width: ScreenAdapter.width(10),
                            height: ScreenAdapter.height(46),
                            color: controller.selectIndex.value == index
                                ? Colors.red
                                : Colors.white,
                          ),
                        ),
                        Center(
                          child: Text(
                            "${controller.leftCategoryList[index].title}",
                            style: TextStyle(
                                fontSize: ScreenAdapter.fontSize(36),
                                //选中的时候加粗 其他默认
                                fontWeight:
                                    controller.selectIndex.value == index
                                        ? FontWeight.bold
                                        : FontWeight.normal),
                          ),
                        ),
                      ],
                    ),
                  ),
                ));
          })),
    );
  }

  //右侧分类控件
  Widget _rightCate() {
    return Expanded(
        child: Container(
            height: double.infinity,
            color: Colors.white,
            child: Obx(
              () => GridView.builder(
                  itemCount: controller.rightCategoryList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, //3列
                    crossAxisSpacing: ScreenAdapter.width(40), //间距
                    mainAxisSpacing: ScreenAdapter.height(40), //主轴
                    childAspectRatio: ScreenAdapter.width(240) /
                        ScreenAdapter.height(340), //宽高比需要进行计算
                  ),
                  itemBuilder: (context, index) {
                    // String pic = "https://miapp.itying.com/${controller.rightCategoryList[index].pic}";

                    return InkWell(
                      onTap: () {
                        //跳转页面 传值
                        Get.toNamed('/product-list', arguments: {
                          "cid": controller.rightCategoryList[index].sId,
                        });
                      },
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            child: Image.network(
                                HttpsClient.replaeUri(
                                    controller.rightCategoryList[index].pic),
                                fit: BoxFit.fitHeight),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                                0, ScreenAdapter.height(10), 0, 0),
                            child: Text(
                              "${controller.rightCategoryList[index].title}",
                              style: TextStyle(
                                  fontSize: ScreenAdapter.fontSize(34)),
                            ),
                          )
                        ],
                      ),
                    );
                  }),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          child: Container(
            // duration: const Duration(milliseconds: 300),
            //设置搜索栏
            width: ScreenAdapter.width(840),
            height: ScreenAdapter.height(96),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(246, 246, 246, 1), //瀑布流外部容器添加的背景颜色
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      ScreenAdapter.width(34), 0, ScreenAdapter.width(10), 0),
                  child: const Icon(
                    Icons.search,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  "手机",
                  style: TextStyle(
                    fontSize: ScreenAdapter.fontSize(32),
                    color: Colors.black54,
                  ),
                )
              ],
            ),
          ),
          onTap: () {//跳转到搜索页
            Get.toNamed('/search');
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          //创建右边图标
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.message_outlined,
                color: Colors.black,
              ))
        ],
        elevation: 0, //阴影为0
      ),
      body: Row(
        children: [
          _leftCate(),
          _rightCate(),
        ],
      ),
    );
  }
}
