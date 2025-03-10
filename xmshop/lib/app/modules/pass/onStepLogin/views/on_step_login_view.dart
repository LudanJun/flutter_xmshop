import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:xmshop/app/services/screenAdapter.dart';
import 'package:xmshop/app/widget/PassButton.dart';
import 'package:xmshop/app/widget/PassTextField.dart';
import 'package:xmshop/app/widget/logo.dart';

import '../controllers/on_step_login_controller.dart';

class OnStepLoginView extends GetView<OnStepLoginController> {
  const OnStepLoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OnStepLoginView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'OnStepLoginView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
