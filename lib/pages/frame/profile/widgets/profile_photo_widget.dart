import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatty/common/values/colors.dart';
import 'package:flutter/material.dart';

class ProfilePhotoWidget extends StatelessWidget {
  final VoidCallback? onEditProfileTap;

  const ProfilePhotoWidget({
    super.key,
    this.onEditProfileTap,
    required this.imageUrl,
  });

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CachedNetworkImage(
          imageUrl: imageUrl,
          progressIndicatorBuilder: (context, url, downloadProgress) => Center(
            child: CircularProgressIndicator(
              value: downloadProgress.progress,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.primaryElement,
              ),
            ),
          ),
          imageBuilder: (context, imageProvider) => Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(60),
              color: AppColors.primarySecondaryBackground,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  offset: const Offset(0, 1),
                  blurRadius: 2,
                  spreadRadius: 1,
                )
              ],
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          right: 0,
          height: 35,
          child: GestureDetector(
            onTap: onEditProfileTap,
            child: Container(
              height: 35,
              width: 35,
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primaryElement,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Image.asset("assets/icons/edit.png"),
            ),
          ),
        ),
      ],
    );
  }
}