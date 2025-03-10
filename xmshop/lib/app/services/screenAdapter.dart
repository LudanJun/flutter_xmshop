
//封装第三方框架屏幕适配器
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScreenAdapter {

  static width(num v){
    return v.w;
  }

  static height(num v){
    return v.h;
  }
  
  static fontSize(num v){
    return v.sp;
  }

  //获取屏幕宽度
  static getScreenWidth(){
    return 1.sw; // ScreenUtil().screenWidth
  }

  //获取屏幕高度
  static getScreenHeight(){
    return 1.sh;  // ScreenUtil().screenHeight
  }
  //获取状态栏高度
  static getStatusBarHeight(){
    return ScreenUtil().statusBarHeight;//状态栏高度 刘海屏会更高
  }
}