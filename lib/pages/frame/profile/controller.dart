import 'package:chatty/common/routes/names.dart';
import 'package:chatty/common/store/store.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'state.dart';

class ProfileController extends GetxController {
  ProfileController();

  final ProfileState state = ProfileState();

  void goLogout() async {
    await GoogleSignIn().signOut();
    await UserStore.to.onLogout();
  }

}
