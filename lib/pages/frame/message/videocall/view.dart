import 'dart:developer';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:chatty/common/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class VideoCallPage extends GetView<VideoCallController> {
  const VideoCallPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary_bg,
      body: SafeArea(
        child: Obx(() {
          return Container(
            child: controller.state.isReadyPreview.value
                ? Stack(
                    children: [
                      controller.state.onRemoteUID.value == 0
                          ? Container()
                          : AgoraVideoView(
                              controller: VideoViewController.remote(
                                rtcEngine: controller.engine,
                                canvas: VideoCanvas(
                                  uid: controller.state.onRemoteUID.value,
                                ),
                                connection: RtcConnection(
                                  channelId: controller.state.channelId.value,
                                ),
                              ),
                            ),
                      Positioned(
                        bottom: 30,
                        right: 15,
                        child: SizedBox(
                          width: 120,
                          height: 200,
                          child: AgoraVideoView(
                            controller: VideoViewController(
                              rtcEngine: controller.engine,
                              canvas: const VideoCanvas(uid: 0),
                            ),
                          ),
                        ),
                      ),
                      controller.state.isShowAvatar.value
                          ? Container()
                          : Positioned(
                              top: 10,
                              left: 30,
                              right: 30,
                              child: Column(
                                children: [
                                  Container(
                                    child: Text(
                                      controller.state.callDuration.value,
                                      style: TextStyle(
                                        color: AppColors.primaryElementText,
                                        fontSize: 14,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                      Positioned(
                        bottom: 80,
                        left: 30,
                        right: 30,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    controller.state.isJoined.value
                                        ? controller.leaveChannel()
                                        : controller.joinChannel();
                                  },
                                  child: Container(
                                    width: 60,
                                    height: 60,
                                    padding: EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: controller.state.isJoined.value
                                          ? AppColors.primaryElementBg
                                          : AppColors.primaryElementStatus,
                                    ),
                                    child: controller.state.isJoined.value
                                        ? Image.asset(
                                            'assets/icons/a_phone.png')
                                        : Image.asset(
                                            'assets/icons/a_telephone.png'),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: Text(
                                    controller.state.isJoined.value
                                        ? 'Disconnect'
                                        : 'Connecting',
                                    style: TextStyle(
                                      color: AppColors.primaryElementText,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      controller.state.isShowAvatar.value
                          ? Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(top: 10),
                              child: Column(
                                children: [
                                  Container(
                                    width: 70,
                                    height: 70,
                                    margin: EdgeInsets.only(top: 150),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: AppColors.primaryElementText,
                                    ),
                                    child: Image.network(
                                      controller.state.toAvatar.value,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: Text(
                                      controller.state.toName.value,
                                      style: TextStyle(
                                        color: AppColors.primaryElementText,
                                        fontSize: 18,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                    ],
                  )
                : Container(),
          );
        }),
      ),
    );
  }
}
