import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:chatty/common/apis/apis.dart';
import 'package:chatty/common/entities/entities.dart';
import 'package:chatty/common/routes/names.dart';
import 'package:chatty/common/store/user.dart';
import 'package:chatty/common/widgets/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

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

  final RxBool isLoadMore = true.obs;

  File? _photo;

  final ImagePicker _imagePicker = ImagePicker();

  @override
  void onInit() {
    var data = Get.parameters;

    log("Param Argument: $data", name: 'ChatController');

    docId = data['doc_id'] ?? '';
    state.toToken.value = data['to_token'] ?? '';
    state.toName.value = data['to_name'] ?? '';
    state.toAvatar.value = data['to_avatar'] ?? '';
    state.toOnline.value = data['to_online'] ?? '1';

    clearMsgNum(docId);

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
        .orderBy('addtime', descending: true)
        .limit(15);

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

      if (scrollController.hasClients) {
        scrollController.animateTo(
          0.0,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    scrollController.addListener(() {
      if (scrollController.offset + 10 >
          scrollController.position.maxScrollExtent) {
        if (isLoadMore.value) {
          isLoadMore.value = false;
          state.isLoading.value = true;
          loadMoreData();
        }
      }
    });

    super.onReady();
  }

  @override
  void onClose() {
    clearMsgNum(docId);
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

  void videoCall() async {
    state.moreStatus.value = false;

    bool micStatus = await requestPermission(Permission.microphone);
    bool cameraStatus = await requestPermission(Permission.camera);

    log("Mic Status: $micStatus", name: 'ChatController');
    log('Camera Status: $cameraStatus', name: 'ChatController');

    if (GetPlatform.isAndroid && micStatus && cameraStatus) {
      Get.toNamed(AppRoutes.VideoCall, parameters: {
        'to_name': state.toName.value,
        'to_avatar': state.toAvatar.value,
        'to_token': state.toToken.value,
        'call_role': 'anchor',
        'doc_id': docId,
      });
    } else {
      Get.toNamed(AppRoutes.VideoCall, parameters: {
        'to_name': state.toName.value,
        'to_avatar': state.toAvatar.value,
        'to_token': state.toToken.value,
        'call_role': 'anchor',
        'doc_id': docId,
      });
    }
  }

  Future<bool> requestPermission(Permission permission) async {
    final permissionStatus = await permission.status;

    if (permissionStatus != PermissionStatus.granted) {
      final requestPermission = await permission.request();
      log("Request Permission: $requestPermission", name: 'ChatController');
      if (requestPermission != PermissionStatus.granted) {
        toastInfo(
            msg: "Please allow permission to access the camera and microphone");
        if (GetPlatform.isAndroid) {
          await openAppSettings();
        }
        return false;
      }
    }

    toastInfo(msg: "Permission granted");
    return true;
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

  Future<void> loadMoreData() async {
    final messages = await db
        .collection('message')
        .doc(docId)
        .collection('msgList')
        .withConverter(
          fromFirestore: Msgcontent.fromFirestore,
          toFirestore: (msg, options) => msg.toFirestore(),
        )
        .orderBy('addtime', descending: true)
        .where('addtime', isLessThan: state.messages.last.addtime)
        .limit(10)
        .get();

    if (messages.docs.isNotEmpty) {
      for (var message in messages.docs) {
        state.messages.add(message.data());
      }
    }
    SchedulerBinding.instance.addPostFrameCallback((timestamp) {
      isLoadMore.value = true;
    });

    state.isLoading.value = false;
  }

  Future<void> pickImageFromGallery() async {
    final _pickedImage =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    if (_pickedImage != null) {
      _photo = File(_pickedImage.path);
      uploadImageToServer();
    }
  }

  Future<void> uploadImageToServer() async {
    var result = await ChatAPI.upload_img(file: _photo);

    if (result.code == 1) {
      sendImageMessage(result.data);
    } else {
      toastInfo(msg: "Upload image failed");
    }
  }

  Future<void> sendImageMessage(String? data) async {
    final messageContent = Msgcontent(
      token: token,
      content: data,
      type: "image",
      addtime: Timestamp.now(),
    );

    log("Room ID: $docId", name: 'ChatController');

    log("Send message: $data", name: 'ChatController');

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
        'last_msg': "[image]",
        'last_time': Timestamp.now(),
      });
    }
  }

  void closeAllPop() {
    Get.focusScope?.unfocus();
    state.moreStatus.value = false;
  }

  void clearMsgNum(String docId) async {
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

      if (message?.from_token == token) {
        await db.collection("message").doc(docId).update({
          'to_msg_num': 0,
        });
      } else {
        await db.collection("message").doc(docId).update({
          'from_msg_num': 0,
        });
      }
    }
  }
}
