import 'package:flutter/material.dart';

/*使用
  String phoneNumber = '13812345678';
  String maskedPhoneNumber = maskPhoneNumber(phoneNumber);
  print(maskedPhoneNumber); // 输出: 138******78
*/
String maskPhoneNumber(String phoneNumber) {
  return phoneNumber.replaceRange(3, 7, '******');
}
