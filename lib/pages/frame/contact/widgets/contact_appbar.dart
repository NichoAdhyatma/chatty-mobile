import 'package:chatty/common/values/values.dart';
import 'package:flutter/material.dart';

class ContactAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ContactAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        "Contact",
        style: TextStyle(
          color: AppColors.primaryText,
          fontFamily: 'Montserrat',
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}
