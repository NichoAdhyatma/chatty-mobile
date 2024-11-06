import 'dart:developer';

import 'package:chatty/common/entities/entities.dart';
import 'package:chatty/common/routes/names.dart';
import 'package:chatty/common/store/user.dart';
import 'package:chatty/common/widgets/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import 'state.dart';

class ChatController extends GetxController {
  ChatController();

  final String title = 'Chatty .';

  final ChatState state = ChatState();

  final token = UserStore.to.profile.token;

  late String docId;

  final db = FirebaseFirestore.instance;

  @override
  void onInit() {
    var data = Get.parameters;

    docId = data['doc_id'] ?? '';
    state.toToken.value = data['to_token'] ?? '';
    state.toName.value = data['to_name'] ?? '';
    state.toAvatar.value = data['to_avatar'] ?? '';
    state.toOnline.value = data['to_online'] ?? '1';

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
      'doc_id': docId,
    });
  }

  Future<void> sendMessage() async {
    String content = state.messageController.text;

    if (content.isEmpty) {
      toastInfo(msg: 'Please enter message');
      return;
    }

    final messageContent = Msgcontent(
      token: token,
      content: content,
      type: "text",
      addtime: Timestamp.now(),
    );

    log("Room ID: $docId", name: 'ChatController');

    log("Send message: $content", name: 'ChatController');

    final DocumentReference<Msgcontent> response = await db
        .collection("message")
        .doc(docId)
        .collection('msgList')
        .withConverter(
          fromFirestore: Msgcontent.fromFirestore,
          toFirestore: (msg, options) => msg.toFirestore(),
        )
        .add(messageContent);

    log(
      "Send message response: ${response.id}",
      name: 'ChatController',
    );

    state.messageController.clear();
  }
}
