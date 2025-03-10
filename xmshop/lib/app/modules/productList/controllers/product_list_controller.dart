import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xmshop/app/models/plist_model.dart';
import 'package:xmshop/app/services/httpsClient.dart';
import 'package:xmshop/app/services/log.dart';

class ProductListController extends GetxController {
  //TODO: Implement ProductListController
  HttpsClient httpsClient = HttpsClient();
  RxInt page = 1.obs; //分页
  int pageSize = 8; //默认数据 可以不用写成响应式数据
  bool flag = true; //设置开关来控制数据多次加载问题
  RxBool hasData = true.obs; //判断有没有数据
  //获取控制器监听滚动条事件,来进行上拉加载
  ScrollController scrollController = ScrollController();
  //指定数据类型
  RxList<PlistItemModel> plist = <PlistItemModel>[].obs;
  //调用globalkey可以获取currentState根据这个可以弹出侧边栏 传入ScaffoldState才能拿到对应方法
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  //排序默认为空
  String sort = "";
  //响应式数据来改变排序箭头 主要来解决箭头无法更新
  RxInt subHeaderListSort = 0.obs;
  //接收上级搜索页面传入的搜索内容 可空类型可不传入
  String? keywords = Get.arguments['keywords'];
  //获取产品id 如果有cid就是从分类页面进来的 没有cid就是从搜索页面进来
  String? cid = Get.arguments['cid'];
  String apiUri = ""; //用来拼接请求地址

  /*二级导航数据*/
  List subHeaderList = [
    {
      "id": 1,
      "title": "综合",
      "fileds": "all",
      "sort": -1, //排序 升序 price_1 {price:1} 降序:price_-1
    },
    {"id": 2, "title": "销量", "fileds": "salecount", "sort": -1},
    {"id": 3, "title": "价格", "fileds": "price", "sort": -1},
    {"id": 4, "title": "筛选"}
  ];
  //二级导航选中判断
  RxInt selectHeaderId = 1.obs;

  @override
  void onInit() {
    super.onInit();
    //绑定动态流数据的时候 通过控制器获得值
    // MyLog(Get.arguments,StackTrace.current);
    //获取商品列表数据
    getPlistData();
    scrollControllerLinser(); //记得调用方法
  }

  //监听滚动条事件
  scrollControllerLinser() {
    scrollController.addListener(() {
      // scrollController.position.pixels//获取滚动条下拉高度
      // scrollController.position.maxScrollExtent //获取滚动页面高度
      if ((scrollController.position.pixels >
          (scrollController.position.maxScrollExtent - 20))) {
        getPlistData();
      }
    });
  }

  //二级导航选择改变触发
  void subHeaderChange(id) {
    if (id == 4) {
      selectHeaderId.value = id;
      //弹出侧边栏
      scaffoldGlobalKey.currentState!.openEndDrawer();
    } else {
      selectHeaderId.value = id;

      //改变排序 sort=price_-1
      sort =
          "${subHeaderList[id - 1]["fileds"]}_${subHeaderList[id - 1]["sort"]}";
      //-1*-1 = 1   1*-1=-1  升降序排序 切换箭头
      subHeaderList[id - 1]["sort"] = subHeaderList[id - 1]["sort"] * -1;
      //作用更新状态
      subHeaderListSort.value = subHeaderList[id - 1]["sort"];

      //重置page
      page.value = 1;
      //重置数据
      plist.value = [];
      //重置hasData
      hasData.value = true;
      //滚动条回到顶部
      scrollController.jumpTo(0);
      //重新请求接口
      getPlistData();
    }
  }

  @override
  void onClose() {
    super.onClose();
  }

  //获取商品列表数据
  getPlistData() async {
    if (flag == true && hasData.value == true) {
      //当为true 才可以触发请求
      flag = false; //然后设置为false

      if (cid != null) {
        //分类页面进来
        apiUri =
            "api/plist?cid=$cid&page=${page.value}&pageSize=$pageSize&sort=$sort";
      } else {//搜索页面进来
        apiUri =
            "api/plist?search=$keywords&page=${page.value}&pageSize=$pageSize&sort=$sort";
      }

      print(
          "api/plist?cid=${Get.arguments["cid"]}&page=${page.value}&pageSize=$pageSize&sort=$sort");
      var response = await httpsClient.get(apiUri);
      if (response != null) {
        var plistTemp = PlistModel.fromJson(response.data);
        //注意需要拼接数据而不是把上次数据替换掉
        //拼接数据
        plist.addAll(plistTemp.result);
        // plist.value = plistTemp.result;
        page++;
        update(); //别忘了更新 update会触发view里的Obx
        flag = true; //当数据都请求加载好之后再改成true
        if (plistTemp.result.length < pageSize) {
          //表示没有数据了
          hasData.value = false; //解决没有数据了还继续请求
        }
      }
    }
  }
}
