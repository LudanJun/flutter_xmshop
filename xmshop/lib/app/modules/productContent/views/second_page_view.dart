import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:get/get.dart';
import 'package:xmshop/app/modules/productContent/controllers/product_content_controller.dart';
import 'package:xmshop/app/services/colors.dart';
import 'package:xmshop/app/services/screenAdapter.dart';

class SecondPageView extends GetView {
  //新建一个view  需要查找要使用的Controller
  @override //需要加重载
  final ProductContentController controller = Get.find();

  final Function subHeader; //传入控件
  SecondPageView(this.subHeader, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        key: controller.gk2,
        width: ScreenAdapter.width(1080),
        // height: ScreenAdapter.height(2000),//高度去掉会自适应
        child: Obx(() => controller.pcontent.value.content != null
            ? Column(
                children: [
                  subHeader(),
                  controller.selectedSubTabsIndex.value == 1
                      ? SizedBox(
                          width: ScreenAdapter.width(1080),
                          child: Html(
                            data: controller.pcontent.value.content!,
                            style: {
                              "body": Style(backgroundColor: Colors.white),
                              "p": Style(
                                fontSize: FontSize.large,
                              )
                            },
                          ),
                        )
                      : SizedBox(
                          width: ScreenAdapter.width(1080),
                          child: Html(
                            data: controller.pcontent.value.specs,
                            style: {
                              "body": Style(backgroundColor: Colors.white),
                              "p": Style(
                                fontSize: FontSize.large,
                              )
                            },
                          ),
                        ),
                ],
              )
            : const Text("")));
  }
}
