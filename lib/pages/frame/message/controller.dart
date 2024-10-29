import 'package:chatty/common/routes/names.dart';
import 'package:chatty/pages/frame/message/index.dart';
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
}
