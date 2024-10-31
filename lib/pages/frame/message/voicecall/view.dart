import 'package:chatty/common/values/colors.dart';
import 'package:chatty/pages/frame/message/voicecall/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VoiceCallPage extends GetView<VoiceCallController> {
  const VoiceCallPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Text('VoiceCallPage'),
      ),
    );
  }
}


