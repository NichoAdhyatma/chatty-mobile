import 'dart:convert';
import 'dart:developer';

import 'package:chatty/common/apis/apis.dart';
import 'package:chatty/common/entities/entities.dart';
import 'package:chatty/common/routes/names.dart';
import 'package:chatty/common/store/store.dart';
import 'package:chatty/common/utils/http.dart';
import 'package:chatty/common/utils/utils.dart';
import 'package:chatty/pages/frame/message/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum SignInType { email, google, facebook, apple, phoneNumber }

class SignInController extends GetxController {
  SignInController();

  final MessageState state = MessageState();

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'openid',
    ],
  );

  Future<void> handleSignIn(SignInType signInType) async {
    log("Sign in type: ${signInType.index}");
    switch (signInType) {
      case SignInType.google:
        await _handleGoogleSignIn(signInType);
        break;
      case SignInType.facebook:
        await _handleFacebookSignIn();
        break;
      case SignInType.apple:
        await _handleAppleSignIn();
        break;
      case SignInType.phoneNumber:
        await _handlePhoneNumberSignIn();
        break;
      default:
        log("Unknown sign in type: $signInType");
        break;
    }
  }

  _handleGoogleSignIn(SignInType type) async {
    var user = await _googleSignIn.signIn();

    if (user != null) {
      LoginRequestEntity loginRequestEntity = LoginRequestEntity(
        avatar: user.photoUrl ?? "assets/icons/google.png",
        email: user.email,
        name: user.displayName,
        open_id: user.id,
        type: type.index,
      );

      log("User: ${jsonEncode(loginRequestEntity)}");

      asyncPostAllData(loginRequestEntity);
    }
  }

  _handleFacebookSignIn() {}

  _handleAppleSignIn() {}

  _handlePhoneNumberSignIn() {}

  asyncPostAllData(LoginRequestEntity loginRequestEntity) async {
    Loading.show('Loading...');

    final result = await UserAPI.Login(params: loginRequestEntity);

    if (result != null) {
      UserStore.to.saveProfile(result.data!);
      Get.offAllNamed(AppRoutes.Message);
      Loading.toast('Login success');
    } else {
      Loading.toast('Login failed');
    }

    Loading.dismiss();
  }
}
