import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:xmshop/app/services/colors.dart';
import 'package:xmshop/app/services/httpsClient.dart';
import 'package:xmshop/app/services/log.dart';
import 'package:xmshop/app/services/screenAdapter.dart';

import '../controllers/product_list_controller.dart';

class ProductListView extends GetView<ProductListController> {
  //商品列表
  Widget _productListWiget() {
    return  ListView.builder(
            controller: controller.scrollController,
            padding: EdgeInsets.fromLTRB(
                ScreenAdapter.width(26),
                ScreenAdapter.height(130),
                ScreenAdapter.width(26),
                ScreenAdapter.height(26)),
            itemCount: controller.plist.length,
            itemBuilder: ((context, index) {
              return Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),

                    margin: EdgeInsets.only(
                        bottom: ScreenAdapter.height(26)), //容器内每个子容器间距
                    child: Row(
                      children: [
                        //左侧
                        Container(
                          padding: EdgeInsets.all(ScreenAdapter.width(60)),
                          width: ScreenAdapter.width(400),
                          height: ScreenAdapter.height(460),
                          // color: randomColor(),
                          child: Image.network(
                            "${HttpsClient.replaeUri(controller.plist[index].pic)}",
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                        //右侧
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start, //整体居左显示
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom: ScreenAdapter.height(20)),
                              child: Text(
                                "${controller.plist[index].title}",
                                style: TextStyle(
                                    fontSize: ScreenAdapter.fontSize(42),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom: ScreenAdapter.height(20)),
                              child: Text(
                                "${controller.plist[index].subTitle}",
                                style: TextStyle(
                                    fontSize: ScreenAdapter.fontSize(34),
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  bottom: ScreenAdapter.height(20)),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Column(
                                    children: [
                                      Text(
                                        "CPU",
                                        style: TextStyle(
                                            fontSize:
                                                ScreenAdapter.fontSize(34),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "Helio G25",
                                        style: TextStyle(
                                            fontSize:
                                                ScreenAdapter.fontSize(34),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )),
                                  Expanded(
                                      child: Column(
                                    children: [
                                      Text(
                                        "高清拍摄",
                                        style: TextStyle(
                                            fontSize:
                                                ScreenAdapter.fontSize(34),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "1300万像素",
                                        style: TextStyle(
                                            fontSize:
                                                ScreenAdapter.fontSize(34),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )),
                                  Expanded(
                                      child: Column(
                                    children: [
                                      Text(
                                        "超大屏",
                                        style: TextStyle(
                                            fontSize:
                                                ScreenAdapter.fontSize(34),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "6.1寸",
                                        style: TextStyle(
                                            fontSize:
                                                ScreenAdapter.fontSize(34),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )),
                                ],
                              ),
                            ),
                            Text(
                              "¥${controller.plist[index].price}起",
                              style: TextStyle(
                                  fontSize: ScreenAdapter.fontSize(38),
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ))
                      ],
                    ),
                  ),
                  (index == controller.plist.length - 1)
                      ? _progressIndicator()
                      : const SizedBox(
                          height: 1,
                        ),
                ],
              );
            }));
        // : _progressIndicator());
  }

  Widget _subHeaderWidget() {
    return Positioned(
        left: 0,
        right: 0,
        top: 0,
        child: Obx(() => Container(
            height: ScreenAdapter.height(120),
            width: ScreenAdapter.width(1080),
            decoration: BoxDecoration(
                color: Colors.white, //颜色要放到这里面,放外面报错
                border: Border(
                    //配置边框
                    bottom: BorderSide(
                  //设置底部边框的线
                  width: ScreenAdapter.height(2),
                  color: const Color.fromRGBO(233, 233, 233, 0.9),
                ))),
            //行组件没办法加背景颜色 需要再外面套一个Container
            child: Row(
                children: controller.subHeaderList.map((value) {
              return Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                            0,
                            ScreenAdapter.height(16),
                            0,
                            ScreenAdapter.height(16)),
                        child: Text(
                          "${value["title"]}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: controller.selectHeaderId == value["id"]
                                  ? Colors.red
                                  : Colors.black54,
                              fontSize: ScreenAdapter.fontSize(32)),
                        ),
                      ),
                      onTap: () {
                        controller.subHeaderChange(value["id"]);
                      },
                    ),
                    //添加排序箭头
                    _showIcon(value["id"]),
                  ],
                ),
              );
            }).toList()))));
    // [
    /*
              Expanded(
                  flex: 1,
                  child: InkWell(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, ScreenAdapter.height(16),
                          0, ScreenAdapter.height(16)),
                      child: Text(
                        "销量",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: ScreenAdapter.fontSize(32)),
                      ),
                    ),
                    onTap: () {},
                  )),
              Expanded(
                  flex: 1,
                  child: InkWell(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, ScreenAdapter.height(16),
                          0, ScreenAdapter.height(16)),
                      child: Text(
                        "价格",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: ScreenAdapter.fontSize(32)),
                      ),
                    ),
                    onTap: () {},
                  )),
              Expanded(
                  flex: 1,
                  child: InkWell(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, ScreenAdapter.height(16),
                          0, ScreenAdapter.height(16)),
                      child: Text(
                        "筛选",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: ScreenAdapter.fontSize(32)),
                      ),
                    ),
                    onTap: () {
                      // 点击筛选弹出侧边栏
                      //注意:新版本中ScaffoldState? 为空类型,注意判断
                      controller.scaffoldGlobalKey.currentState!.openEndDrawer();

                    },
                  )),
           */
    // ],
  }

  //自定义箭头组件
  Widget _showIcon(id) {
    //如果一直点击同一个按钮的话数据没有变化 obx包含的控件只刷新一次
    print("----");
    print(id);

    if (id == 2 ||
        id == 3 ||
        controller.subHeaderListSort.value == 1 ||
        controller.subHeaderListSort.value == -1) {
      //controller.subHeaderListSort.value改变这个响应式状态值,让重新刷新界面
      if (controller.subHeaderList[id - 1]["sort"] == 1) {
        return const Icon(Icons.arrow_drop_down, color: Colors.black54);
      } else {
        return const Icon(Icons.arrow_drop_up, color: Colors.black54);
      }
    } else {
      return const Text("");
    }
  }

  //自定义加载圈圈
  Widget _progressIndicator() {
    if (controller.hasData.value) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return const Center(
        child: Text("没有数据了哦,我是有底线的!"),
      );
    }
  }

  const ProductListView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    //获取上个页面的传值
    // MyLog(Get.arguments, StackTrace.current);
    return Scaffold(
      //绑定key
      key: controller.scaffoldGlobalKey,
      backgroundColor: const Color.fromRGBO(246, 246, 246, 1), //主控制器背景颜色
      endDrawer: const Drawer(
        //右边侧滑栏 默认有个按钮
        child: DrawerHeader(child: Text("右侧筛选")),
      ),

      appBar: AppBar(
        title: Container(
          // duration: const Duration(milliseconds: 300),
          //设置搜索栏
          width: ScreenAdapter.width(900),
          height: ScreenAdapter.height(96),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(246, 246, 246, 1), //瀑布流外部容器添加的背景颜色
            borderRadius: BorderRadius.circular(30), //圆角设置
          ),
          child: InkWell(
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
                  controller.keywords != null ? "${controller.keywords}" : "",
                  style: TextStyle(
                    fontSize: ScreenAdapter.fontSize(32),
                    color: Colors.black54,
                  ),
                )
              ],
            ),
            onTap: (){
              Get.offAndToNamed("/search");
            },
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0, //阴影为0
        actions: [
          Text(""), //加个空的控件就不会显示右侧导航右侧按钮了
        ], //endDrawer侧边栏图标按钮去掉 设置为空数组
      ),
      body:Obx(() => controller.plist.isNotEmpty
        ? Stack(
        //商品规格选择用tools 定位布局来实现
        children: [
          _productListWiget(),
          _subHeaderWidget(),
        ],
      ):_progressIndicator(),
    ));
  }
}
