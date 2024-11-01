import 'package:chatty/common/values/colors.dart';
import 'package:chatty/pages/frame/message/voicecall/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VoiceCallPage extends GetView<VoiceCallController> {
  const VoiceCallPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary_bg,
      appBar: AppBar(
        backgroundColor: AppColors.primary_bg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.primaryElementText,
          ),
          onPressed: () {
            controller.endCall();
          },
        ),
      ),
      body: SafeArea(
        child: Obx(
          () => Container(
            child: Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 50),
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        controller.state.callDuration.value,
                        style: TextStyle(
                          color: AppColors.primaryElementText,
                          fontSize: 14,
                        ),
                      ),
                      Container(
                        width: 70,
                        height: 70,
                        margin: EdgeInsets.only(top: 150),
                        child: Image.network(
                          controller.state.toAvatar.value,
                          fit: BoxFit.cover,
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
                ),
                Positioned(
                  bottom: 80,
                  left: 30,
                  right: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      VoiceCallButton(
                        onTap: () {
                          controller.toggleMicrophone();
                        },
                        isActive: controller.state.openMicrophone.value,
                        label: 'Microphone',
                        activeIcon: 'assets/icons/b_microphone.png',
                        inactiveIcon: 'assets/icons/a_microphone.png',
                      ),
                      VoiceCallButton(
                        onTap: () {
                          if(controller.state.isJoined.value) {
                            controller.leaveChannel();
                          } else {
                            controller.joinChannel();
                          }
                          // controller.leaveChannel();
                        },
                        isActive: controller.state.isJoined.value,
                        label: 'Connect',
                        activeLabel: 'Disconnect',
                        activeIcon: 'assets/icons/a_phone.png',
                        inactiveIcon: 'assets/icons/a_telephone.png',
                        activeColor: AppColors.primaryElementBg,
                        inactiveColor: AppColors.primaryElementStatus,
                      ),
                      VoiceCallButton(
                        onTap: () {
                          controller.toggleSpeaker();
                        },
                        isActive: controller.state.enableSpeaker.value,
                        label: 'Speaker',
                        activeIcon: 'assets/icons/b_trumpet.png',
                        inactiveIcon: 'assets/icons/a_trumpet.png',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class VoiceCallButton extends StatelessWidget {
  const VoiceCallButton({
    super.key,
    this.onTap,
    this.isActive = false,
    this.activeColor = AppColors.primaryElementText,
    this.inactiveColor = AppColors.primaryText,
    this.label = '',
    this.activeIcon = '',
    this.inactiveIcon = '',
    this.activeLabel = '',
  });

  final VoidCallback? onTap;
  final bool isActive;
  final Color activeColor;
  final Color inactiveColor;
  final String label;
  final String activeLabel;
  final String activeIcon;
  final String inactiveIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 60,
            height: 60,
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: isActive ? activeColor : inactiveColor,
              borderRadius: BorderRadius.circular(30),
            ),
            child:
                isActive ? Image.asset(activeIcon) : Image.asset(inactiveIcon),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 10),
          child: Text(
            isActive && activeLabel != '' ? activeLabel : label,
            style: TextStyle(
              color: AppColors.primaryElementText,
              fontSize: 12,
            ),
          ),
        )
      ],
    );
  }
}
