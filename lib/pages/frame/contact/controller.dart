import 'dart:developer';

import 'package:chatty/common/apis/apis.dart';
import 'package:chatty/common/entities/entities.dart';
import 'package:chatty/common/routes/routes.dart';
import 'package:chatty/common/store/store.dart';
import 'package:chatty/common/utils/loading.dart';
import 'package:chatty/pages/frame/contact/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ContactController extends GetxController {
  ContactController();

  final String title = 'Chatty .';
  final ContactState state = ContactState();
  final String? token = UserStore.to.profile.token;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  void onReady() {
    loadData();

    super.onReady();
  }

  Future<void> loadData() async {
    Loading.show('Loading...');

    state.contacts.clear();

    var contacts = await ContactAPI.post_contact();

    if (contacts.code == 1) {
      log('contacts: ${contacts.data}');
      state.contacts.assignAll(contacts.data!);
      Loading.toast('Success to load data');
    } else {
      Loading.toast('Failed to load data');
    }

    Loading.dismiss();
  }

  Future<void> goToChat(ContactItem item) async {
    final QuerySnapshot<Msg> fromMessage = await db
        .collection("message")
        .withConverter(
          fromFirestore: Msg.fromFirestore,
          toFirestore: (Msg msg, optons) => msg.toFirestore(),
        )
        .where("from_token", isEqualTo: token)
        .where("to_token", isEqualTo: item.token)
        .get();

    final QuerySnapshot<Msg> toMessage = await db
        .collection("message")
        .withConverter(
          fromFirestore: Msg.fromFirestore,
          toFirestore: (Msg msg, optons) => msg.toFirestore(),
        )
        .where("from_token", isEqualTo: item.token)
        .where("to_token", isEqualTo: token)
        .get();

    if (fromMessage.docs.isEmpty && toMessage.docs.isEmpty) {
      UserItem profile = UserStore.to.profile;

      final Msg msgData = Msg(
        from_token: profile.token,
        from_name: profile.name,
        from_avatar: profile.avatar,
        from_online: profile.online,
        to_token: item.token,
        to_name: item.name,
        to_avatar: item.avatar,
        to_online: item.online,
        last_msg: "",
        last_time: Timestamp.now(),
        msg_num: 0,
      );

      final docId = await db
          .collection("message")
          .withConverter(
            fromFirestore: Msg.fromFirestore,
            toFirestore: (Msg msg, options) => msg.toFirestore(),
          )
          .add(msgData);

      Get.toNamed(AppRoutes.Chat, parameters: {
        "doc_id": docId.id,
        "to_token": item.token ?? "",
        "to_name": item.name ?? "",
        "to_avatar": item.avatar ?? "",
        "to_online": item.online.toString(),
      });
    } else {
      if (fromMessage.docs.first.id.isNotEmpty) {
        Get.toNamed(AppRoutes.Chat, parameters: {
          "doc_id": fromMessage.docs.first.id,
          "to_token": item.token ?? "",
          "to_name": item.name ?? "",
          "to_avatar": item.avatar ?? "",
          "to_online": item.online.toString(),
        });
      }

      if (toMessage.docs.first.id.isNotEmpty) {
        Get.toNamed(AppRoutes.Chat, parameters: {
          "doc_id": toMessage.docs.first.id,
          "to_token": item.token ?? "",
          "to_name": item.name ?? "",
          "to_avatar": item.avatar ?? "",
          "to_online": item.online.toString(),
        });
      }
    }

    // Get.toNamed(AppRoutes.Chat, arguments: item);
  }
}
