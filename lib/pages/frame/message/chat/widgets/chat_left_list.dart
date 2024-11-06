import 'package:chatty/common/entities/entities.dart';
import 'package:flutter/material.dart';

class ChatLeftList extends StatelessWidget {
  const ChatLeftList({super.key, required this.item});
  final Msgcontent item;

  @override
  Widget build(BuildContext context) {
    return Text("${item.content}");
  }
}
