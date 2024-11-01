
import 'package:chatty/common/routes/names.dart';
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

  void audioCall() {
    state.moreStatus.value = false;
    Get.toNamed(AppRoutes.VoiceCall, parameters: {
      'to_name': state.toName.value,
      'to_avatar': state.toAvatar.value,
      'to_token': state.toToken.value,
      'call_role': 'anchor',
    });
  }
}
