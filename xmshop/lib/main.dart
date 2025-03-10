// import 'dart:js';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() {
  //配置透明状态栏
  SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle();
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);

  runApp(
    ScreenUtilInit(
      designSize: const Size(1080, 2400), //传入设计稿的宽度和高度 单位px
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false, //去掉debug图标
          title: "Application",
          //配置主题 默认返回按钮是白色
          theme: ThemeData(
            primarySwatch: Colors.grey, //配置此主题返回按钮为黑色

            splashFactory: NoSplash.splashFactory, // 去掉 InkWell 的点击水波纹效果
            splashColor: Colors.transparent, // 点击时的高亮效果设置为透明
            highlightColor: Colors.transparent, // 长按时的扩散效果设置为透明
            textButtonTheme: const TextButtonThemeData(
              // 去掉 TextButton 的水波纹效果
              style: ButtonStyle(splashFactory: NoSplash.splashFactory),
            ),
          ),
          initialRoute: AppPages.INITIAL,
          //配置iOS动画,默认动画有点快 配置一下会好很多
          defaultTransition: Transition.rightToLeft,
          getPages: AppPages.routes,
        );
      },
    ),
  );
}
