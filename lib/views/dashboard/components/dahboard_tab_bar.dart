import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghl_sales_crm/controllers/dashboard_controller.dart';
import 'package:ghl_sales_crm/firebase/firebase_repository.dart';
import 'package:ghl_sales_crm/local_db/shared_preference.dart';
import 'package:ghl_sales_crm/utils/colors.dart';
import 'package:ghl_sales_crm/utils/shared_value.dart';
import 'package:ghl_sales_crm/views/dashboard/components/bottom_sheet.dart';
import 'package:ghl_sales_crm/views/dashboard/components/exist_conformation_dailog.dart';
import 'package:ghl_sales_crm/views/dashboard/today_dashboard.dart';
import 'package:ghl_sales_crm/views/dashboard/total_dashboard.dart';
import 'package:ghl_sales_crm/views/widget/custom_text.dart';

class DashBoardTabBar extends StatefulWidget {
  @override
  _DashBoardTabBarState createState() => _DashBoardTabBarState();
}

class _DashBoardTabBarState extends State<DashBoardTabBar>
    with SingleTickerProviderStateMixin {
  final DashboardController dashboardController =
      Get.put(DashboardController());
  late TabController _tabController;

  // String userName = '';
  SharedPreference sharedPreference = SharedPreference();

  @override
  void initState() {
    super.initState();
    print('access token ${access_token.$}');
    _tabController = TabController(length: 2, vsync: this);
    fetchUserName();
    FirebaseRepository().setupInteractMessage();
    Future.delayed(Duration(seconds: 2), () async {
      await dashboardController.appPermission();
    });
    dashboardController.fetchRecordingFiles();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  fetchUserName() async {
    SharedPreference sharedPreference = SharedPreference();
    dashboardController.userName.value = await sharedPreference.getUserName();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await exitConfirmationDialog(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Obx(() =>
              CustomText(text: "hello, ${dashboardController.userName.value}")),
          leading: GestureDetector(
              onTap: () {
                bottomSheet(context, dashboardController);
              },
              child: Icon(Icons.menu)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(0),
            ),
          ),
          elevation: 0,
          bottom: TabBar(
            controller: _tabController,
            isScrollable: false,
            tabs: [
              Tab(text: 'Today Leads'),
              Tab(text: 'Total Leads'),
            ],
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: MyTheme.mainColor,
            ),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.black,
            labelStyle: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(fontSize: 14.0),
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorPadding:
                EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
            splashFactory: NoSplash.splashFactory,
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            TodayDashBoardScreen(seasons: 'today'),
            TotalDashBoardScreen(seasons: 'total')
          ],
        ),
      ),
    );
  }
}
