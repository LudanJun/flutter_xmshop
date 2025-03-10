import 'package:xmshop/app/models/pcontent_model.dart';

import 'storage.dart';

// 购物车数据存储服务
class CartServices {
  // 增加购物车
  //  传入商品模型 选择的属性  商品数量
  static addCart(
      PcontentItemModel pcontent, String selectedAttr, int buyNum) async {
    /*
      1、获取本地存储的cartList数据
      2、判断cartList是否有数据
            有数据:
                  1、判断购物车有没有当前数据:
                          有当前数据:
                              1、让购物车中的当前数据数量 等于以前的数量+现在的数量
                              2、重新写入本地存储
                          没有当前数据:
                              1、把购物车cartList的数据和当前数据拼接，拼接后重新写入本地存储。
            没有数据:
                1、把当前商品数据以及属性数据放在数组中然后写入本地存储
    */
    //是可空的数组
    List? cartListData = await Storage.getData("cartList");
    if (cartListData != null) {
      var hasData = cartListData.any((v) {
        return v["_id"] == pcontent.sId && v["selectedAttr"] == selectedAttr;
      });
      if (hasData) {
        for (var i = 0; i < cartListData.length; i++) {
          if (cartListData[i]["_id"] == pcontent.sId &&
              cartListData[i]["selectedAttr"] == selectedAttr) {
            cartListData[i]["count"] += buyNum;
          }
        }
        await Storage.setData("cartList", cartListData);
      } else {
        cartListData.add({
          "_id": pcontent.sId,
          "title": pcontent.title,
          "price": pcontent.price,
          "selectedAttr": selectedAttr,
          "count": buyNum,
          "pic": pcontent.pic,
          "checked": true
        });
        await Storage.setData("cartList", cartListData);
      }
    } else {
      List tempList = [];
      tempList.add({
        "_id": pcontent.sId,
        "title": pcontent.title,
        "price": pcontent.price,
        "selectedAttr": selectedAttr,
        "count": buyNum,
        "pic": pcontent.pic,
        "checked": true
      });
      await Storage.setData("cartList", tempList);
    }
  }

  //获取购物车
  static Future<List> getCartList() async {
    List? cartListData = await Storage.getData("cartList");
    if (cartListData != null) {
      return cartListData;
    } else {
      return [];
    }
  }

  //加减添加数据到缓存
  static void setCartList(cartListData) async {
    await Storage.setData("cartList", cartListData);
  }

  // 获取选中的CartList数据
  static getCheckedCartData() async {
    List tempList = [];
    List? cartListData = await Storage.getData("cartList");
    if (cartListData != null) {
      for (var i = 0; i < cartListData.length; i++) {
        if (cartListData[i]["checked"] == true) {
          tempList.add(cartListData[i]);
        }
      }
      return cartListData;
    } else {
      return [];
    }
  }

  //清空购物车
  static clearCartData() async {
    await Storage.clear('cartList');
  }

  //结算后删除购物车中要结算的商品
  static deleteCheckOutData(checkOutList) async {
    List? cartListData = await Storage.getData("cartList");
    if (cartListData != null) {
      var tempList = [];
      //循环变量购物车列表里的数据
      for (var i = 0; i < cartListData.length; i++) {
        //没有 包含勾选的数据  
        if (!hasCheckOutData(checkOutList, cartListData[i])) {
          //把未勾选的数据保存临时变量
          tempList.add(cartListData[i]);
        }
      }
      //保存数据到购物车 这样结算过的商品就删除了 只留为结算的数据在购物车
      setCartList(tempList);
    }
  }

  //判断购物车勾选的商品列表数组 是否包含在购物车整个商品列表里
  static hasCheckOutData(checkOutList, cartItem) {
    //遍历要结算的商品列表
    for (var i = 0; i < checkOutList.length; i++) {
      //如果勾选的商品数组元素 包含在整个购物车列表数组里面
      if (checkOutList[i]["_id"] == cartItem["_id"] &&
          //有的话返回true
          checkOutList[i]["selectedAttr"] == cartItem["selectedAttr"]) {
        return true;
      }
    }
    return false;
  }
}
