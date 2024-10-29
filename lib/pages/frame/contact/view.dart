import 'package:chatty/pages/frame/contact/widgets/contact_appbar.dart';
import 'package:chatty/pages/frame/contact/widgets/contact_list.dart';
import 'package:chatty/pages/frame/contact/controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactPage extends GetView<ContactController> {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: ContactAppBar(),
      body: ContactList(),
    );
  }
}

