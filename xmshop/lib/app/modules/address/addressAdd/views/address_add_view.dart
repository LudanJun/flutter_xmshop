import 'package:city_pickers/city_pickers.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:xmshop/app/services/screenAdapter.dart';

import '../controllers/address_add_controller.dart';

class AddressAddView extends GetView<AddressAddController> {
  const AddressAddView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AddressAddView'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.only(top: ScreenAdapter.width(20)),
        children: [
          Container(
            padding: EdgeInsets.all(ScreenAdapter.width(20)),
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "姓名",
                      style: TextStyle(
                        fontSize: ScreenAdapter.fontSize(46),
                      ),
                    ),
                    SizedBox(
                      width: ScreenAdapter.width(40),
                    ),
                    Expanded(
                      flex: 1,
                      child: TextField(
                        controller: controller.nameController,
                        decoration: InputDecoration(
                          //设置提示信息的属性
                          hintStyle: TextStyle(
                            fontSize: ScreenAdapter.fontSize(42),
                          ),
                          hintText: "请输入姓名",
                          border: InputBorder.none, //去掉文本默认自带的下边框线
                        ),
                      ),
                    )
                  ],
                ),
                Divider(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "电话",
                      style: TextStyle(
                        fontSize: ScreenAdapter.fontSize(46),
                      ),
                    ),
                    SizedBox(
                      width: ScreenAdapter.width(40),
                    ),
                    Expanded(
                      flex: 1,
                      child: TextField(
                        controller: controller.phoneController,
                        decoration: InputDecoration(
                          //设置提示信息的属性
                          hintStyle: TextStyle(
                            fontSize: ScreenAdapter.fontSize(42),
                          ),
                          hintText: "请输入电话",
                          border: InputBorder.none, //去掉文本默认自带的下边框线
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: ScreenAdapter.height(40),
          ),
          Container(
            padding: EdgeInsets.all(ScreenAdapter.width(20)),
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  height: ScreenAdapter.height(140),
                  child: InkWell(
                    onTap: () async {
                      print("选择地区");

                      Result? result =
                          await CityPickers.showCityPicker(context: context);

                      // Result? result = await CityPickers.showFullPageCityPicker(context: context);
                      if (result != null) {
                        print(result.provinceName);
                        print(result.cityName);
                        print(result.areaName);
                        controller.setArea(
                            "${result.provinceName} ${result.cityName} ${result.areaName}");
                      }
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "所在地区",
                          style: TextStyle(
                            fontSize: ScreenAdapter.fontSize(46),
                          ),
                        ),
                        SizedBox(
                          width: ScreenAdapter.width(40),
                        ),
                        Expanded(
                          flex: 1,
                          child: Obx(() => Text(
                                controller.area.value == ""
                                    ? "所在地区"
                                    : controller.area.value,
                                style: TextStyle(
                                    fontSize: ScreenAdapter.fontSize(42),
                                    color: Colors.black54),
                              )),
                        )
                      ],
                    ),
                  ),
                ),
                Divider(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "详细地址",
                      style: TextStyle(
                        fontSize: ScreenAdapter.fontSize(46),
                      ),
                    ),
                    SizedBox(
                      width: ScreenAdapter.width(40),
                    ),
                    Expanded(
                      flex: 1,
                      child: TextField(
                        controller: controller.addressController,
                        // maxLines: 4,//设置行数
                        decoration: InputDecoration(
                          //设置提示信息的属性
                          hintStyle: TextStyle(
                            fontSize: ScreenAdapter.fontSize(42),
                          ),
                          hintText: "请输入详细地址",
                          border: InputBorder.none, //去掉文本默认自带的下边框线
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          SizedBox(height: ScreenAdapter.height(200)),
          Padding(
            padding: EdgeInsets.all(ScreenAdapter.width(40)),
            child: InkWell(
              onTap: () {
                //执行保存 地址
                controller.doAddAddress();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(251, 72, 5, 0.9),
                  borderRadius: BorderRadius.circular(20),
                ),
                height: ScreenAdapter.height(140),
                alignment: Alignment.center,
                child: const Text(
                  "保存",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
