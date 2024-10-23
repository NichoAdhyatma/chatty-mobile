import 'package:chatty/common/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'controller.dart';

class SignInPage extends GetView<SignInController> {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primarySecondaryBackground,
      body: Center(
        child: Column(
          children: [
            const AppLogo(),
            ThirdPartyLoginButton(
              loginType: "Google",
              onTap: () {
                controller.handleSignIn(SignInType.google);
              },
            ),
            const ThirdPartyLoginButton(loginType: "Facebook"),
            const ThirdPartyLoginButton(loginType: "Apple"),
            const OrDividerWidget(),
            const ThirdPartyLoginButton(
              loginType: "phone number",
              withIcon: false,
            ),
            SizedBox(height: 35.h),
            SignUpWidget(
              onTap: () {},
            )
          ],
        ),
      ),
    );
  }
}

class SignUpWidget extends StatelessWidget {
  final VoidCallback? onTap;

  const SignUpWidget({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            "Don't have an account?",
            style: TextStyle(
              color: AppColors.primaryText,
              fontWeight: FontWeight.normal,
              fontSize: 12.sp,
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: Text(
              "Sign up here",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.primaryElement,
                fontWeight: FontWeight.normal,
                fontSize: 12.sp,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 60.h,
        bottom: 80.h,
      ),
      child: Text(
        "Chatty .",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.primaryText,
          fontSize: 34.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class ThirdPartyLoginButton extends StatelessWidget {
  final String? loginType;
  final bool withIcon;
  final VoidCallback? onTap;

  const ThirdPartyLoginButton(
      {super.key, this.loginType, this.withIcon = true, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 295.w,
        height: 44.h,
        padding: EdgeInsets.all(10.h),
        margin: EdgeInsets.only(
          bottom: 15.h,
        ),
        decoration: BoxDecoration(
          color: AppColors.primaryBackground,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              offset: const Offset(0, 1),
              blurRadius: 2,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment:
              withIcon ? MainAxisAlignment.start : MainAxisAlignment.center,
          children: [
            withIcon
                ? Container(
                    padding: EdgeInsets.only(
                      left: 40.w,
                      right: 30.w,
                    ),
                    child: Image.asset(
                        "assets/icons/${loginType?.toLowerCase()}.png"),
                  )
                : const SizedBox.shrink(),
            Text(
              "Sign in with $loginType",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.primaryText,
                fontSize: 14.sp,
                fontWeight: FontWeight.normal,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class OrDividerWidget extends StatelessWidget {
  const OrDividerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 20.h,
        bottom: 35.h,
      ),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              height: 2.h,
              indent: 50,
              color: AppColors.primarySecondaryElementText,
            ),
          ),
          const Text("  or  "),
          Expanded(
            child: Divider(
              height: 2.h,
              endIndent: 50,
              color: AppColors.primarySecondaryElementText,
            ),
          )
        ],
      ),
    );
  }
}
