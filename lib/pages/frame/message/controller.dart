import 'dart:io';

import 'package:chatty/common/apis/apis.dart';
import 'package:chatty/common/entities/base.dart';
import 'package:chatty/common/routes/names.dart';
import 'package:chatty/pages/frame/message/index.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class MessageController extends GetxController {
  MessageController();

  final MessageState state = MessageState();

  void goToProfile() async {
    await Get.toNamed(AppRoutes.Profile);
  }

  void goToContact() async {
    await Get.toNamed(AppRoutes.Contact);
  }

  @override
  void onReady() {
    firebaseMessageSetup();
    super.onReady();
  }

  void firebaseMessageSetup() async {
    String? fcmToken = '';

    fcmToken = await FirebaseMessaging.instance.getToken();

    print("...my device token is $fcmToken");

    if (fcmToken != null) {
      final BindFcmTokenRequestEntity bindFcmTokenRequestEntity =
      BindFcmTokenRequestEntity(
        fcmtoken: fcmToken,
      );

      await ChatAPI.bind_fcmtoken(params: bindFcmTokenRequestEntity);
    }
  }
}
