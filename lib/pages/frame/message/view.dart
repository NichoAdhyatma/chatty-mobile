import 'package:chatty/common/entities/entities.dart';
import 'package:chatty/common/store/store.dart';
import 'package:chatty/common/values/colors.dart';
import 'package:chatty/pages/frame/message/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      right: 20.w,
      bottom: 70.w,
      height: 50.w,
      width: 50.w,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 50.w,
          width: 50.w,
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: AppColors.primaryElement,
            borderRadius: BorderRadius.circular(40.w),
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
        child: Container(
          width: 320.w,
          height: 44.h,
          margin: EdgeInsets.only(
            top: 20.h,
            bottom: 20.h,
          ),
          child: Row(
            children: [
              Stack(
                children: [
                  Container(
                    margin: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: AppColors.primarySecondaryBackground,
                      borderRadius: BorderRadius.circular(22.h),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        )
                      ],
                    ),
                    child: userItem.value.avatar == null
                        ? const Image(
                            fit: BoxFit.cover,
                            image: AssetImage(
                              "assets/images/account_header.png",
                            ),
                          )
                        : const Text("Hi"),
                  ),
                  Positioned(
                    bottom: 4.w,
                    right: 4.w,
                    height: 14.w,
                    child: Container(
                      width: 11.w,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.primaryElementText,
                          width: 2.w,
                        ),
                        color: AppColors.primaryElementStatus,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 10.w),
              Text(UserStore.to.profile.name ?? ""),
            ],
          ),
        ),
      ),
    );
  }
}
