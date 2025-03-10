import 'package:flutter/material.dart';
import 'package:xmshop/app/services/screenAdapter.dart';

class UserAgreement extends StatelessWidget {
  final void Function(bool?)? onChanged;
  const UserAgreement({super.key,this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: ScreenAdapter.height(40)),
      child: Wrap(
        //协议比较多可能会换号所以用wrap组件
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Checkbox(activeColor: Colors.red, value: true, onChanged:onChanged),
          const Text(
            "已阅读并同意",
            style: TextStyle(color: Colors.grey),
          ),
          const Text(
            "《商城用户协议》",
            style: TextStyle(
              color: Colors.red,
            ),
          ),
          const Text(
            "《商城隐私协议》",
            style: TextStyle(
              color: Colors.red,
            ),
          ),
          const Text(
            "《小米 账号用户协议》",
            style: TextStyle(
              color: Colors.red,
            ),
          ),
          const Text(
            "《小米账号隐私协议》",
            style: TextStyle(
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
