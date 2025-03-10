import 'package:flutter/material.dart';
import 'package:xmshop/app/services/screenAdapter.dart';

class PassButton extends StatelessWidget {
  final String text; //提示内容place 必传
  final void Function()? onPressed; //外部调用改变的方法
  const PassButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: ScreenAdapter.height(40)),
      height: ScreenAdapter.height(140),
      child: ElevatedButton(
          style: ButtonStyle(
              //设置按钮背景色
              backgroundColor:
                  MaterialStateProperty.all(Color.fromRGBO(240, 115, 40, 1)),
              //设置按钮文字颜色
              foregroundColor: MaterialStateProperty.all(Colors.white),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  //设置按钮圆角
                  borderRadius:
                      BorderRadius.circular(ScreenAdapter.height(70))))),
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(fontSize: ScreenAdapter.fontSize(46)),
          )),
    );
  }
}
