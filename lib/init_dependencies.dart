import 'package:chatty/common/langs/localization.dart';
import 'package:chatty/common/services/services.dart';
import 'package:chatty/common/store/store.dart';
import 'package:chatty/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InitDependencies {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await Get.putAsync(() => StorageService().init());

    Get.put<UserStore>(UserStore());

    Get.put<ConfigStore>(ConfigStore());

    await Localization.init();
  }
}
