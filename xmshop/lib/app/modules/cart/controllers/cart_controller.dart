import 'package:get/get.dart';
import 'package:xmshop/app/services/cartServices.dart';
import 'package:xmshop/app/services/storage.dart';
import 'package:xmshop/app/services/userServices.dart';

class CartController extends GetxController {
  //TODO: Implement CartController
  //购物车列表数据数组
  RxList cartList = [].obs;
  //全选 响应式数据
  RxBool checkAllBox = false.obs;
  //判断是否编辑
  RxBool isEdit = false.obs;
  //总价
  RxDouble allPrice=0.0.obs;

  @override
  void onInit() {
    //init只会执行一次
    super.onInit();
    // CartServices.clearCartData();
    // getCartListData();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void getCartListData() async {
    var tempList = await CartServices.getCartList();
    cartList.value = tempList;

    //获取数据的时候需要判断是否是全选状态
    checkAllBox.value = isCheckedAll();

    //计算总价
    computedAllPrice();

    update();
  }

  //增加数量
  void incBuyNum(cartItem) {
    print("+++");
    var tempList = [];
    //在这里循环变量传入的数据
    for (var i = 0; i < cartList.length; i++) {
      //如果选择的数据跟数组里的某个数据相同 并且传入的选择数据和点击数据相同,就找到了这条数据然后更新数据
      if (cartList[i]["_id"] == cartItem["_id"] &&
          cartList[i]["selectedAttr"] == cartItem["selectedAttr"]) {
        //然后进行数量的增加
        cartList[i]["count"]++;
      }
      //把修改的数据重新添加到临时数组,没改变的也进行了添加
      tempList.add(cartList[i]);
    }
    //再重新赋值原数组,刷新数据
    cartList.value = tempList;
    //把数据加入缓存
    CartServices.setCartList(tempList);
         //计算总价
    computedAllPrice();
    update();
  }

  //减少数量
  void decBuyNum(cartItem) {
    print("---");
    var tempList = [];
    //在这里循环变量传入的数据
    for (var i = 0; i < cartList.length; i++) {
      //如果选择的数据跟数组里的某个数据相同 并且传入的选择数据和点击数据相同,就找到了这条数据然后更新数据
      if (cartList[i]["_id"] == cartItem["_id"] &&
          cartList[i]["selectedAttr"] == cartItem["selectedAttr"]) {
        //然后进行数量的减少
        if (cartList[i]["count"] > 1) {
          cartList[i]["count"]--;
        } else {
          Get.snackbar("提示!", "购物车数量已经到最小了");
        }
      }
      //把修改的数据重新添加到临时数组,没改变的也进行了添加
      tempList.add(cartList[i]);
    }
    //再重新赋值原数组,刷新数据
    cartList.value = tempList;
    CartServices.setCartList(tempList);
         //计算总价
    computedAllPrice();
    update();
  }

  //单选商品
  void checkCartItem(cartItem) {
    print("选中单个商品");
    var tempList = [];
    //在这里循环变量传入的数据
    for (var i = 0; i < cartList.length; i++) {
      //如果选择的数据跟数组里的某个数据相同 并且传入的选择数据和点击数据相同,就找到了这条数据然后更新数据
      if (cartList[i]["_id"] == cartItem["_id"] &&
          cartList[i]["selectedAttr"] == cartItem["selectedAttr"]) {
        //进行取反
        cartList[i]["checked"] = !cartList[i]["checked"];
      }
      //把修改的数据重新添加到临时数组,没改变的也进行了添加
      tempList.add(cartList[i]);
    }
    //再重新赋值原数组,刷新数据
    cartList.value = tempList;
    CartServices.setCartList(tempList);
    //单选的时候判断是否需要全选
    checkAllBox.value = isCheckedAll();

         //计算总价
    computedAllPrice();
    update();
  }

  //全选 反选
  void checkedAllFunc(value) {
    checkAllBox.value = value;
    print("全选");
    var tempList = [];
    //在这里循环变量传入的数据
    for (var i = 0; i < cartList.length; i++) {
      cartList[i]["checked"] = value;
      //把修改的数据重新添加到临时数组,没改变的也进行了添加
      tempList.add(cartList[i]);
    }
    //再重新赋值原数组,刷新数据
    cartList.value = tempList;
    CartServices.setCartList(tempList);
    //计算总价
    computedAllPrice();
    update();
  }

  //判断是否全选
  bool isCheckedAll() {
    //如果数据列表不为空
    if (cartList.isNotEmpty) {
      // 循环遍历数组
      for (var i = 0; i < cartList.length; i++) {
        //如果有一个没有选中
        if (cartList[i]["checked"] == false) {
          //返回false
          return false;
        }
      }
      //都选中返回true
      return true;
    }
    return false;
  }

  //获取要结算的商品
  getCheckListData() {
    List tempList = [];
    // 循环遍历数组
    for (var i = 0; i < cartList.length; i++) {
      //如果有一个没有选中
      if (cartList[i]["checked"] == true) {
        tempList.add(cartList[i]);
      }
    }
    return tempList;
  }

  //判断用户有没有登录
  Future<bool> isLogin() async {
    return await UserServices.getUserLoginState();
  }

  //点击购物车结算按钮
  chekout() async {
    bool loginState = await isLogin();
    List checkListData = getCheckListData();
    //如果登录
    if (loginState) {
      //判断购物车有没有结算的商品
      if (checkListData.isNotEmpty) {
        //有数据 保存要结算的商品
        Storage.setData("checkListData", checkListData);

        Get.toNamed("/checkout");
      } else {
        Get.snackbar("提示信息!", "购物车中没有要结算的商品");
      }
    } else {
      //执行跳转 到登录页面
      Get.toNamed("/code-login-step-one");
      Get.snackbar("提示信息!", "您还没有登录,请先登录");
    }
  }

  //改变edit属性
  changeEditState() {
    isEdit.value = !isEdit.value; //取反
    update();
  }

  // 删除购物车数据
  deleteCartDate() {
    List tempList = [];
    // 循环遍历数组
    for (var i = 0; i < cartList.length; i++) {
      //循环遍历找到没有选中的 不需要删除的 商品
      if (cartList[i]["checked"] == false) {
        tempList.add(cartList[i]);
      }
    }
    //把没有选中的商品保存在cart里面
    /*
    相当于把选中的给去掉 没选中的重新加入购物车数据列表 刷新界面.
    */
    cartList.value = tempList;
    CartServices.setCartList(tempList);

    update();
  }

  //计算总价  在增减商品 全选/反选  单选 都调用该计算方法
  // 使用obx方法去更新 总价信息显示
  computedAllPrice() {  
    double tempAllPrice = 0.0;
    //循环变量 购物车列表数据
    for (var i = 0; i < cartList.length; i++) {
      //如果购物车的商品是选中的
      if (cartList[i]["checked"] == true) {
        //获得选中商品的价格 乘以 商品数量
        tempAllPrice += cartList[i]["price"] * cartList[i]["count"];
      }
    }
    allPrice.value = tempAllPrice;
  }
}
 