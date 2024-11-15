import 'package:chatty/common/entities/contact.dart';
import 'package:chatty/common/values/colors.dart';
import 'package:chatty/common/widgets/image_network_builder.dart';
import 'package:chatty/pages/frame/contact/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactList extends GetView<ContactController> {
  const ContactList({super.key});

  Widget _buildListItem(ContactItem item) {
    return InkWell(
      onTap: () {
        controller.goToChat(item);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 16,
        ),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppColors.primarySecondaryBackground,
              width: 1.0,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: AppColors.primarySecondaryBackground,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      offset: const Offset(0, 1),
                      blurRadius: 2,
                    ),
                  ]),
              child: ImageNetworkBuilder(
                imageUrl: item.avatar,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                item.name ?? "",
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                softWrap: true,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.thirdElement,
                ),
              ),
            ),
            SizedBox(height: 5),
            SizedBox(
              width: 12,
              height: 12,
              child: Image.asset("assets/icons/ang.png"),
            )
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
            vertical: 0,
            horizontal: 20,
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


