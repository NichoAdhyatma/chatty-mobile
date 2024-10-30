import 'package:chatty/common/values/colors.dart';
import 'package:chatty/pages/frame/profile/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ProfileAppBar(),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const ProfilePhotoWidget(),
                  const CompleteButtonWidget(),
                  LogoutButtonWidget(
                    onLogoutTap: () {
                      controller.goLogout();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LogoutButtonWidget extends StatelessWidget {
  final VoidCallback? onLogoutTap;

  const LogoutButtonWidget({
    this.onLogoutTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.defaultDialog(
          radius: 10,
          title: "Logout",
          middleText: "Are you sure you want to logout?",
          textConfirm: "Yes",
          textCancel: "No",
          onConfirm: () {
            onLogoutTap?.call();
          },
        );
      },
      child: Container(
        width: 295,
        height: 44,
        margin: EdgeInsets.only(
          bottom: 30,
        ),
        decoration: BoxDecoration(
            color: AppColors.primarySecondaryElementText,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 1),
              )
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Logout",
              style: TextStyle(
                color: AppColors.primaryElementText,
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CompleteButtonWidget extends StatelessWidget {
  const CompleteButtonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: 295,
        height: 44,
        margin: EdgeInsets.only(
          top: 60,
          bottom: 30,
        ),
        decoration: BoxDecoration(
            color: AppColors.primaryElement,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 1),
              )
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Complete",
              style: TextStyle(
                color: AppColors.primaryElementText,
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePhotoWidget extends StatelessWidget {
  final VoidCallback? onEditProfileTap;

  const ProfilePhotoWidget({
    super.key,
    this.onEditProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: AppColors.primarySecondaryBackground,
            borderRadius: BorderRadius.circular(60),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                offset: const Offset(0, 1),
                blurRadius: 2,
                spreadRadius: 1,
              )
            ],
          ),
          child: const Image(
            image: AssetImage('assets/images/account_header.png'),
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          bottom: 10,
          right: 0,
          height: 35,
          child: GestureDetector(
            onTap: onEditProfileTap,
            child: Container(
              height: 35,
              width: 35,
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primaryElement,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Image.asset("assets/icons/edit.png"),
            ),
          ),
        ),
      ],
    );
  }
}

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProfileAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        'Profile',
        style: TextStyle(
          color: AppColors.primaryText,
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}
