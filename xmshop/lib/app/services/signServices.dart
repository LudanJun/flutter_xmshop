import 'dart:convert';

import 'package:crypto/crypto.dart';

class SignServices {
  static getSign(Map json) {
    //1.获取登录成功以后返回的salt

    //2.获取请求的所有参数

    //3.生成一个map类型的对象 
    
    //4.获取map对象的key 按照ASCII 字符进行升序排序(也就是所谓的自然排序)

    //5.拼接字符串

    //6.md5加密生成签名

    // Map addressJson = {
    //   "aid": 1,
    //   "name": "zhangsan",
    //   "age": 20,
    //   "sex": '男',
    //   "sale": "fdsahsdlqajas" //私钥 登录成功返回
    // };
    //获取map类型所有key
    List jsonkeys = json.keys.toList();
    print(jsonkeys);

    //字符进行升序排序
    jsonkeys.sort();
    print(jsonkeys);

    String str = '';
    //开始拼接
    for (var i = 0; i < jsonkeys.length; i++) {
      str += "${jsonkeys[i]}${json[jsonkeys[i]]}";
    }
    print(str); //age20aid1namezhangsansalefdsahsdlqajassex男

    //得到值后进行md5加密
    var sign = md5.convert(utf8.encode(str));
    print(sign);//5d41402abc4b2a76b9719d911017c592 生成一串32位值
    
    return "$sign";
  }
}
