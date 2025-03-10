import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:xmshop/app/models/category_model.dart';
import 'package:xmshop/app/services/httpsClient.dart';
import 'package:xmshop/app/services/log.dart';

class CategoryController extends GetxController {
  //TODO: Implement CategoryController
  HttpsClient httpsClient = HttpsClient(); //单例

  //选中左边的索引值
  RxInt selectIndex = 0.obs;
  //分类数据
  RxList<CategoryItemModel> leftCategoryList =
      <CategoryItemModel>[].obs; //需要定义成响应式数据
  RxList<CategoryItemModel> rightCategoryList =
      <CategoryItemModel>[].obs; //需要定义成响应式数据
  @override
  void onInit() {
    super.onInit();
    //获取左侧分类列表数据
    getLeftCategoryData();
  }

  void changeIndex(index, id) {
    //静态属性共享存储空间 相当于单例
  
    MyLog(identical(HttpsClient.domain, HttpsClient.domain),StackTrace.current);

    selectIndex.value = index;
    getRightCategoryData(id);
    update();
  }

  //请左侧求分类数据
  getLeftCategoryData() async {
    var response = await httpsClient.get("api/pcate");
    if (response != null) {
      var category = CategoryModel.fromJson(response.data);
      leftCategoryList.value = category.result!;
      getRightCategoryData(leftCategoryList[0].sId!); //这里是进来默认加载数据
      update(); //别忘了更新
    }
  }

  //请求右侧分类数据
  getRightCategoryData(String pid) async {
    var response = await httpsClient.get("api/pcate?pid=$pid");
    if (response != null) {
      var category = CategoryModel.fromJson(response.data);
      rightCategoryList.value = category.result!;
      update(); //别忘了更新
    }
  }
}
