import 'dart:developer';

import 'package:chatty/common/apis/apis.dart';
import 'package:chatty/common/utils/loading.dart';
import 'package:chatty/pages/frame/contact/index.dart';
import 'package:get/get.dart';

class ContactController extends GetxController {
  ContactController();

  final String title = 'Chatty .';
  final ContactState state = ContactState();

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
}
