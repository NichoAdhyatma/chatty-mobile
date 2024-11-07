import 'dart:async';
import 'dart:developer';

import 'package:chatty/common/entities/entities.dart';
import 'package:chatty/common/routes/names.dart';
import 'package:chatty/common/store/user.dart';
import 'package:chatty/common/widgets/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'state.dart';

class ChatController extends GetxController {
  ChatController();

  final String title = 'Chatty .';

  final ChatState state = ChatState();

  final token = UserStore.to.profile.token;

  late String docId;

  final db = FirebaseFirestore.instance;

  late StreamSubscription listener;

  final FocusNode focusNode = FocusNode();
  final ScrollController scrollController = ScrollController();

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

  @override
  void onReady() async {
    state.messages.clear();
    log(docId);
    log("Room ID: $docId", name: 'ChatController');
    final messages = db
        .collection('message')
        .doc(docId)
        .collection('msgList')
        .withConverter(
            fromFirestore: Msgcontent.fromFirestore,
            toFirestore: (msg, options) => msg.toFirestore())
        .orderBy('addtime', descending: true);

    listener = messages.snapshots().listen((event) {
      List<Msgcontent> tempMsgList = <Msgcontent>[];

      log("Docs Changes");

      for (var change in event.docChanges) {
        switch (change.type) {
          case DocumentChangeType.added:
            if (change.doc.data() != null) {
              tempMsgList.add(change.doc.data()!);
            }
            break;
          case DocumentChangeType.modified:
            break;
          case DocumentChangeType.removed:
            break;
        }


      }

      for (var element in tempMsgList.reversed) {
        log("Element in temp : ${element.content}", name: 'ChatController');
        state.messages.insert(0, element);
      }

      state.messages.refresh();

      if(scrollController.hasClients) {
        scrollController.animateTo(
          0.0,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }

    });

    super.onReady();
  }

  @override
  void onClose() {
    listener.cancel();
    scrollController.dispose();
    focusNode.dispose();
    state.messageController.dispose();
    super.onClose();
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

    focusNode.requestFocus();

    var messageResult = await db
        .collection("message")
        .doc(docId)
        .withConverter(
          fromFirestore: Msg.fromFirestore,
          toFirestore: (msg, options) => msg.toFirestore(),
        )
        .get();

    if (messageResult.data() != null) {
      var message = messageResult.data();

      int? toMessageNum =
          message?.to_msg_num == null ? 0 : message?.to_msg_num!;

      int? fromMessageNum =
          message?.from_msg_num == null ? 0 : message?.from_msg_num!;

      if (message?.from_token == token) {
        fromMessageNum = fromMessageNum! + 1;
      } else {
        toMessageNum = toMessageNum! + 1;
      }

      await db.collection("message").doc(docId).update({
        'from_msg_num': fromMessageNum,
        'to_msg_num': toMessageNum,
        'last_msg': content,
        'last_time': Timestamp.now(),
      });
    }
  }
}
