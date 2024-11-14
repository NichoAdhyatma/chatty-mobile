
import 'package:chatty/common/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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