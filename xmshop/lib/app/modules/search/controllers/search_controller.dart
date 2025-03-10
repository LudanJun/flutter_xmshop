import 'package:get/get.dart';
import 'package:xmshop/app/services/searchServices.dart';
import 'package:xmshop/app/services/storage.dart';

class SearchPageController extends GetxController {
  //TODO: Implement SearchController

  String keyWords = "";
  RxList historyList = [].obs; //响应式搜索历史记录数组

  @override
  void onInit() {
    super.onInit();
    //页面加载就要获取数据
    getHistoryData();
  }

  @override
  void onClose() {
    super.onClose();
  }

  //获取历史记录数组方法
  getHistoryData() async {
    //这个返回可能是一个空的集合而不是null所以不能用 !=null判断
    var tempList = await SearchServices.getHistoryData();
    //如果不等于空的话把tempList赋值给historyList
    if (tempList.isNotEmpty) {
      historyList.addAll(tempList);
      //调用响应式方法更新属性
      update();
    }
  }

  //删除历史记录所有方法
  clearHistoryData() async {
    //清空本地保存的数据
    await SearchServices.clearHistoryData();
    //清空当前历史记录数据
    historyList.clear();
    //清空完执行响应式更新方法
    update();
  }

  //执行单个删除方法
  removeHistoryData(keyWords) async {
    //获取存储的数据列表
    var tempList = await SearchServices.getHistoryData();
    if (tempList.isNotEmpty) {
      //移除要删除的数据
      tempList.remove(keyWords);
      //重新写入
      await Storage.setData("searchList", tempList);
      //注意 当前的数组也要删除
      historyList.remove(keyWords);
      //清空完执行响应式更新方法
      update();
    }
  }
}
