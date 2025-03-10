import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';

import 'package:get/get.dart';
import 'package:xmshop/app/services/hooFonts.dart';
import 'package:xmshop/app/services/httpsClient.dart';
import 'package:xmshop/app/services/keepAliveWrapper.dart';
import 'package:xmshop/app/services/screenAdapter.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  //顶部导航  _下划线代表是私有变量
  Widget _appBar() {
    return Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: Obx(
          //使用obs包裹要监听改变的控件
          () => AppBar(
            leading: Icon(
              HooFonts.xiaomi,
              color: controller.flag.value ? Colors.orange : Colors.white,
            ),
            leadingWidth: controller.flag.value
                ? ScreenAdapter.width(40)
                : ScreenAdapter.width(140),
            title: InkWell(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                //设置搜索栏
                width: controller.flag.value
                    ? ScreenAdapter.width(800)
                    : ScreenAdapter.width(620),
                height: ScreenAdapter.height(96),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(246, 246, 246, 1), //搜索框背景颜色
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(ScreenAdapter.width(34), 0,
                          ScreenAdapter.width(10), 0),
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
              onTap: () {
                Get.toNamed("/search");
              },
            ),
            centerTitle: true,
            backgroundColor: controller.flag.value
                ? Colors.white
                : Colors.transparent, //实现背景透明
            elevation: 0, //去掉阴影

            actions: [
              //创建右边图标
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.qr_code,
                    color:
                        controller.flag.value ? Colors.black87 : Colors.white,
                  )),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.message,
                    color:
                        controller.flag.value ? Colors.black87 : Colors.white,
                  ))
            ],
          ),
        ));
  }

  //轮播图
  Widget _focus() {
    return SizedBox(
      width: ScreenAdapter.width(1080),
      height: ScreenAdapter.height(682),
      child: Obx(
        () => Swiper(
          itemBuilder: (context, index) {
            // String picUrl = "https://miapp.itying.com/${controller.swiperList[index]["pic"]}";
            // String picUrl =
            //     "https://miapp.itying.com/${controller.swiperList[index].pic}";
            return Image.network(
              HttpsClient.replaeUri(
                  controller.swiperList[index].pic), //把/ 转移成 \
              fit: BoxFit.fill,
            );
          },
          itemCount: controller.swiperList.length,
          pagination:
              const SwiperPagination(builder: SwiperPagination.rect //可以不设置默认是圆点
                  ), //分页指示器
          // control: const SwiperControl(),//分页按钮箭头
          autoplay: true, //自动轮播
          loop: true, //无限轮播
          // duration: 1000,播放动画时间
        ),
      ),
    );
  }

  //banner
  Widget _banner() {
    return SizedBox(
      width: ScreenAdapter.width(1080),
      height: ScreenAdapter.height(92),
      child: Image.asset("assets/images/xiaomiBanner.png", fit: BoxFit.cover),
    );
  }

  //顶部滑动分类
  Widget _category() {
    return Obx(() => Container(
          width: ScreenAdapter.width(1080),
          height: ScreenAdapter.height(470),
          color: Colors.white,
          child: Swiper(
            itemBuilder: (context, index) {
              //这个index 是0-1的值 有几页
              return GridView.builder(
                  itemCount: 10,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5, //一行显示5个元素
                    crossAxisSpacing: ScreenAdapter.width(20), //间距
                    mainAxisSpacing: ScreenAdapter.height(20), //向下来
                  ),
                  itemBuilder: (context, i) {
                    //这个代表每页多少个 0-9
                    // //处理图片
                    // String picUrl =
                    //     "https://miapp.itying.com/${controller.categoryList[index * 10 + i].pic}";

                    return Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: ScreenAdapter.height(140),
                          height: ScreenAdapter.height(140),
                          child: Image.network(
                            HttpsClient.replaeUri(
                                controller.categoryList[index * 10 + i].pic),
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              0, ScreenAdapter.height(4), 0, 0),
                          child: Text(
                            "${controller.categoryList[index * 10 + i].title}",
                            style:
                                TextStyle(fontSize: ScreenAdapter.fontSize(34)),
                          ),
                        ),
                      ],
                    );
                  });
            },
            itemCount: controller.categoryList.length ~/ 10, // ~/代表取整
            pagination: SwiperPagination(
                //自定义分页指示器
                margin: const EdgeInsets.all(0),
                builder: SwiperCustomPagination(
                  builder: (BuildContext context, SwiperPluginConfig config) {
                    return ConstrainedBox(
                      constraints: BoxConstraints.expand(
                          height: ScreenAdapter.height(20)),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Align(
                              alignment: Alignment.center,
                              child: const RectSwiperPaginationBuilder(
                                color: Colors.black12,
                                activeColor: Colors.black54,
                              ).build(context, config),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                )), //分页指示器
          ),
        ));
  }

  //banner2
  Widget _banner2() {
    return Padding(
      padding: EdgeInsets.fromLTRB(ScreenAdapter.width(20),
          ScreenAdapter.height(20), ScreenAdapter.width(20), 0),
      child: Container(
        decoration: BoxDecoration(
            //实现圆角图
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            image: const DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                  "assets/images/xiaomiBanner2.png",
                ))),
        height: ScreenAdapter.height(420),
        // child:
        //     Image.asset("assets/images/xiaomiBanner2.png", fit: BoxFit.cover),
      ),
    );
  }

  //热销甄选
  Widget _bestSelling() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
              ScreenAdapter.width(30),
              ScreenAdapter.height(40),
              ScreenAdapter.width(30),
              ScreenAdapter.height(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, //左右分开布局
            crossAxisAlignment: CrossAxisAlignment.center, //行内元素上下居中
            children: [
              Text(
                "热销甄选",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: ScreenAdapter.fontSize(46),
                ),
              ),
              Text(
                "更多手机推荐 >",
                style: TextStyle(
                  fontSize: ScreenAdapter.fontSize(38),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(ScreenAdapter.width(20), 0,
              ScreenAdapter.width(20), ScreenAdapter.height(20)),
          child: Row(
            children: [
              //左右排列
              //左侧
              Expanded(
                  flex: 1, //占1分
                  child: SizedBox(
                      height: ScreenAdapter.height(738),
                      child: Obx(
                        () => Swiper(
                          itemBuilder: (context, index) {
                            // String picUrl =
                            //     "https://xiaomi.itying.com/${controller.bestSellingSwiperList[index].pic}";
                            return Image.network(
                              HttpsClient.replaeUri(controller
                                  .bestSellingSwiperList[index].pic), //把\转移成 /
                              fit: BoxFit.fill,
                            );
                          },
                          itemCount:
                              controller.bestSellingSwiperList.length, //轮播页数
                          pagination: SwiperPagination(
                              //自定义分页指示器
                              margin: const EdgeInsets.all(0),
                              builder: SwiperCustomPagination(
                                builder: (BuildContext context,
                                    SwiperPluginConfig config) {
                                  return ConstrainedBox(
                                    constraints: BoxConstraints.expand(
                                        //调整指示器高度
                                        height: ScreenAdapter.height(36)),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.center,
                                            child:
                                                const RectSwiperPaginationBuilder(
                                              color: Colors.black12,
                                              activeColor: Colors.black54,
                                            ).build(context, config),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              )), //分页指示器
                          // control: const SwiperControl(),//分页按钮箭头
                          autoplay: true, //自动轮播
                          loop: true, //无限轮播
                          // duration: 1000,播放动画时间
                        ),
                      ))),
              SizedBox(
                width: ScreenAdapter.width(20),
              ),
              //右侧
              Expanded(
                  flex: 1, //占1分
                  child: SizedBox(
                      height: ScreenAdapter.height(738),
                      // color: Colors.white,
                      child: Obx(
                        () => Column(
                            //默认map是拿不到key的,需要调用.asMap().entries.map
                            children: controller.sellingPist
                                .asMap()
                                .entries
                                .map((entries) {
                          var value = entries.value;
                          //循环创建三个子组件
                          var pic = "https://miapp.itying.com/${value.pic}";
                          return Expanded(
                              flex: 1,
                              child: Container(
                                color: const Color.fromRGBO(238, 238, 238, 1),
                                //用这种方式来添加 每个子控件里的间隙
                                margin: EdgeInsets.fromLTRB(
                                    0,
                                    0,
                                    0,
                                    entries.key == 2
                                        ? 0
                                        : ScreenAdapter.height(20)),
                                child: Row(
                                  children: [
                                    Expanded(
                                        flex: 3,
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: ScreenAdapter.height(20),
                                            ),
                                            Text(
                                              "${value.title}",
                                              style: TextStyle(
                                                  fontSize:
                                                      ScreenAdapter.fontSize(
                                                          38),
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              height: ScreenAdapter.height(20),
                                            ),
                                            Text(
                                              "${value.subTitle}",
                                              style: TextStyle(
                                                  fontSize:
                                                      ScreenAdapter.fontSize(
                                                          28)),
                                            ),
                                            SizedBox(
                                              height: ScreenAdapter.height(20),
                                            ),
                                            Text(
                                              "${value.price}",
                                              style: TextStyle(
                                                  fontSize:
                                                      ScreenAdapter.fontSize(
                                                          34)),
                                            ),
                                          ],
                                        )),
                                    Expanded(
                                        flex: 2,
                                        child: Padding(
                                          padding: EdgeInsets.all(
                                              ScreenAdapter.height(8)),
                                          child: Image.network(
                                            pic,
                                            fit: BoxFit.cover,
                                          ),
                                        )),
                                  ],
                                ),
                              ));
                        }).toList()),
                      ))),
            ],
          ),
        )
      ],
    );
  }

  //热销商品
  Widget _bestGoods() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
              ScreenAdapter.width(30),
              ScreenAdapter.height(40),
              ScreenAdapter.width(30),
              ScreenAdapter.height(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, //左右分开布局
            crossAxisAlignment: CrossAxisAlignment.center, //行内元素上下居中
            children: [
              Text(
                "省心优惠",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: ScreenAdapter.fontSize(46),
                ),
              ),
              Text(
                "全部优惠 >",
                style: TextStyle(
                  fontSize: ScreenAdapter.fontSize(38),
                ),
              )
            ],
          ),
        ),
        Obx(
          () => Container(
            padding: EdgeInsets.all(ScreenAdapter.height(20)),
            color: const Color.fromRGBO(246, 246, 246, 1), //瀑布流外部容器添加的背景颜色
            child: MasonryGridView.count(
                //使用该方式实现瀑布流
                crossAxisCount: 2, //展示几列
                mainAxisSpacing: ScreenAdapter.width(26),
                crossAxisSpacing: ScreenAdapter.width(26),
                itemCount: controller.bestPlist.length, //元素总个数
                shrinkWrap: true, //收缩,让元素宽度自适应
                physics: const NeverScrollableScrollPhysics(), //禁止滑动
                //单个子元素
                itemBuilder: (context, index) {
                  // var picUrl =
                  //     "https://miapp.itying.com/${controller.bestPlist[index].sPic}";
                  //生成随机高度
                  // var height =50+150*Random().nextDouble();
                  return InkWell(
                    onTap: () {
                      Get.toNamed("/product-content", arguments: {
                        //传入对应参数
                        "id": controller.bestPlist[index].sId
                      }); //跳转到商品详情
                    },
                    child: Container(
                      // height: height,//设置内容高度
                      padding: EdgeInsets.all(ScreenAdapter.width(20)),
                      decoration: BoxDecoration(
                        // border: Border.all(color: Colors.black, width: 1), //边框宽度和颜色
                        borderRadius: BorderRadius.circular(10), //圆角
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(ScreenAdapter.width(10)),
                            child: Image.network(
                              HttpsClient.replaeUri(
                                  controller.bestPlist[index].sPic),
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(ScreenAdapter.width(10)),
                            //外面加个容器就可以实现对齐
                            width: double.infinity,
                            child: Text(
                              controller.bestPlist[index].title,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: ScreenAdapter.fontSize(42),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(ScreenAdapter.width(10)),
                            //外面加个容器就可以实现对齐
                            width: double.infinity,
                            child: Text(
                              controller.bestPlist[index].subTitle,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: ScreenAdapter.fontSize(32),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(ScreenAdapter.width(10)),
                            //外面加个容器就可以实现对齐
                            width: double.infinity,
                            child: Text(
                              "¥${controller.bestPlist[index].price}",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: ScreenAdapter.fontSize(32),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ),
        )
      ],
    );
  }

  //内容区域
  Widget _homePage() {
    return Positioned(
        top: -ScreenAdapter.height(164),
        right: 0,
        bottom: 0,
        left: 0, //
        child: ListView(
          controller: controller.scrollController,
          children: [
            _focus(),
            _banner(),
            _category(),
            _banner2(),
            _bestSelling(),
            _bestGoods(),
            const SizedBox(
              height: 100,
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return KeepAliveWrapper(
        child: Scaffold(
      //默认自带的屏蔽
      body: Stack(
        children: [
          //添加内容
          _homePage(),
          //添加自定义导航appbar组件
          _appBar(),
        ],
      ),
    ));
  }
}

/**
 * 
 * 

ListView.builder(
          controller: controller.scrollController, //绑定监听滚动
          itemCount: 20,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Container(
                width: ScreenAdapter.width(1080),
                height: ScreenAdapter.height(682),
                child: Image.network(
                  "http://www.itying.com/images/focus/focus02.png",
                  fit: BoxFit.cover,
                ),
              );
            } else {
              return ListTile(
                title: Text("第$index个列表"),
              );
            }
          }),
 */
