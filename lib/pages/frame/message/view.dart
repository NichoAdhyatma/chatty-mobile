import 'package:chatty/common/entities/entities.dart';
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
            )
          ],
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
    return Center(
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
                GestureDetector(
                  onTap: onTap,
                  child: Container(
                    width: 44.w,
                    height: 44.h,
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
                            image:
                                AssetImage("assets/images/account_header.png"),
                          )
                        : const Text("Hi"),
                  ),
                ),
                Positioned(
                  bottom: 5.w,
                  right: 0.w,
                  height: 14.w,
                  child: Container(
                    width: 14.w,
                    height: 14.w,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.primaryElementText,
                        width: 2.w,
                      ),
                      color: AppColors.primaryElementStatus,
                      borderRadius: BorderRadius.circular(12.w),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
