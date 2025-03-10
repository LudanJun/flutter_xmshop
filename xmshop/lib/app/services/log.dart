
/**
 *  自定义log使用方式
 
   MyLog(Get.arguments,StackTrace.current);

 */
void MyLog(Object message,StackTrace current){
  CustomTrace trace = CustomTrace(current);
  print("————————————————————————————————————————————————————————————————————————————————————————————————————————————————————\nMyLog：${trace.fileName}：${trace.lineNumber}行\n$message");
}
class CustomTrace{
  
  late final StackTrace _trace;
  late String fileName;
  late int lineNumber;

  CustomTrace(this._trace){
    _parseTrace();
  }
  void _parseTrace(){
    var traceStr = _trace.toString().split("\n")[0];
    var indexOfFileName = traceStr.indexOf(RegExp(r'[A-Za-z_]+.dart'));
    var fileInfo = traceStr . substring(indexOfFileName);
    var listOfInfos = fileInfo.split(":");
    this.fileName = listOfInfos[0];
    this.lineNumber = int.parse(listOfInfos[1]);
  }
}