import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:chatty/common/apis/chat.dart';
import 'package:chatty/common/entities/entities.dart';
import 'package:chatty/common/store/user.dart';
import 'package:chatty/common/utils/utils.dart';
import 'package:chatty/common/values/server.dart';
import 'package:chatty/pages/frame/message/videocall/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';

class VideoCallController extends GetxController {
  VideoCallController();

  final VideoCallState state = VideoCallState();

  final AudioPlayer player = AudioPlayer();
  String appId = APPID;
  final db = FirebaseFirestore.instance;
  final profileToken = UserStore.to.profile.token;
  late final RtcEngine engine;

  int callSeconds = 0;
  int callMinutes = 0;
  int callHours = 0;

  late final Timer callTimer;

  @override
  void onInit() {
    var data = Get.parameters;

    state.toAvatar.value = data['to_avatar'] ?? '';
    state.toName.value = data['to_name'] ?? '';
    state.toToken.value = data['to_token'] ?? '';
    state.callRole.value = data['call_role'] ?? '';
    state.docId.value = data['doc_id'] ?? '';
    initEngine();

    super.onInit();
  }

  void endCall() {
    Get.back();
  }

  void toggleMicrophone() {
    state.openMicrophone.value = !state.openMicrophone.value;
  }

  void toggleSpeaker() {
    state.enableSpeaker.value = !state.enableSpeaker.value;
  }

  Future<void> initEngine() async {
    await player.setAsset('assets/Sound_Horizon.mp3');

    engine = createAgoraRtcEngine();

    await engine.initialize(RtcEngineContext(
      appId: appId,
    ));

    engine.registerEventHandler(
      RtcEngineEventHandler(
        onError: (ErrorCodeType err, String msg) {
          log(
            'onError: $err, $msg',
            name: 'RtcEngine onError',
            time: DateTime.now(),
          );
        },
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          log(
            'onJoinChannelSuccess: ${connection.toJson()}, $elapsed',
            name: 'RtcEngine onJoinChannelSuccess',
            time: DateTime.now(),
          );
          state.isJoined.value = true;
        },
        onUserJoined:
            (RtcConnection connection, int remoteUId, int elapsed) async {
          log(
            'onUserJoined: ${connection.toJson()}, $remoteUId, $elapsed',
            name: 'RtcEngine onUserJoined',
            time: DateTime.now(),
          );

          state.onRemoteUID.value = remoteUId;

          log("remoteUId: $remoteUId",
              name: 'RtcEngine onUserJoined', time: DateTime.now());

          state.isShowAvatar.value = false;

          callTime();

          await player.pause();
        },
        onLeaveChannel: (RtcConnection connection, RtcStats stats) {
          log(
            'onLeaveChannel: ${connection.toJson()}, ${stats.toJson()}',
            name: 'RtcEngine onLeaveChannel',
            time: DateTime.now(),
          );
          state.isJoined.value = false;

          state.onRemoteUID.value = 0;

          state.isShowAvatar.value = true;
        },
        onRtcStats: (RtcConnection connection, RtcStats stats) {
          log(
            'onRtcStats: ${connection.toJson()}, ${stats.toJson()}',
            name: 'RtcEngine onRtcStats',
            time: DateTime.now(),
          );
        },
      ),
    );

    await engine.enableVideo();

    await engine.setVideoEncoderConfiguration(
      const VideoEncoderConfiguration(
        dimensions: VideoDimensions(width: 640, height: 480),
        frameRate: 24,
        bitrate: 0,
      ),
    );

    await engine.startPreview();

    state.isReadyPreview.value = true;

    await joinChannel();
    if (state.callRole.value == 'anchor') {
      await sendCallNotification("video");
      await player.play();
    }
  }

  Future<void> sendCallNotification(String callType) async {
    final callRequestEntity = CallRequestEntity(
      call_type: callType,
      to_avatar: state.toAvatar.value,
      to_token: state.toToken.value,
      doc_id: state.docId.value,
      to_name: state.toName.value,
    );

    final result = await ChatAPI.call_notifications(params: callRequestEntity);

    if (result.code == 1) {
      log("notification success send");
    } else {
      log("notification failed to send");
    }
  }

  Future<String> getToken() async {
    if (state.callRole.value == 'anchor') {
      state.channelId.value = md5
          .convert(utf8.encode("${profileToken}_${state.toToken.value}"))
          .toString();
    } else {
      state.channelId.value = md5
          .convert(utf8.encode("${state.toToken.value}_$profileToken"))
          .toString();
    }

    CallTokenRequestEntity callTokenRequestEntity = CallTokenRequestEntity(
      channel_name: state.channelId.value,
    );

    var response = await ChatAPI.call_token(
      params: callTokenRequestEntity,
    );

    if (response.code == 1) {
      return response.data!;
    }

    return "";
  }

  Future<void> joinChannel() async {
    final result = await [Permission.microphone, Permission.camera].request();

    log("result: $result", name: 'joinChannel', time: DateTime.now());
    Loading.show('Loading...');

    String token = await getToken();

    if (token.isEmpty) {
      Loading.dismiss();
      Get.back();
      return;
    }

    await engine.joinChannel(
      token: token,
      channelId: state.channelId.value,
      uid: 0,
      options: ChannelMediaOptions(
        channelProfile: ChannelProfileType.channelProfileCommunication,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      ),
    );

    log('Channel ID: ${state.channelId.value}',
        name: 'joinChannel', time: DateTime.now());

    Loading.dismiss();
  }

  Future<void> leaveChannel() async {
    Loading.show('Loading...');

    await player.pause();

    await sendCallNotification("cancel");

    state.isJoined.value = false;

    state.switchCamera.value = true;

    Loading.dismiss();

    Get.back();
  }

  Future<void> switchCamera() async {
    await engine.switchCamera();
    state.switchCamera.value = !state.switchCamera.value;
  }

  Future<void> onDispose() async {
    await player.pause();
    await engine.leaveChannel();
    await engine.release();
    await player.stop();
  }

  @override
  void onClose() {
    onDispose();
    super.onClose();
  }

  @override
  void dispose() {
    onDispose();
    super.dispose();
  }

  void callTime() {
    callTimer = Timer.periodic(
      Duration(seconds: 1),
      (timer) {
        callSeconds++;
        if (callSeconds == 60) {
          callMinutes++;
          callSeconds = 0;
        }
        if (callMinutes == 60) {
          callHours++;
          callMinutes = 0;
        }
        var h = callHours < 10 ? '0$callHours' : callHours;

        var m = callMinutes < 10 ? '0$callMinutes' : callMinutes;

        var s = callSeconds < 10 ? '0$callSeconds' : callSeconds;

        if (callHours == 0) {
          state.callDuration.value = '$m:$s';
          state.callTimeNum.value = '$callMinutes m and $callSeconds s';
        } else {
          state.callDuration.value = '$h:$m:$s';
          state.callTimeNum.value =
              '$callHours h, $callMinutes m and $callSeconds s';
        }
      },
    );
  }
}
