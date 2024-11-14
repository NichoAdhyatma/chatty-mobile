import 'dart:io';

import 'package:chatty/common/apis/apis.dart';
import 'package:chatty/common/entities/entities.dart';
import 'package:chatty/common/routes/names.dart';
import 'package:chatty/common/store/store.dart';
import 'package:chatty/common/widgets/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

import 'state.dart';

class ProfileController extends GetxController {
  ProfileController();

  final ProfileState state = ProfileState();

  final TextEditingController nameController = TextEditingController(
    text: UserStore.to.profile.name,
  );

  final TextEditingController descriptionController = TextEditingController(
    text: UserStore.to.profile.description,
  );

  File? _photo;

  final ImagePicker _imagePicker = ImagePicker();

  @override
  void onInit() {
    state.headDetail.value = UserStore.to.profile;
    super.onInit();
  }

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    super.onClose();
  }



  void goLogout() async {
    await GoogleSignIn().signOut();
    await UserStore.to.onLogout();
  }

  Future<void> goSave() async {
    if (state.headDetail.value.name == null ||
        state.headDetail.value.name!.isEmpty ||
        nameController.text.trim().isEmpty) {
      toastInfo(msg: "Name cannot be empty");
      return;
    }

    if (state.headDetail.value.description == null ||
        state.headDetail.value.description!.isEmpty ||
        descriptionController.text.trim().isEmpty) {
      toastInfo(msg: "Description cannot be empty");
      return;
    }

    var userItem = state.headDetail.value;

    LoginRequestEntity loginRequestEntity = LoginRequestEntity(
      name: userItem.name,
      avatar: userItem.avatar,
      description: userItem.description,
      online: userItem.online ?? 0,
    );

    var result = await UserAPI.UpdateProfile(params: loginRequestEntity);

    if (result.code == 1) {
      UserItem userItem = state.headDetail.value;
      await UserStore.to.saveProfile(userItem);
      Get.back(result: userItem);
    }
  }

  Future<void> pickImage(ImageSource source) async {
    XFile? pickedImg = await _imagePicker.pickImage(
      source: source,
    );

    if (pickedImg != null) {
      _photo = File(pickedImg.path);
      uploadFile();
    } else {
      toastInfo(msg: "No image selected");
    }
  }

  Future<void> uploadFile() async {
    var result = await ChatAPI.upload_img(file: _photo);

    if(result.code == 1) {
      state.headDetail.value.avatar = result.data;
      state.headDetail.refresh();
      await UserStore.to.saveProfile(state.headDetail.value);
    }
  }
}
