import 'dart:developer';

import 'package:chatty/common/apis/apis.dart';
import 'package:chatty/common/entities/entities.dart';
import 'package:chatty/common/routes/names.dart';
import 'package:chatty/common/store/store.dart';
import 'package:chatty/common/utils/loading.dart';
import 'package:chatty/pages/frame/message/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class MessageController extends GetxController {
  MessageController();

  final MessageState state = MessageState();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final String? token = UserStore.to.profile.token;

  void goToProfile() async {
    await Get.toNamed(
      AppRoutes.Profile,
    );

    getProfile();
  }

  void getProfile() {
    state.headDetail.value = UserStore.to.profile;

    state.headDetail.refresh();
  }

  void goToContact() async {
    await Get.toNamed(AppRoutes.Contact);
  }

  @override
  void onInit() {
    _snapShots();
    super.onInit();
  }

  @override
  void onReady() {
    firebaseMessageSetup();
    super.onReady();
  }

  void _snapShots() {
    final toMessageRef = _db
        .collection("message")
        .withConverter(
      fromFirestore: Msg.fromFirestore,
      toFirestore: (msg, opt) => msg.toFirestore(),
    )
        .where(
      'to_token',
      isEqualTo: token,
    );

    final fromMessageRef = _db
        .collection("message")
        .withConverter(
      fromFirestore: Msg.fromFirestore,
      toFirestore: (msg, opt) => msg.toFirestore(),
    )
        .where(
      'from_token',
      isEqualTo: token,
    );

    toMessageRef.snapshots().listen((event) {
      log('event.docs ${event.docs}');
      loadMessageData();
    });

    fromMessageRef.snapshots().listen((event) {
      log('event.docs ${event.docs}');
      loadMessageData();
    });
  }

  void toggleTabStatus(bool status) async {
    state.tabStatus.value = status;

    Loading.show('Loading...');

    log('status $status');

    if (status) {
      // Get.toNamed(AppRoutes.Message);
      await loadMessageData();
    } else {
      await loadCallData();
      // Get.toNamed(AppRoutes.Contact);
    }

    Loading.dismiss();
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

  Future<void> loadMessageData() async {
    var fromMessages = await _db
        .collection("message")
        .withConverter(
      fromFirestore: Msg.fromFirestore,
      toFirestore: (msg, opt) => msg.toFirestore(),
    )
        .where('from_token', isEqualTo: token)
        .get();

    var toMessage = await _db
        .collection('message')
        .withConverter(
      fromFirestore: Msg.fromFirestore,
      toFirestore: (msg, opt) => msg.toFirestore(),
    )
        .where('to_token', isEqualTo: token)
        .get();

    state.messages.clear();

    log('fromMessages.docs ${fromMessages.docs.length}');
    log('toMessage.docs ${toMessage.docs.length}');

    if (fromMessages.docs.isNotEmpty) {
      await addMessage(fromMessages.docs);
    }

    if (toMessage.docs.isNotEmpty) {
      await addMessage(toMessage.docs);
    }

    state.messages.sort(
      (a, b) => b.last_time!.compareTo(a.last_time!),
    );
  }

  Future<void> addMessage(List<QueryDocumentSnapshot<Msg>> docs) async {
    for (var doc in docs) {
      var item = doc.data();

      if (item.last_msg == null) {
        continue;
      }

      Message message = Message();
      message.doc_id = doc.id;
      message.last_time = item.last_time;
      message.msg_num = item.msg_num;
      message.last_msg = item.last_msg;

      if (item.from_token == token) {
        message.name = item.to_name;
        message.avatar = item.to_avatar;
        message.online = item.to_online;
        message.token = item.to_token;
        message.msg_num = item.to_msg_num ?? 0;
      } else {
        message.name = item.from_name;
        message.avatar = item.from_avatar;
        message.online = item.from_online;
        message.token = item.from_token;
        message.msg_num = item.from_msg_num ?? 0;
      }

      state.messages.add(message);
    }
  }

  void goToChat(Message message) async {
    Get.toNamed(
      AppRoutes.Chat,
      parameters: {
        "doc_id": message.doc_id ?? "",
        "to_token": message.token ?? "",
        "to_name": message.name ?? "",
        "to_avatar": message.avatar ?? "",
        "to_online": message.online.toString(),
      },
    );
  }

  Future<void> loadCallData() async {
    state.calls.clear();

    var fromChatcall = await _db
        .collection("chatcall")
        .withConverter(
      fromFirestore: ChatCall.fromFirestore,
      toFirestore: (chatcall, opt) => chatcall.toFirestore(),
    )
        .where('from_token', isEqualTo: token).limit(30)
        .get();

    var toChatCall = await _db
        .collection('chatcall')
        .withConverter(
      fromFirestore: ChatCall.fromFirestore,
      toFirestore: (chatcall, opt) => chatcall.toFirestore(),
    )
        .where('to_token', isEqualTo: token).limit(30)
        .get();


    log('fromMessages.docs ${fromChatcall.docs.length}');
    log('toMessage.docs ${toChatCall.docs.length}');

    if (fromChatcall.docs.isNotEmpty) {
      await addChatCall(fromChatcall.docs);
    }

    if (toChatCall.docs.isNotEmpty) {
      await addChatCall(toChatCall.docs);
    }

    state.calls.sort(
          (a, b) => b.last_time!.compareTo(a.last_time!),
    );
  }

  Future<void> addChatCall(List<QueryDocumentSnapshot<ChatCall>> docs) async {
    for (var doc in docs) {
      var item = doc.data();


      CallMessage chatCall = CallMessage();

      chatCall.doc_id = doc.id;
      chatCall.type = item.type;
      chatCall.last_time = item.last_time;
      // chatCall.msg_num = item.msg_num;
      // chatCall.last_msg = item.last_msg;
      chatCall.call_time = item.call_time;

      if (item.from_token == token) {
        chatCall.name = item.to_name;
        chatCall.avatar = item.to_avatar;
        // chatCall.online = item.to_online;
        chatCall.token = item.to_token;
        // chatCall.msg_num = item.to_msg_num ?? 0;
      } else {
        chatCall.name = item.from_name;
        chatCall.avatar = item.from_avatar;
        // chatCall.online = item.from_online;
        chatCall.token = item.from_token;
        // chatCall.msg_num = item.from_msg_num ?? 0;
      }

      state.calls.add(chatCall);
    }
  }
}
