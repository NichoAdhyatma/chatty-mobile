import 'package:get/get.dart';

class VoiceCallState {
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
}
