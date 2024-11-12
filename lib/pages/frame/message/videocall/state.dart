import 'package:get/get.dart';

class VideoCallState {
  RxBool isJoined = false.obs;
  RxBool openMicrophone = true.obs;
  RxBool enableSpeaker = true.obs;
  RxString callStatus = 'not connected'.obs;
  RxString callDuration = '00:00'.obs;

  RxString toToken = ''.obs;
  RxString toName = ''.obs;
  RxString toAvatar = ''.obs;
  RxString docId = ''.obs;

  RxString callRole = 'audience'.obs;
  RxString channelId = ''.obs;

  RxBool isReadyPreview = false.obs;
  RxBool isShowAvatar = true.obs;
  RxBool switchCamera = true.obs;

  RxInt onRemoteUID = 0.obs;
}
