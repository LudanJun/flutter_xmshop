import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xmshop/app/models/category_model.dart';
import 'package:xmshop/app/models/focus_model.dart';
import 'package:xmshop/app/models/plist_model.dart';
import 'package:xmshop/app/services/httpsClient.dart';
import 'package:xmshop/app/services/signServices.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  //浮动导航开关
  RxBool flag = false.obs;
  //ScrollController创建滚动控制器才能用来监听滚动视图滚动的状态
  final ScrollController scrollController = ScrollController();

  //轮播图数据
  RxList<FocusItemModel> swiperList = <FocusItemModel>[].obs; //需要定义成响应式数据

  //分类数据
  RxList<CategoryItemModel> categoryList =
      <CategoryItemModel>[].obs; //需要定义成响应式数据

  //热销甄选数据
  RxList<FocusItemModel> bestSellingSwiperList = <FocusItemModel>[].obs;

  //热销列表
  RxList<PlistItemModel> sellingPist = <PlistItemModel>[].obs;

  //热销商品
  RxList<PlistItemModel> bestPlist = <PlistItemModel>[].obs;

  HttpsClient httpsClient = HttpsClient();//单例
  @override
  void onInit() {
    super.onInit();
    //请求轮播图数据请求
    getFocusData();
    //监听滚动视图的方法
    scrollControllerListener();
    //请求顶部滑动分类数据
    getCategoryData();
    //请求热销甄选轮播数据
    getSellingSwiperData();
    //热销列表
    getSellingPlistData();
    //获取热门商品
    getBestPlistData();

  }

  //监听滚动视图的方法
  scrollControllerListener() {
    scrollController.addListener(() {
      //如果滚动10个像素 将把导航设置为白色
      if (scrollController.position.pixels > 10) {
        if (flag.value == false) {
          // print(scrollController.position.pixels);
          flag.value = true;
          update();
        }
      }
      if (scrollController.position.pixels < 10) {
        if (flag.value = true) {
          // print(scrollController.position.pixels);
          flag.value = false;
          update();
        }
      }
    });
  }

  //请求轮播图数据
  getFocusData() async {
    var response = await httpsClient.get("api/focus");
    if (response != null) {
      var focus = FocusModel.fromJson(response.data);
      swiperList.value = focus.result;
      update(); //别忘了更新
    }
  }

  //请求分类数据
  getCategoryData() async {
    var response = await httpsClient.get("api/bestCate");
    if (response != null) {
      var category = CategoryModel.fromJson(response.data);
      categoryList.value = category.result!;
      update(); //别忘了更新
    }
  }

  //获取热销甄选里面的轮播数据
  getSellingSwiperData() async {
    var response =
        await httpsClient.get("api/focus?position=2");
    if (response != null) {
      var sellingSwiper = FocusModel.fromJson(response.data);
      bestSellingSwiperList.value = sellingSwiper.result;
      update(); //别忘了更新
    }
  }

  //热销列表
  getSellingPlistData() async {
    var response = await httpsClient
        .get("api/plist?is_hot=1&pageSize=3");
    if (response != null) {
      var plist = PlistModel.fromJson(response.data);
      sellingPist.value = plist.result;
      update(); //别忘了更新 update会触发view里的Obx
    }
  }

  //获取热门商品数据
  getBestPlistData() async {
    var response =
        await httpsClient.get("api/plist?is_best=1");
    if (response != null) {
      var plist = PlistModel.fromJson(response.data);
      bestPlist.value = plist.result;
      update(); //别忘了更新 update会触发view里的Obx
    }
  }
}
