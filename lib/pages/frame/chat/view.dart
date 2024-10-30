import 'package:chatty/common/values/colors.dart';
import 'package:chatty/common/widgets/image_network_builder.dart';
import 'package:chatty/common/widgets/profile_w_indicator.dart';
import 'package:chatty/pages/frame/chat/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatPage extends GetView<ChatController> {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(
            controller.state.toName.value,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.primaryText,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        actions: [
          ProfileWithIndicatorWidget(
            imageUrl: controller.state.toAvatar.value,
          ),
          SizedBox(width: 20 ),
        ],
      ),
      body: Center(
        child: Text(
          "Chat Page",
          style: TextStyle(
            fontSize: 24,
            color: AppColors.primaryText,
          ),
        ),
      ),
    );
  }
}
