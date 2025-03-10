import 'package:flutter/material.dart';

//自定义缓存组件
//注意:如果页面比较多,缓存会耗费内存!!!
class KeepAliveWrapper extends StatefulWidget {
  //默认缓存
  const KeepAliveWrapper( {super.key,@required this.child,this.keepAlive = true});
  // const KeepAliveWrapper({Key? key, this.child, required this.keepAlive}):super(key: key);
  final Widget? child;//传入需要缓存的组件
  final bool keepAlive;//不缓存组件可以改成:false 缓存:true
  @override
  State<KeepAliveWrapper> createState() => _KeepAliveWrapperState();

}
//需要继承这个AutomaticKeepAliveClientMixin来实现缓存页面
class _KeepAliveWrapperState extends State<KeepAliveWrapper> with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child!;//拿到上面传进来的child
  }

  @override
  bool get wantKeepAlive => widget.keepAlive;

  @override
  void didUpdateWidget(covariant KeepAliveWrapper oldWidget){
    if (oldWidget.keepAlive != widget.keepAlive){
      // keepAlive 状态需要更新,实现在AutomaticKeepAliveClientMixin 中
      updateKeepAlive();
    }
    super.didUpdateWidget(oldWidget);
  }
}