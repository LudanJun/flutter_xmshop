import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:xmshop/app/services/screenAdapter.dart';
import 'package:xmshop/app/services/searchServices.dart';

import '../controllers/search_controller.dart';

class SearchView extends GetView<SearchPageController> {
  const SearchView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(246, 246, 246, 1),
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
              child: TextField(
                autofocus: true, //表示进入到页面后就弹出键盘

                style: TextStyle(
                  //修改搜索框字体
                  fontSize: ScreenAdapter.fontSize(36),
                ),
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(0), //设置文本框内边距
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      //配置边框圆角
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none, //文本框边框去掉没有
                    )),
                onChanged: (value) {
                  //监听文本框输入内容
                  controller.keyWords = value;
                },
                //监听键盘的回车事件
                onSubmitted: (value) {
                  //保存搜索记录
                  SearchServices.setHistoryData(value);

                  //替换路由
                  Get.offAndToNamed("/product-list", arguments: {
                    //把要搜索的内容传给下个页面
                    "keywords": value,
                  });
                },
              )),
          onTap: () {
            //跳转到搜索页
            Get.toNamed('/search');
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          TextButton(
              onPressed: () {
                // print("搜索");
                //保存搜索记录
                SearchServices.setHistoryData(controller.keyWords);

                //点击搜索传入搜索的内容
                //替换路由的使用
                Get.offAndToNamed("/product-list", arguments: {
                  //把要搜索的内容传给下个页面
                  "keywords": controller.keyWords,
                });
              },
              child: Text(
                "搜索",
                style: TextStyle(
                    fontSize: ScreenAdapter.fontSize(36),
                    color: Colors.black54),
              ))
        ],
        elevation: 0, //阴影为0
      ),
      body: ListView(
        padding: EdgeInsets.all(ScreenAdapter.height(20)),
        children: [
          Obx(() => controller.historyList.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.only(bottom: ScreenAdapter.height(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "搜索历史",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: ScreenAdapter.fontSize(42),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            Get.bottomSheet(Container(
                              padding: EdgeInsets.all(ScreenAdapter.width(20)),
                              color: Colors.white,
                              width: ScreenAdapter.width(1080),
                              height: ScreenAdapter.height(360),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "您确定要清空历史记录吗",
                                        style: TextStyle(
                                            fontSize:
                                                ScreenAdapter.fontSize(48)),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: ScreenAdapter.height(40),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      SizedBox(
                                        width: ScreenAdapter.width(420),
                                        child: ElevatedButton(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        const Color.fromARGB(
                                                            123,
                                                            151,
                                                            147,
                                                            147)),
                                                //字体颜色
                                                foregroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.white)),
                                            onPressed: () {
                                              Get.back();
                                            },
                                            child: const Text("取消")),
                                      ),
                                      SizedBox(
                                        width: ScreenAdapter.width(420),
                                        child: ElevatedButton(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        const Color.fromARGB(
                                                            123,
                                                            151,
                                                            147,
                                                            147)),
                                                foregroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.red)),
                                            onPressed: () {
                                              controller.clearHistoryData();
                                              Get.back();
                                            },
                                            child: const Text("确定")),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ));
                          },
                          icon: const Icon(Icons.delete_forever_outlined)),
                    ],
                  ),
                )
              : const Text("")),
          //使用Obx来监听数据的改变
          Obx(
            () => Wrap(
                //在外层添加一个手势点击控件
                children: controller.historyList
                    .map((value) => GestureDetector(
                          onLongPress: () {
                            //长按触发
                            Get.defaultDialog(
                                title: "提示信息!",
                                middleText: "您确定要删除吗?",
                                confirm: ElevatedButton(
                                    onPressed: () {
                                      Get.back();
                                      controller.removeHistoryData(value);
                                    },
                                    child: const Text("确定")),
                                cancel: ElevatedButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: const Text("取消")));
                          },
                          child: Container(
                            padding: EdgeInsets.fromLTRB(
                                ScreenAdapter.width(32),
                                ScreenAdapter.width(16),
                                ScreenAdapter.width(32),
                                ScreenAdapter.width(16)),
                            margin: EdgeInsets.all(ScreenAdapter.height(16)),
                            decoration: BoxDecoration(
                                //使用decoration 背景颜色必须配置在这个里面
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10) //设置圆角
                                ),
                            child: Text(value),
                          ),
                        ))
                    .toList()),
          ),
          Obx(() => controller.historyList.isNotEmpty
              ? const SizedBox(
                  height: 20,
                )
              : const SizedBox(
                  height: 0.01,
                )),
          Padding(
            padding: EdgeInsets.only(bottom: ScreenAdapter.height(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "猜你想搜",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: ScreenAdapter.fontSize(42),
                  ),
                ),
                Icon(Icons.refresh),
              ],
            ),
          ),
          Wrap(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(
                    ScreenAdapter.width(32),
                    ScreenAdapter.width(16),
                    ScreenAdapter.width(32),
                    ScreenAdapter.width(16)),
                margin: EdgeInsets.all(ScreenAdapter.height(16)),
                decoration: BoxDecoration(
                    //使用decoration 背景颜色必须配置在这个里面
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10) //设置圆角
                    ),
                child: Text("笔记本"),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),

          //热销商品
          Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: ScreenAdapter.height(138),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage("assets/images/hot_search.png"),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(ScreenAdapter.width(20)),
                  child: GridView.builder(
                      shrinkWrap: true, //表示收缩 因为listView 和 GridView都没有固定高度
                      itemCount: 8, //必须设置
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, //两列
                        crossAxisSpacing: ScreenAdapter.width(40), //纵轴间距
                        mainAxisSpacing: ScreenAdapter.height(20), //主轴间距
                        childAspectRatio: 3 / 1, //宽高比
                      ),
                      itemBuilder: ((context, index) {
                        return Row(
                          children: [
                            Container(
                              width: ScreenAdapter.width(120),
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(ScreenAdapter.width(10)),
                              child: Image.network(
                                "https://www.itying.com/images/shouji.png",
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                            Expanded(
                                child: Container(
                              padding: EdgeInsets.all(ScreenAdapter.width(10)),
                              alignment: Alignment.topLeft,
                              child: Text("小米净化器 热水器 小米净化器"),
                            ))
                          ],
                        );
                      })),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
