import 'dart:developer';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:chatty/common/store/store.dart';
import 'package:chatty/common/utils/loading.dart';
import 'package:chatty/common/values/server.dart';
import 'package:chatty/pages/frame/message/voicecall/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  }

  Future<void> joinChannel() async {
    await Permission.microphone.request();

    Loading.show('Loading...');

    await engine.joinChannel(
      token:
          "007eJxTYNBZkW4ye1d0bbmndTurfNHfPY6H0js+1Oswy8V4BM0XiVNgsLQ0MLE0Nk9JTDRJMklJTbQwtEgyTkszNTdJNU0xTUoVS1ZJbwhkZFhRqsLACIUgPg9DckZiSUmlbll+ZnIqAwMAawwfWw==",
      channelId: "chatty-voice",
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
  void dispose() {
    onDispose();
    super.dispose();
  }
}
