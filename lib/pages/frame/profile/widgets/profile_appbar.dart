import 'package:chatty/common/values/colors.dart';
import 'package:flutter/material.dart';

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProfileAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        'Profile',
        style: TextStyle(
          color: AppColors.primaryText,
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}
