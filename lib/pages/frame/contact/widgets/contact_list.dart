import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatty/common/entities/contact.dart';
import 'package:chatty/common/values/colors.dart';
import 'package:chatty/pages/frame/contact/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ContactList extends GetView<ContactController> {
  const ContactList({super.key});

  Widget _buildListItem(ContactItem item) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 16.w,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.primarySecondaryBackground,
            width: 1.0,
          ),
        ),
      ),
      child: InkWell(
        onTap: () {},
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44.w,
              height: 44.w,
              decoration:  BoxDecoration(
                color: AppColors.primarySecondaryBackground,
                borderRadius: BorderRadius.circular(22.w),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    offset: const Offset(0, 1),
                    blurRadius: 2,
                  ),
                ]
              ),
              child: CachedNetworkImage(
                imageUrl: item.avatar ?? "",
                height: 44.w,
                width: 44.w,
                errorWidget: (context, url, error) => CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.asset(item.avatar ?? ""),
                  ),
                ),
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22.w),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name ?? "",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: AppColors.primaryText,
                  ),
                ),
                SizedBox(height: 5.w),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.symmetric(
            vertical: 0.w,
            horizontal: 20.w,
          ),
          sliver: Obx(
            () {
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    var contact = controller.state.contacts[index];

                    return _buildListItem(contact);
                  },
                  childCount: controller.state.contacts.length,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
