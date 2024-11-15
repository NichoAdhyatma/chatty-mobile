import 'dart:developer';

import 'package:chatty/common/entities/entities.dart';
import 'package:chatty/common/values/colors.dart';
import 'package:chatty/common/widgets/profile_w_indicator.dart';
import 'package:flutter/material.dart';

import '../../../../common/utils/date.dart';

class CallItem extends StatelessWidget {
  const CallItem({
    super.key,
    required this.item,
    this.onTap,
  });

  final CallMessage item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    log('${item.type}', name: 'CallItem');

    return Container(
      padding: EdgeInsets.only(
        top: 10,
        left: 0,
        right: 0,
        bottom: 10,
      ),
      child: InkWell(
        onTap: () {
          if (item.doc_id != null) {
            onTap?.call();
          }
        },
        child: Row(
          children: [
            ProfileWithIndicatorWidget(
              imageUrl: item.avatar,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name ?? "",
                    overflow: TextOverflow.clip,
                    maxLines: 1,
                    softWrap: false,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppColors.thirdElement,
                    ),
                  ),
                  Text(
                    item.call_time ?? "",
                    overflow: TextOverflow.clip,
                    maxLines: 1,
                    softWrap: true,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    duTimeLineFormat(
                        item.last_time?.toDate() ?? DateTime.now()),
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    softWrap: true,
                    style: TextStyle(
                      overflow: TextOverflow.clip,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ),
                Text(
                  item.type ?? "",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
