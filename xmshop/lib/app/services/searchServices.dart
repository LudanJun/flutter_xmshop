import 'storage.dart';

//搜索相关服务
class SearchServices {
  //保存历史搜索记录 static静态方法
  static setHistoryData(keywords) async {
    /*
      1.获取本地存储里面的数据 (searchList)

      2.判断本地存储是否有数据

          2.1 如果有数据

              1.读取本地存储的数据
              2.判断本地存储中有没有当前数据.
                如果有不做操作
                如果没有当前数据,本地存储的数据和当前数据拼接后重新写入

          2.2 如果没有数据

              直接把当前数据放在数组中写入到本地存储
    */
    //是可空的数组
    List? searchListData = await Storage.getData("searchList");
    //本地存储有没有数据list
    if (searchListData != null) {
      // any:代表数组里只要有一个满足,就返回 true
      //判断本地存储的数据里有没有刚才传入的数据
      var hasData = searchListData.any((v) {
        return v == keywords;
      });

      if (!hasData) {
        //如果没有当前数据
        //本地数据和当前数据拼接后
        searchListData.add(keywords);
        //重新写入
        await Storage.setData("searchList", searchListData);
      }
      //有数据就不用做任何操作
    } else {
      //果没有数据
      List tempList = [];
      tempList.add(keywords);
      //直接把当前数据放在数组中写入到本地存储
      await Storage.setData("searchList", tempList);
    }
  }

  //获取历史搜索记录
  static Future<List> getHistoryData() async {
    //获取本地保存的数据
    List? searchListData = await Storage.getData("searchList");
    if (searchListData != null) {
      return searchListData;
    } else {
      return [];
    }
  }

  //删除搜索记录
  static deleteHistoryData(keywords) async {
    //获取本地保存的数据
    List? searchListData = await Storage.getData("searchList");
    if (searchListData != null) {
      searchListData.remove(keywords);
      //删除之后重新写入一下listdata
      await Storage.setData("searchList", searchListData);
    }
  }

  //清空搜索记录
  static clearHistoryData() async {
    await Storage.clear("searchList");
  }
}
