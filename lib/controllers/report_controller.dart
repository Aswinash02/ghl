import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ghl_sales_crm/repositories/report_repository.dart';
import 'package:ghl_sales_crm/utils/toast_component.dart';


class ReportController extends GetxController {
  TextEditingController reportCon = TextEditingController();
  RxBool disable = false.obs;

  isDisable() {
    if (reportCon.text != '') {
      disable.value = true;
    } else {
      disable.value = false;
    }
    update();
  }

  onTapSave(BuildContext context, int leadId) async {
    var reportResponse = await ReportRepository()
        .createReport(leadId: leadId.toString(), reportNotes: reportCon.text);
    ToastComponent.showDialog(reportResponse.message!);
    if (reportResponse.result == true) {
      reportCon.clear();
      isDisable();
      Navigator.pop(context);
    }
  }

  onTapCancel(BuildContext context) {
    reportCon.clear();
    isDisable();
    Navigator.pop(context);
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
