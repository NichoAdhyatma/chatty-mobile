
import 'package:get/get.dart';

import 'state.dart';

class ChatController extends GetxController {
  ChatController();

  final String title = 'Chatty .';

  final ChatState state = ChatState();
  late String docId;

  @override
  void onInit() {
    var data = Get.parameters;
    docId = data['docId'] ?? '';
    state.toToken.value = data['to_token'] ?? '';
    state.toName.value = data['to_name'] ?? '';
    state.toAvatar.value = data['to_avatar'] ?? '';
    state.toOnline.value = data['to_online'] ?? '';

    super.onInit();
  }

  void goMore() {
    state.moreStatus.value = !state.moreStatus.value;
  }
}
