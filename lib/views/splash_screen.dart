import 'package:flutter/material.dart';
import 'package:ghl_sales_crm/app_config.dart';
import 'package:ghl_sales_crm/helpers/auth_helpers.dart';
import 'package:ghl_sales_crm/local_db/shared_preference.dart';
import 'package:ghl_sales_crm/views/dashboard/components/dahboard_tab_bar.dart';
import 'package:ghl_sales_crm/utils/shared_value.dart';
import 'package:ghl_sales_crm/views/auth/login_page.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  PackageInfo _packageInfo = PackageInfo(
    appName: AppConfig.app_name,
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  void initState() {

    super.initState();
    _initPackageInfo();
    getSharedValueHelperData().then((value) {
      Future.delayed(const Duration(seconds: 2)).then((value) async {
        final isLogged = await SharedPreference().getLogin();
        if (isLogged) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => DashBoardTabBar()));
        } else {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) {
                return LoginPage();
              },
            ),
            (route) => false,
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Image(
            image: AssetImage('assets/image/app_logo.png'),
          ),
        ),
      ),
    );
  }

  Future<String?> getSharedValueHelperData() async {
    access_token.load().whenComplete(() {
      AuthHelper().fetch_and_set();
    });
    await app_language.load();
    await app_mobile_language.load();
    await app_language_rtl.load();
    await system_currency.load();
    return app_mobile_language.$;
  }
}
