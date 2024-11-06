import 'package:chatty/common/entities/entities.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ChatState {
  RxList<Msgcontent> messages = <Msgcontent>[].obs;
  TextEditingController messageController = TextEditingController();

  RxString toToken = ''.obs;
  RxString toName = ''.obs;
  RxString toAvatar = ''.obs;
  RxString toOnline = ''.obs;


  RxBool moreStatus = false.obs;

}
