import 'package:chatty/common/values/colors.dart';
import 'package:chatty/common/widgets/profile_w_indicator.dart';
import 'package:chatty/pages/frame/message/chat/widgets/chat_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class ChatPage extends GetView<ChatController> {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatAppBar(
        name: controller.state.toName.value,
        imageUrl: controller.state.toAvatar.value,
        isOnline: controller.state.toOnline.value,
      ),
      body: Obx(() {
        return SafeArea(
          child: Stack(
            children: [
              ChatList(),
              Positioned(
                bottom: 0,
                child: IntrinsicWidth(
                  child: Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    padding: EdgeInsets.only(
                      left: 20,
                      bottom: 10,
                      top: 5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(
                              top: 10,
                              bottom: 10,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: AppColors.primaryBackground,
                              border: Border.all(
                                color: AppColors.primarySecondaryElementText,
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    keyboardType: TextInputType.multiline,
                                    autofocus: false,
                                    focusNode: controller.focusNode,
                                    onSubmitted: (_) {
                                      controller.sendMessage();
                                    },
                                    controller: controller.state.messageController,
                                    decoration: InputDecoration(
                                      hintText: 'Type a message ...',
                                      contentPadding: EdgeInsets.only(
                                        left: 15,
                                        bottom: 0,
                                        top: 0,
                                      ),
                                      hintStyle: TextStyle(
                                        fontSize: 16,
                                        color:
                                        AppColors.primarySecondaryElementText,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                        ),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    controller.sendMessage();
                                  },
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    margin: EdgeInsets.only(
                                      right: 10,
                                    ),
                                    child: Image.asset("assets/icons/send.png"),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            controller.goMore();
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.all(8),
                            margin: EdgeInsets.only(
                              left: 12,
                              right: 12,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: AppColors.primaryElement,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  offset: Offset(1, 1),
                                  blurRadius: 2,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Image.asset("assets/icons/add.png"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              controller.state.moreStatus.value
                  ? Positioned(
                right: 12,
                bottom: 80,
                height: 200,
                width: 40,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MenuButton(
                      onTap: () {},
                      assetUrl: "assets/icons/file.png",
                    ),
                    MenuButton(
                      onTap: () {
                        controller.pickImageFromGallery();
                      },
                      assetUrl: "assets/icons/photo.png",
                    ),
                    MenuButton(
                      onTap: () {
                        controller.audioCall();
                      },
                      assetUrl: "assets/icons/call.png",
                    ),
                    MenuButton(
                      onTap: () {
                        controller.videoCall();
                      },
                      assetUrl: "assets/icons/video.png",
                    ),
                  ],
                ),
              )
                  : Container(),
            ],
          ),
        );
      }),
    );
  }
}

class MenuButton extends StatelessWidget {
  const MenuButton({
    super.key,
    this.onTap,
    required this.assetUrl,
  });

  final VoidCallback? onTap;
  final String assetUrl;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        width: 40,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: AppColors.primaryBackground,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              offset: Offset(1, 1),
              blurRadius: 2,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Image.asset(assetUrl),
      ),
    );
  }
}

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatAppBar({
    super.key,
    required this.name,
    required this.isOnline,
    required this.imageUrl,
  });

  final String name;
  final String imageUrl;
  final String isOnline;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primaryBackground,
      surfaceTintColor: AppColors.primaryBackground,
      title: Text(
        name,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: TextStyle(
          fontSize: 16,
          color: AppColors.primaryText,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        ProfileWithIndicatorWidget(
          imageUrl: imageUrl,
          isOnline: isOnline,
        ),
        SizedBox(width: 20),
      ],
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}
