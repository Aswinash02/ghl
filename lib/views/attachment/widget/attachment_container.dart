import 'package:flutter/material.dart';
import 'package:ghl_sales_crm/models/attachment_model.dart';
import 'package:ghl_sales_crm/views/widget/custom_text.dart';

Widget attachmentContainer(AttachmentData data) {
  return Container(
    margin: const EdgeInsets.all(5),
    height: 90,
    decoration: const BoxDecoration(
        border: Border(
      bottom: BorderSide(
        color: Colors.grey,
        width: 0.5,
      ),
    )),
    child: Row(
      children: [
        const SizedBox(
          width: 5,
        ),
        Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
              image: const DecorationImage(
                  image: AssetImage("assets/image/png_image.png"), fit: BoxFit.fill),
              borderRadius: BorderRadius.circular(10)),
        ),
        const SizedBox(
          width: 8,
        ),
        CustomText(
          text: data.name ?? '',
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ],
    ),
  );
}
