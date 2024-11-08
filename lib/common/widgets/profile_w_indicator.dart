import 'package:chatty/common/widgets/image_network_builder.dart';
import 'package:flutter/material.dart';

import '../values/colors.dart';

class ProfileWithIndicatorWidget extends StatelessWidget {
  const ProfileWithIndicatorWidget({
    super.key,
    this.imageUrl,
    this.isOnline,
  });

  final String? imageUrl;
  final String? isOnline;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ImageNetworkBuilder(
          imageUrl: imageUrl,
        ),
        Positioned(
          bottom: 0,
          right: 2,
          height: 14,
          child: Container(
            width: 12,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.primaryElementText,
                width: 2,
              ),
              color: isOnline == '1'
                  ? AppColors.primaryElementStatus
                  : Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}
