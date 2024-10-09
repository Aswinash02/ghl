import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghl_sales_crm/controllers/time_line_controller.dart';
import 'package:ghl_sales_crm/views/time_line/widget/time_line_container.dart';
import 'package:ghl_sales_crm/views/time_line/widget/timeline_bottom_sheet.dart';
import 'package:ghl_sales_crm/views/widget/custom_text.dart';

class TimeLinePage extends StatefulWidget {
  TimeLinePage({super.key});

  @override
  State<TimeLinePage> createState() => _TimeLinePageState();
}

class _TimeLinePageState extends State<TimeLinePage> {
  final timeLineController = Get.put(TimeLineController());

  @override
  void initState() {
    timeLineController.fetchTimeLine(timeLineController.leadId.value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        // backgroundColor: Colors.transparent,
        title: Text("Activity Timeline"),
        leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(Icons.arrow_back)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Obx(() {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              timeLineController.loadingState.value
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Colors.red,
                      ),
                    )
                  : timeLineController.activeTimeLineList.isEmpty
                      ? Center(
                          child: CustomText(text: "No Activity TimeLine Found"))
                      : Expanded(
                          child: ListView.builder(
                              itemCount:
                                  timeLineController.activeTimeLineList.length,
                              itemBuilder: (context, index) {
                                final data = timeLineController
                                    .activeTimeLineList[index];
                                print('data file ${data.voiceRecord}');
                                return timeLineContainer(
                                  data: data,
                                  onTap: () {
                                    timeLineController.play(data.voiceRecord!);
                                    timelineBottomSheet(context, data);
                                    // timeLineController.playerState.value ==
                                    //         PlayerState.playing
                                    //     ? timeLineController.pause()
                                    //     : timeLineController
                                    //         .play(data.callRecord!);
                                  },
                                  context: context,
                                );
                              }), // FutureBuilder(
                        ),
            ],
          );
        }),
      ),
    );
  }
}
