import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xmshop/app/models/pcontent_model.dart';
import 'package:xmshop/app/services/cartServices.dart';
import 'package:xmshop/app/services/httpsClient.dart';
import 'package:xmshop/app/services/screenAdapter.dart';
import 'package:xmshop/app/services/storage.dart';
import 'package:xmshop/app/services/userServices.dart';

class ProductContentController extends GetxController {
  //TODO: Implement ProductContentController
  HttpsClient httpsClient = HttpsClient();

  //ScrollController创建滚动控制器才能用来监听滚动视图滚动的状态
  final ScrollController scrollController = ScrollController();
  GlobalKey gk1 = GlobalKey();
  GlobalKey gk2 = GlobalKey();
  GlobalKey gk3 = GlobalKey();

  //导航透明度
  RxDouble opcity = 0.0.obs;
  //是否显示tabs
  RxBool showTabs = false.obs;
  //实例化详情数据
  var pcontent = PcontentItemModel().obs;
  //保存筛选属性值
  RxString selectedAttr = "".obs;
  //购买的数量
  RxInt buyNum = 1.obs;

  //顶部tab切换数据
  List tabsList = [
    {
      "id": 1,
      "title": "商品",
    },
    {
      "id": 2,
      "title": "详情",
    },
    {
      "id": 3,
      "title": "推荐",
    },
  ];
  //选择的tab标签
  RxInt selectedTabsIndex = 1.obs;

  //attr属性筛选模型
  RxList<PcontentAttrModel> pcontentAttr = <PcontentAttrModel>[].obs;

  //container的位置
  double gk2Position = 0;
  double gk3Position = 0;
  //是否显示详情tab切换
  RxBool showSubHeaderTabs = false.obs;
  //详情tab切换数据
  List subTabsList = [
    {
      "id": 1,
      "title": "商品介绍",
    },
    {
      "id": 2,
      "title": "规格参数",
    },
  ];
  //详情tab切换选择的标签
  RxInt selectedSubTabsIndex = 1.obs;

  @override
  void onInit() {
    super.onInit();
    //监听滚动视图的方法
    scrollControllerListener();
    //获取详情数据
    getContentData();
  }

  //获取元素位置 注意是在渲染后获取的
  getContainerPosition(pixels) {
    //通过box获取高度
    RenderBox box2 = gk2.currentContext!.findRenderObject() as RenderBox;
    //获取纵轴位置
    //获取的位置是屏幕顶部(0,0位置)所以需要减掉-状态栏高度和appbar高度
    gk2Position = box2.localToGlobal(Offset.zero).dy +
        pixels -
        (ScreenAdapter.getStatusBarHeight() +
            ScreenAdapter.height(120)); //当做固定写法

    //通过box获取高度
    RenderBox box3 = gk3.currentContext!.findRenderObject() as RenderBox;
    //获取纵轴位置
    //获取的位置是屏幕顶部(0,0位置)所以需要减掉-状态栏高度和appbar高度
    gk3Position = box3.localToGlobal(Offset.zero).dy +
        pixels -
        (ScreenAdapter.getStatusBarHeight() +
            ScreenAdapter.height(120)); //当做固定写法
    print(gk2Position);
    print(gk3Position);
  }

  @override
  void onClose() {
    super.onClose();
  }

  //监听滚动视图的方法
  scrollControllerListener() {
    scrollController.addListener(() {
      //在这里获取位置 判断只获取一次
      if (gk2Position == 0 && gk3Position == 0) {
        //获取Container高度的时候获取的是距离顶部的高度,如果要从0开始计算要加下滚动条下拉的高度
        getContainerPosition(scrollController.position.pixels);
      }
      //显示隐藏详情tab切换
      if (scrollController.position.pixels > gk2Position &&
          scrollController.position.pixels < gk3Position) {
        if (showSubHeaderTabs.value == false) {
          showSubHeaderTabs.value = true;
          selectedTabsIndex.value = 2;
          update();
        }
      } else if (scrollController.position.pixels > 0 &&
          scrollController.position.pixels < gk2Position) {
        if (showSubHeaderTabs.value == true) {
          showSubHeaderTabs.value = false;
          selectedTabsIndex.value = 1;
          update();
        }
      } else if (scrollController.position.pixels > gk2Position) {
        if (showSubHeaderTabs.value == true) {
          showSubHeaderTabs.value = false;
          selectedTabsIndex.value = 3;
          update();
        }
      }

      //显示隐藏顶部tab切换
      if (scrollController.position.pixels <= 100) {
        opcity.value = scrollController.position.pixels / 100;
        print(opcity.value);
        if (opcity.value > 0.7) {
          opcity.value = 1;
        }
        //当滑动大于100的时候显示tabs标签
        if (showTabs.value == true) {
          showTabs.value = false;
        }
        update();
      } else {
        //
        if (showTabs.value == false) {
          showTabs.value = true;
          update();
        }
      }
    });
  }

  //改变顶部tab索引值
  void changeSelectedTabsindex(index) {
    selectedTabsIndex.value = index;
    update();
  }

  //改变商品内容tab索引值
  void changeSelectedSubTabsindex(index) {
    selectedSubTabsIndex.value = index;
    //点击商品介绍 或者规格参数 要重新跳到起始位置,
    //使用scrollController.jumpTo();方法
    scrollController.jumpTo(gk2Position);
    update();
  }

  //获取详情数据
  getContentData() async {
    var response =
        await httpsClient.get("api/pcontent?id=${Get.arguments["id"]}");
    if (response != null) {
      var tempData = PcontentModel.fromJson(response.data);
      pcontent.value = tempData.result!;
      pcontentAttr.value = pcontent.value.attr!; //把属性数据传过来 准备修改
      initAttr(pcontentAttr); //初始化attr
      setSelectedAttr(); //获取商品属性
      update(); //别忘了更新
    }
  }

  //初始化attr 对属性列表进行改造
  initAttr(List<PcontentAttrModel> attr) {
    for (var i = 0; i < attr.length; i++) {
      for (var j = 0; j < attr[i].list!.length; j++) {
        if (j == 0) {
          attr[i].attrList!.add({
            //可能为空需要加类型断言!
            "title": attr[i].list![j],
            "checked": true,
          });
        } else {
          attr[i].attrList!.add({
            //可能为空需要加类型断言!
            "title": attr[i].list![j],
            "checked": false,
          });
        }
      }
    }
  }

  //改变attr 如果拿到cate 颜色  title 玫瑰红
  changeAttr(cate, title) {
    for (var i = 0; i < pcontentAttr.length; i++) {
      //如果选择的颜色等于数组里的数据
      if (pcontentAttr[i].cate == cate) {
        //就拿到了i对应的数据下标 再进行循环
        for (var j = 0; j < pcontentAttr[i].attrList!.length; j++) {
          //先让所有的checked等于false
          pcontentAttr[i].attrList![j]["checked"] = false;
          //如果选择的标题等于数组里的数据 就找到了对应要修改的数据
          if (pcontentAttr[i].attrList![j]["title"] == title) {
            pcontentAttr[i].attrList![j]["checked"] = true;
          }
        }
      }
    }
    update();
  }

  //获取attr属性
  setSelectedAttr() {
    List tempList = [];
    for (var i = 0; i < pcontentAttr.length; i++) {
      //就拿到了i对应的数据下标 再进行循环
      for (var j = 0; j < pcontentAttr[i].attrList!.length; j++) {
        if (pcontentAttr[i].attrList![j]["checked"]) {
          tempList.add(pcontentAttr[i].attrList![j]["title"]);
        }
      }
    }
    selectedAttr.value = tempList.join(",");
    update();
  }

  //增加数量
  incBuyNum() {
    buyNum.value++;
    update();
  }

  //减少数量
  decBuyNum() {
    if (buyNum.value > 1) {
      buyNum.value--;
      update();
    }
  }

  //添加购物车
  void addCart() {
    setSelectedAttr();
    print("加入购物车");
    CartServices.addCart(pcontent.value, selectedAttr.value, buyNum.value);
    Get.back();
    Get.snackbar("提示?", "加入购物车成功", snackPosition: SnackPosition.TOP);
  }

  //立即购买
  void buy() async{
    setSelectedAttr();
    print("立即购买");

    //先判断用户有没有登录
    bool loginState = await isLogin();
    if(loginState){
      //保存商品信息
      List tempList = [];
      tempList.add({
        "_id":pcontent.value.sId,
        "title": pcontent.value.title,
        "price":pcontent.value.price,
        "selectedAttr":selectedAttr.value,
        "count":buyNum.value,
        "pic":pcontent.value.pic,
        "checked":true
      });

      Storage.setData("checkoutList", tempList);
      //执行跳转
      Get.toNamed("/checkout");

    }else{
       //执行跳转 到登录页面
      Get.toNamed("/code-login-step-one");
      Get.snackbar("提示信息!", "您还没有登录,请先登录");
    }
    // Get.back();

  }

  //判断用户有没有登录
  Future<bool> isLogin() async {
    return await UserServices.getUserLoginState();
  }

  //获取要结算的商品
}




/**
 *  ，[{cate:颜色，list:[土豪金，玫瑰红，磨砂黑]},{cate:颜色，list:[土豪金，玫瑰红，磨砂黑]},]
 * 改成如下结构
 *    [
 *      {
 *        cate:颜色，
 *        list:[
 *              {
 *                title:土豪金,
 *                checked:true,
 *               },
 *              {
 *                title:土豪金,
 *                checked:true,
 *               },
 *               {
 *                title:土豪金,
 *                checked:true,
 *               },
 *          ]
 *      }
 *    ]
 * 
 */
