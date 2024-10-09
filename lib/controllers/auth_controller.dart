import 'package:get/get.dart';
import 'package:ghl_sales_crm/helpers/auth_helpers.dart';
import 'package:ghl_sales_crm/local_db/shared_preference.dart';
import 'package:ghl_sales_crm/repositories/auth_repositories.dart';
import 'package:ghl_sales_crm/utils/toast_component.dart';
import 'package:ghl_sales_crm/views/auth/login_page.dart';

class AuthController extends GetxController {
  Future<void> logout(context) async {
    AuthHelper authHelper = AuthHelper();
    SharedPreference sharedPreference = SharedPreference();
    var logoutResponse = await AuthRepository().getLogoutResponse();
    if (logoutResponse.result == true) {
      authHelper.clearUserData();
      await sharedPreference.clearUserData();
      ToastComponent.showDialog(logoutResponse.message!.toString());
      Get.offAll(() => LoginPage());
    } else {
      ToastComponent.showDialog(logoutResponse.message!.toString());
    }
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
