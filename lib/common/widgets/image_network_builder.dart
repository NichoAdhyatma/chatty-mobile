import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageNetworkBuilder extends StatelessWidget {
  const ImageNetworkBuilder({
    super.key,
    this.imageUrl,
    this.width = 50,
    this.height = 50,
  });

  final String? imageUrl;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl ?? "",
      width: width,
      height: height,
      errorWidget: (context, url, error) => CircleAvatar(
        backgroundColor: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Image.asset(imageUrl ?? "assets/images/account_header.png"),
        ),
      ),
      imageBuilder: (context, ImageProvider imageProvider) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
