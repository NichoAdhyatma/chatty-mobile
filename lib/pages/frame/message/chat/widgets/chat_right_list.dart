import 'package:chatty/common/entities/entities.dart';
import 'package:chatty/common/values/values.dart';
import 'package:flutter/material.dart';

enum BubbleType { left, right }

class ChatRightList extends StatelessWidget {
  const ChatRightList({
    super.key,
    required this.item,
    required this.type,
  });

  final Msgcontent item;

  final BubbleType type;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: 250,
        maxWidth: 250,
        minHeight: 40,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: type == BubbleType.right
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          IntrinsicWidth(
            child: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              margin: type == BubbleType.right
                  ? EdgeInsets.only(
                      bottom: 15,
                      top: 5,
                      right: 15,
                    )
                  : EdgeInsets.only(
                      bottom: 15,
                      top: 5,
                      left: 15,
                    ),
              decoration: BoxDecoration(
                color: type == BubbleType.right
                    ? AppColors.primaryElement
                    : AppColors.primarySecondaryBackground,
                borderRadius: type == BubbleType.right
                    ? BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      )
                    : BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
              ),
              child: item.type == "text"
                  ? Text(
                      '${item.content}',
                      style: TextStyle(
                        fontSize: 14,
                        color: type == BubbleType.right
                            ? AppColors.primaryElementText
                            : AppColors.primaryThreeElementText,
                      ),
                    )
                  : Text(''),
            ),
          ),
        ],
      ),
    );
  }
}
