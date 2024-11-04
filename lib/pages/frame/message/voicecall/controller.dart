import 'dart:convert';
import 'dart:developer';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:chatty/common/apis/apis.dart';
import 'package:chatty/common/entities/chat.dart';
import 'package:chatty/common/store/store.dart';
import 'package:chatty/common/utils/loading.dart';
import 'package:chatty/common/values/server.dart';
import 'package:chatty/pages/frame/message/voicecall/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';

class VoiceCallController extends GetxController {
  VoiceCallController();

  final VoiceCallState state = VoiceCallState();
  final AudioPlayer player = AudioPlayer();
  String appId = APPID;
  final db = FirebaseFirestore.instance;
  final profileToken = UserStore.to.profile.token;
  late final RtcEngine engine;

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
          await player.pause();
        },
        onLeaveChannel: (RtcConnection connection, RtcStats stats) {
          log(
            'onLeaveChannel: ${connection.toJson()}, ${stats.toJson()}',
            name: 'RtcEngine onLeaveChannel',
            time: DateTime.now(),
          );
          state.isJoined.value = false;
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

    await engine.enableAudio();

    await engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await engine.setAudioProfile(
      profile: AudioProfileType.audioProfileDefault,
      scenario: AudioScenarioType.audioScenarioGameStreaming,
    );

    await joinChannel();
    if (state.callRole.value == 'anchor') {
      await sendCallNotification("voice");
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
    await Permission.microphone.request();

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

    Loading.dismiss();
  }

  Future<void> leaveChannel() async {
    Loading.show('Loading...');

    await player.pause();
    state.isJoined.value = false;

    Loading.dismiss();

    Get.back();
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
}
