import 'package:flutter/material.dart';
import 'package:xmshop/app/services/screenAdapter.dart';

class PassTextFiled extends StatelessWidget {
  final bool isPassWord;
  final String? hintText; //提示内容place 必传
  final TextInputType? keyboardType;
  final void Function(String)? onChanged; //外部调用改变的方法
  final TextEditingController? controller;
  const PassTextFiled(
      {super.key, required this.hintText, this.onChanged,this.isPassWord=false, this.controller,this.keyboardType=TextInputType.number});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: ScreenAdapter.height(180),
      margin: EdgeInsets.only(top: ScreenAdapter.height(40)),
      padding: EdgeInsets.only(left: ScreenAdapter.width(40)),
      decoration: BoxDecoration(
          color: const Color.fromARGB(34, 114, 113, 113),
          borderRadius: BorderRadius.circular(20) //设置圆角
          ),
      child: TextField(
        // autofocus: true, //到这个页面直接响应输入框相当于 swift的第一下响应者
        controller: controller,//定义一个controller 让外界获取文本框的数据
        obscureText: isPassWord,//是否显示密码
        style: TextStyle(
            // color: Colors.orange,//输入文字的颜色

            fontSize: ScreenAdapter.fontSize(48) //设置字体大小
            ),
        keyboardType: keyboardType, //默认弹出数字键盘
        decoration: InputDecoration(
          hintText: hintText, //文本框提示信息
          hintStyle: const TextStyle(
            //设置提示文字颜色
            color: Colors.grey,
          ),
          border: InputBorder.none, //去掉下划线
        ),
        onChanged: onChanged,
      ),
    );
  }
}
