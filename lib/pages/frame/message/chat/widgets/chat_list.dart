import 'dart:developer';

import 'package:chatty/pages/frame/message/chat/controller.dart';
import 'package:chatty/pages/frame/message/chat/widgets/chat_left_list.dart';
import 'package:chatty/pages/frame/message/chat/widgets/chat_right_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatList extends GetView<ChatController> {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 0,
              ),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    var item = controller.state.messages[index];

                    log('content: ${item.content}');

                    if (controller.token == item.token) {
                      return ChatRightList(item: item);
                    }

                    return ChatLeftList(item: item);
                  },
                  childCount: controller.state.messages.length,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
