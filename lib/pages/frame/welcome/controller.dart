import 'dart:developer';

import 'package:chatty/common/routes/names.dart';
import 'package:get/get.dart';

class WelcomeController extends GetxController {
  WelcomeController();

  final String title = 'Chatty .';

  @override
  void onReady() {
    log('WelcomeController onReady');
    Future.delayed(
      const Duration(seconds: 2),
      () {
        Get.offAllNamed(AppRoutes.Message);
      },
    );
    super.onReady();
  }
}
