import 'package:chatty/common/values/values.dart';
import 'package:chatty/pages/frame/profile/controller.dart';
import 'package:chatty/pages/frame/profile/widgets/complete_button_widget.dart';
import 'package:chatty/pages/frame/profile/widgets/logout_button_widget.dart';
import 'package:chatty/pages/frame/profile/widgets/profile_appbar.dart';
import 'package:chatty/pages/frame/profile/widgets/profile_photo_widget.dart';
import 'package:chatty/pages/frame/profile/widgets/profile_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ProfileAppBar(),
      body: SafeArea(
        child: Obx(() {
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ProfilePhotoWidget(
                      onEditProfileTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return SafeArea(
                              child: Wrap(
                                direction: Axis.horizontal,
                                children: [
                                  ListTile(
                                    title: const Text("Camera"),
                                    leading: const Icon(Icons.camera),
                                    onTap: () {
                                      controller.pickImage(ImageSource.camera);
                                      Get.back();
                                    },
                                  ),
                                  ListTile(
                                    title: const Text("Gallery"),
                                    leading: const Icon(Icons.image),
                                    onTap: () {
                                      controller.pickImage(ImageSource.gallery);
                                      Get.back();
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      imageUrl: controller.state.headDetail.value.avatar ?? "",
                    ),
                    NameDescriptionFormWidget(
                      controller: controller,
                    ),
                    CompleteButtonWidget(
                      onTap: controller.goSave,
                    ),
                    LogoutButtonWidget(
                      onLogoutTap: () {
                        controller.goLogout();
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class NameDescriptionFormWidget extends StatelessWidget {
  const NameDescriptionFormWidget({
    super.key,
    required this.controller,
  });

  final ProfileController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 44,
          width: 295,
          margin: const EdgeInsets.only(
            top: 60,
            bottom: 20,
          ),
          decoration: BoxDecoration(
            color: AppColors.primaryBackground,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(
                  0,
                  1,
                ),
              ),
            ],
          ),
          child: ProfileTextfield(
            textEditingController: controller.nameController,
            hintText: "Your Name",
            onChanged: (value) {
              controller.state.headDetail.value.name = value;
            },
          ),
        ),
        Container(
          height: 44,
          width: 295,
          margin: const EdgeInsets.only(
            bottom: 20,
          ),
          decoration: BoxDecoration(
            color: AppColors.primaryBackground,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(
                  0,
                  1,
                ),
              ),
            ],
          ),
          child: ProfileTextfield(
            hintText: "Description about you",
            keyboardType: TextInputType.multiline,
            textEditingController: controller.descriptionController,
            onChanged: (value) {
              controller.state.headDetail.value.description = value;
            },
          ),
        ),
      ],
    );
  }
}
