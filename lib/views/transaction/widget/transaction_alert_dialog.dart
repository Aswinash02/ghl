import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghl_sales_crm/controllers/transaction_controller.dart';
import 'package:ghl_sales_crm/utils/custom_button.dart';
import 'package:ghl_sales_crm/utils/custom_rich_text.dart';
import 'package:ghl_sales_crm/utils/custom_text_field.dart';
import 'package:ghl_sales_crm/views/widget/custom_text.dart';

Future<void> transactionAlertDialog(BuildContext context, String leadId) {
  TransactionController transactionController =
      Get.find<TransactionController>();
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
          backgroundColor:Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text('Transaction Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              customRichText(text: "Date"),
              SizedBox(height: 5),
              CustomTextField(
                controller: transactionController.dateCon,
                readOnly: true,
                hintText: "Select Date",
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  await transactionController.displayDatePicker(context);
                },
                suffixIcon: Icon(
                  Icons.date_range,
                  color: Colors.red,
                ),
              ),
              SizedBox(height: 10),
              customRichText(text: "Transaction Id"),
              SizedBox(height: 5),
              CustomTextField(
                controller: transactionController.transactionIdCon,
                hintText: "Enter Transaction Id",
                onChange: (String value) {

                  transactionController.isDisable();
                },
              ),
              SizedBox(height: 10),
              customRichText(text: "Amount"),
              SizedBox(height: 5),
              CustomTextField(
                controller: transactionController.amountCon,
                hintText: "Enter Amount",
                keyboardType: TextInputType.number,
                onChange: (String value) {
                  transactionController.isDisable();
                },
              ),
            ],
          ),
        ),
        actions: <Widget>[
          GestureDetector(
            child: Container(
              width: 80,
              padding: EdgeInsets.all(10),
              child: Center(
                child: CustomText(
                  text: "Cancel",
                  color: Colors.white,
                ),
              ),
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(10)),
            ),
            onTap: () {
              transactionController.onTapCancel(context);
            },
          ),

          Obx(
            () => customButton(
                text: "Save",
                color: Colors.red,
                isDisable: transactionController.disable.value,
                onTap: () {
                  transactionController.onTapSave(context, leadId);
                }),
          ),

        ],
      );
    },
  );
}



// Widget loadingContainer() {
//   return GestureDetector(
//     child: Container(
//       width: 80,
//       height: 40,
//       padding: EdgeInsets.all(10),
//       child: Center(
//         child: CircularProgressIndicator(strokeWidth: 2,value: 2, color: Colors.white),
//       ),
//       decoration: BoxDecoration(
//         color: Colors.red,
//         borderRadius: BorderRadius.circular(10),
//       ),
//     ),
//   );
// }
