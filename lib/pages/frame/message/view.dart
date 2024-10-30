import 'package:chatty/common/entities/entities.dart';
import 'package:chatty/common/store/store.dart';
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
                  )
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
                    imageUrl: UserStore.to.profile.avatar,
                  ),
                  SizedBox(width: 12),
                  Text(UserStore.to.profile.name ?? ""),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
