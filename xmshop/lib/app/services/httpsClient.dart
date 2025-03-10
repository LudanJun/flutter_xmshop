import 'package:dio/dio.dart';
import 'package:xmshop/app/services/log.dart';

class HttpsClient {
  static String domain = "https://miapp.itying.com/";

  static Dio dio = Dio();
  HttpsClient() {
    dio.options.baseUrl = domain;
    dio.options.connectTimeout = const Duration(seconds: 5); //5s
    dio.options.receiveTimeout = const Duration(seconds: 5);
  }

  Future get(apiUrl) async {
    try {
      var response = await dio.get(apiUrl);
      MyLog(apiUrl, StackTrace.current);
      MyLog(response, StackTrace.current);
      return response;
    } catch (e) {
      print("请求超时");
      return null;
    }
  }
  // 传入接口   和map命名参数数据
  Future post(String apiUrl, {Map? data}) async {
    try {
      var response = await dio.post(apiUrl, data: data);
      return response;
    } catch (e) {
      print("请求超时");
      return null;
    }
  }

  //转换字符串
  static replaeUri(picUrl) {
    String tempUrl = domain + picUrl;
    return tempUrl.replaceAll("\\", "/");
  }
}
