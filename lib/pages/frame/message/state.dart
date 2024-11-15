import 'package:chatty/common/entities/entities.dart';
import 'package:chatty/common/store/store.dart';
import 'package:get/get.dart';

class MessageState {
 Rx<UserItem> headDetail = UserStore.to.profile.obs;
 RxBool tabStatus = true.obs;
 RxList<Message> messages = <Message>[].obs;
 RxList<CallMessage> calls = <CallMessage>[].obs;
}