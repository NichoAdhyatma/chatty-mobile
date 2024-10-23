import 'package:chatty/common/services/services.dart';
import 'package:chatty/common/store/store.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class InitDependencies {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Get.putAsync(() => StorageService().init());
    Get.put<UserStore>(UserStore());
  }
}