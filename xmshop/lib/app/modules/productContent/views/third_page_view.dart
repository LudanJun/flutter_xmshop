import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:xmshop/app/modules/productContent/controllers/product_content_controller.dart';
import 'package:xmshop/app/services/colors.dart';
import 'package:xmshop/app/services/screenAdapter.dart';

class ThirdPageView extends GetView {
  //新建一个view  需要查找要使用的Controller
  @override //需要加重载
  final ProductContentController controller = Get.find();

  ThirdPageView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      key: controller.gk3,
      width: ScreenAdapter.width(1080),
      height: ScreenAdapter.height(2800),
      color: randomColor(),
      child: const Text(
        "推荐",
        style: TextStyle(fontSize: 100),
      ),
    );
  }
}
