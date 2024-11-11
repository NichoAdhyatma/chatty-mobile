import 'package:chatty/common/entities/entities.dart';
import 'package:get/get.dart';

class MessageState {
 Rx<UserItem> headDetail = UserItem().obs;
 RxBool tabStatus = true.obs;
 RxList<Message> messages = <Message>[].obs;
}