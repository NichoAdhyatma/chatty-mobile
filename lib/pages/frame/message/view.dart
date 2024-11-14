import 'dart:developer';

import 'package:chatty/common/entities/entities.dart';
import 'package:chatty/common/utils/date.dart';
import 'package:chatty/common/values/colors.dart';
import 'package:chatty/common/widgets/profile_w_indicator.dart';
import 'package:chatty/pages/frame/message/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessagePage extends GetView<MessageController> {
  const MessagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    title: HeaderBar(
                      userItem: controller.state.headDetail,
                      onTap: () {
                        controller.goToProfile();
                      },
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 0,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: TabBarHead(),
                    ),
                  ),
                  Obx(
                    () {
                      return SliverPadding(
                        padding: EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 20,
                        ),
                        sliver: controller.state.tabStatus.value
                            ? SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    var item = controller.state.messages[index];
                                    return ChatItem(
                                      item: item,
                                      onTap: () {
                                        controller.goToChat(item);
                                      },
                                    );
                                  },
                                  childCount: controller.state.messages.length,
                                ),
                              )
                            : SliverToBoxAdapter(
                                child: Container(
                                  padding: EdgeInsets.zero,
                                ),
                              ),
                      );
                    },
                  ),
                ],
              ),
              ContactButton(
                onTap: () {
                  controller.goToContact();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatItem extends StatelessWidget {
  const ChatItem({
    super.key,
    required this.item,
    this.onTap,
  });

  final Message item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 10,
        left: 0,
        right: 0,
        bottom: 10,
      ),
      child: InkWell(
        onTap: () {
          if (item.doc_id != null) {
            onTap?.call();
          }
        },
        child: Row(
          children: [
            ProfileWithIndicatorWidget(
              imageUrl: item.avatar,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name ?? "",
                    overflow: TextOverflow.clip,
                    maxLines: 1,
                    softWrap: false,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppColors.thirdElement,
                    ),
                  ),
                  Text(
                    item.last_msg ?? "",
                    overflow: TextOverflow.clip,
                    maxLines: 1,
                    softWrap: true,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    duTimeLineFormat(
                        item.last_time?.toDate() ?? DateTime.now()),
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    softWrap: true,
                    style: TextStyle(
                      overflow: TextOverflow.clip,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ),
                item.msg_num != 0
                    ? Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.red, shape: BoxShape.circle),
                        child: Text(
                          item.msg_num.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TabBarHead extends GetView<MessageController> {
  const TabBarHead({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primarySecondaryBackground,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Obx(() {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TabBarItemButton(
              label: "Chat",
              onTap: () {
                controller.toggleTabStatus(true);
              },
              isActive: controller.state.tabStatus.value,
            ),
            TabBarItemButton(
              onTap: () {
                controller.toggleTabStatus(false);
              },
              label: "Call",
              isActive: !controller.state.tabStatus.value,
            )
          ],
        );
      }),
    );
  }
}

class TabBarItemButton extends StatelessWidget {
  const TabBarItemButton({
    super.key,
    required this.label,
    this.onTap,
    this.isActive = false,
  });

  final String label;
  final VoidCallback? onTap;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 158,
        height: 40,
        decoration: isActive
            ? BoxDecoration(
                color: AppColors.primaryBackground,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  )
                ],
              )
            : BoxDecoration(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                color: AppColors.primaryThreeElementText,
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ContactButton extends StatelessWidget {
  final VoidCallback? onTap;

  const ContactButton({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 30,
      bottom: 0,
      height: 70,
      width: 70,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primaryElement,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 2,
                offset: const Offset(1, 1),
              ),
            ],
          ),
          child: Image.asset("assets/icons/contact.png"),
        ),
      ),
    );
  }
}

class HeaderBar extends StatelessWidget {
  final Rx<UserItem> userItem;
  final VoidCallback? onTap;

  const HeaderBar({
    required this.userItem,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: SizedBox(
          height: 55,
          child: Obx(
            () {
              return Row(
                children: [
                  ProfileWithIndicatorWidget(
                    imageUrl: userItem.value.avatar,
                  ),
                  SizedBox(width: 12),
                  Text(userItem.value.name ?? ""),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
