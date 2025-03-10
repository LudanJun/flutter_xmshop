import 'dart:math';
import 'package:flutter/material.dart';

Color randomColor() {
  return Color.fromARGB(
    255, // 不透明度（0到255）
    Random().nextInt(255), // 红色（0到255）
    Random().nextInt(255), // 绿色（0到255）
    Random().nextInt(255), // 蓝色（0到255）
  );
}

String imageUrl1 = "https://www.itying.com/images/flutter/1.png";
String imageUrl2 = "https://www.itying.com/images/flutter/2.png";
String imageUrl3 = "https://www.itying.com/images/flutter/3.png";
String imageUrl4 = "https://www.itying.com/images/flutter/4.png";
String imageUrl5 = "https://www.itying.com/images/flutter/5.png";
String imageUrl6 = "https://www.itying.com/images/flutter/6.png";
