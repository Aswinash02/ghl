import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:ghl_sales_crm/common/custom_button.dart';
import 'package:ghl_sales_crm/controllers/attachment_controller.dart';
import 'package:ghl_sales_crm/controllers/dashboard_controller.dart';
import 'package:ghl_sales_crm/controllers/file_controller.dart';
import 'package:ghl_sales_crm/controllers/lead_details_controller.dart';
import 'package:ghl_sales_crm/controllers/report_controller.dart';
import 'package:ghl_sales_crm/controllers/time_line_controller.dart';
import 'package:ghl_sales_crm/helpers/file_helper.dart';
import 'package:ghl_sales_crm/local_db/shared_preference.dart';
import 'package:ghl_sales_crm/models/lead_datas_create_model.dart';
import 'package:ghl_sales_crm/models/lead_status_model.dart';
import 'package:ghl_sales_crm/utils/colors.dart';
import 'package:ghl_sales_crm/utils/custom_rich_text.dart';
import 'package:ghl_sales_crm/utils/custom_text_field.dart';
import 'package:ghl_sales_crm/utils/toast_component.dart';
import 'package:ghl_sales_crm/views/leadsDetails/widget/conformation_dialog.dart';
import 'package:ghl_sales_crm/views/leadsDetails/widget/detail_container.dart';
import 'package:ghl_sales_crm/views/leadsDetails/widget/header_icon_container.dart';
import 'package:ghl_sales_crm/views/leadsDetails/widget/invest_widget.dart';
import 'package:ghl_sales_crm/views/leadsDetails/widget/text_card.dart';
import 'package:ghl_sales_crm/views/transaction/screen/transaction_screen.dart';
import 'package:ghl_sales_crm/views/widget/custom_text.dart';
import 'package:permission_handler/permission_handler.dart';

class LeadDetailsScreen extends StatefulWidget {
  const LeadDetailsScreen(
      {super.key,
      required this.phoneNumber,
      required this.firstLetter,
      required this.lastLetter,
      required this.leadName,
      required this.leadId,
      required this.email,
      required this.userName,
      this.status,
      this.platform,
      this.session});

  final String phoneNumber;
  final String leadName;
  final String firstLetter;
  final String lastLetter;
  final int leadId;
  // final bool isFiltered;
  final String email;
  final String? platform;
  final String? session;
  final int? status;

  final String userName;

  @override
  State<LeadDetailsScreen> createState() => _LeadDetailsScreenState();
}

class _LeadDetailsScreenState extends State<LeadDetailsScreen> {
  String audioFileData = '';
  File? audioFilesData;
  int? leadID;
  int? userId;
  int? oldStatus;
  String? status;
  String? testNotes;
  String? dates;
  TimeLineController timeLineController = Get.put(TimeLineController());
  AttachmentController attachmentController = Get.put(AttachmentController());
  ReportController reportController = Get.put(ReportController());
  FileController fileController = Get.put(FileController());
  DashboardController dashboardController = Get.find<DashboardController>();

  int? user_Id;
  LeadsController leadsController = Get.put(LeadsController());

  final key = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    initRecorder();
    timeLineController.leadId.value = widget.leadId;
    timeLineController.fetchTimeLine(widget.leadId);
    attachmentController.fetchAttachment();
    leadsController.fetchIndividualLeads(widget.leadId);
    leadsController.nameCon.text = widget.leadName;
    // leadsController.fetchLastCallRecordingFile(widget.phoneNumber);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    leadsController.isSubmitted = false;
    super.dispose();
  }

  void setButtonEnabled(bool isButtonEnabled) {
    setState(() {
      isButtonEnabled != isButtonEnabled;
    });
  }

  final recorder = FlutterSoundRecorder();

  Future initRecorder() async {
    if (!await Permission.microphone.request().isGranted) {
      throw 'Permission not granted';
    }
    await recorder.openRecorder();

    recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
  }

  Future startRecord() async {
    await recorder.startRecorder(
      toFile: "audio.aac",
      codec: Codec.aacADTS,
    );
  }

  Future stopRecorder() async {
    final filePath = await recorder.stopRecorder();
    final file = File(filePath!);
    audioFilesData = File(filePath);
    audioFileData = FileHelper.getBase64FormateFile(file.path);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      key: key,
      appBar: AppBar(
        title: const Text('Lead Details'),
        // backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
            Container(
              height: 70,
              width: 70,
              decoration: const BoxDecoration(
                  color: Color(0XFFFCE9E9), shape: BoxShape.circle),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.firstLetter,
                    style: const TextStyle(
                      color: MyTheme.red,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.lastLetter,
                    style: const TextStyle(
                      color: MyTheme.red,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // const SizedBox(
            //   height: 15,
            // ),
            Container(
              height: 35,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: leadsController.nameCon,
                cursorHeight: 20,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                onSubmitted: (String name) {
                  leadsController.editLeadName(
                      id: widget.leadId,
                      name: name,
                      // isFiltered: widget.isFiltered,
                      // status: widget.status,
                      // session: widget.session,
                      // platform: widget.platform
                  );
                },
              ),
            ),
            const SizedBox(height: 5),
            // CustomText(
            //   text: widget.leadName,
            //   fontWeight: FontWeight.w500,
            //   fontSize: 18,
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  text: widget.email,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(
                      ClipboardData(text: widget.email),
                    );
                    ToastComponent.showDialog("Email Copied");
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Icon(
                      Icons.copy,
                      size: 15,
                      color: Colors.grey,
                    ),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  text: widget.phoneNumber,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(
                      ClipboardData(text: widget.phoneNumber),
                    );
                    ToastComponent.showDialog("Phone Number Copied");
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Icon(
                      Icons.copy,
                      size: 15,
                      color: Colors.grey,
                    ),
                  ),
                )
              ],
            ),
            GestureDetector(
              onTap: () {
                leadsController.createContact(
                    leadName: widget.leadName, leadNumber: widget.phoneNumber);
              },
              child: Container(
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(8),
                child: const Text('Add To Contact'),
                decoration: BoxDecoration(
                    color: const Color(0XFFFCE9E9),
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            HeaderIconContainer(
              phoneNumber: widget.phoneNumber,
              email: widget.email,
              leadId: widget.leadId,
              screenWidth: screenWidth,
              leadsController: leadsController,
            ),
            Obx(
              () => leadsController.isInvestor.value == 1
                  ? Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 10),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TransactionScreen(
                                        leadId: widget.leadId,
                                      )));
                        },
                        child: Container(
                          width: double.infinity,
                          child: ListTile(
                            leading: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: SizedBox(
                                height: screenWidth / 12,
                                width: screenWidth / 12,
                                child: const Image(
                                  image: AssetImage(
                                    "assets/image/transaction_icon.png",
                                  ),
                                ),
                              ),
                            ),
                            title: const CustomText(text: "Transaction"),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 18,
                              color: Colors.red,
                            ),
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: leadsController.shadow),
                        ),
                      ),
                    )
                  : const SizedBox(),
            ),
            const SizedBox(
              height: 15,
            ),
            Obx(
              () => leadsController.leadDetailsData.value.notes != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Wrap(
                        children: [
                          const CustomText(text: "Followup Notes"),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Obx(
                              () => textCard(
                                  text: leadsController
                                          .leadDetailsData.value.notes ??
                                      ""),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),
            ),
            const SizedBox(
              height: 10,
            ),
            detailContainer(leadsController),
            const SizedBox(
              height: 10,
            ),
            leadsController.leadDetailsData.value.description != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Wrap(
                      children: [
                        const CustomText(text: "Description"),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: textCard(
                              text: leadsController
                                      .leadDetailsData.value.description ??
                                  ""),
                        ),
                      ],
                    ),
                  )
                : Container(),
            const SizedBox(
              height: 10,
            ),
            leadsController.leadDetailsData.value.information != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Wrap(
                      children: [
                        const CustomText(text: "Information"),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: textCard(
                              text: leadsController
                                      .leadDetailsData.value.information ??
                                  ""),
                        ),
                      ],
                    ),
                  )
                : Container(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: CustomText(
                    text: "Add Comments",
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  )),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomText(text: "Upload File"),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                      controller: leadsController.fileCon,
                      hintText: "Select Image File",
                      readOnly: true,
                      onTap: () {
                        leadsController.pickFile("");
                      },
                      prefixIcon: const Image(
                          image: AssetImage("assets/image/file_icon.png"))),
                  const SizedBox(
                    height: 10,
                  ),
                  const CustomText(text: "Upload Call Recording File"),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                      controller: leadsController.callRecordingFileCon,
                      readOnly: true,
                      hintText: "Select Call Recording File",
                      onChange: (String value) {
                        leadsController.isDisable();
                      },
                      onTap: () {
                        leadsController.pickFile("Call");
                      },
                      prefixIcon: const Image(
                          image: AssetImage("assets/image/file_icon.png"))),
                  const SizedBox(
                    height: 10,
                  ),
                  const CustomText(text: "Status"),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: leadsController.shadow),
                    child: Obx(
                      () => DropdownButton<Data>(
                        iconSize: 12,
                        underline: const SizedBox(),
                        icon: const Image(
                          image: AssetImage("assets/image/arrow_down_icon.png"),
                        ),
                        value: leadsController.leadStatusList.isNotEmpty
                            ? leadsController.leadStatusList.firstWhere(
                                (leads) {
                                  return leads.id ==
                                      leadsController.selectedLeadIds.value;
                                },
                                orElse: () {
                                  leadsController.selectedLeadNames.value =
                                      leadsController.leadStatusList[0].name!;
                                  return leadsController.leadStatusList[0];
                                },
                              )
                            : null,
                        borderRadius: BorderRadius.circular(10),
                        items: leadsController.leadStatusList.map((Data item) {
                          return DropdownMenuItem<Data>(
                            value: item,
                            child: Container(
                              width: screenWidth / 1.24,
                              height: 60,
                              padding: const EdgeInsets.only(left: 10),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(item.name!),
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: leadsController.onChangeStatus,
                        hint: const Text('Select Status'),
                        style: TextStyle(
                          color: MyTheme.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Obx(
                    () => leadsController.selectedLeadIds.value == 10
                        ? investWidget(context, leadsController)
                        : Container(),
                  ),
                  Obx(
                    () => leadsController.selectedLeadIds.value == 4 ||
                            leadsController.selectedLeadIds.value == 5
                        ? Wrap(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child:
                                    customRichText(text: "Followup DateTime"),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: CustomTextField(
                                  controller: leadsController.dateTimeCon,
                                  readOnly: true,
                                  hintText: "Select DateTime",
                                  onTap: () async {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    await leadsController
                                        .dateTimePicker(context);
                                  },
                                  suffixIcon: const Icon(
                                    Icons.date_range,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : const SizedBox(),
                  ),
                  customRichText(text: "Followup Notes"),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 110,
                    child: CustomTextField(
                        controller: leadsController.followupNotesCon,
                        hintText: "Enter Notes",
                        onChange: (String value) {
                          leadsController.isDisable();
                        },
                        maxLines: 4),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const CustomText(text: "Record"),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (recorder.isRecording) {
                        await stopRecorder();
                        setState(() {});
                      } else {
                        await startRecord();
                        setState(() {});
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: leadsController.shadow),
                      child: Row(
                        children: [
                          const CustomText(
                            text: "Sent Voice",
                          ),
                          const Spacer(),
                          recorder.isRecording
                              ? const Icon(
                                  Icons.stop,
                                  size: 18,
                                  color: MyTheme.red,
                                )
                              : const Image(
                                  image:
                                      AssetImage("assets/image/mic_icon.png"))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Obx(() {
              print('audioFilesData file ${audioFilesData}');
              return CustomButton(
                  buttonText: "Submit",
                  disable: leadsController.setDisable.value,
                  onTap: () async {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return conformationDialog(context, leadsController);
                      },
                    );
                    SharedPreference sharedPreference = SharedPreference();
                    String user_Id = await sharedPreference.getUserId();
                    File callRecordingFile =
                        fileController.callRecordingFilesList.isEmpty
                            ? leadsController.callFiles
                            : leadsController.lastCallRecording;
                    LeadDatasCreate response = await leadsController.createLead(
                      leadsController.leadDetailsData.value.id,
                      int.parse(user_Id),
                      leadsController.leadDetailsData.value.statusInt,
                      leadsController.selectedLeadIds.value,
                      leadsController.followupNotesCon.text,
                      leadsController.dateTimeCon.text,
                      "",
                      leadsController.transactionIdCon.text,
                      leadsController.files ?? File(""),
                      callRecordingFile,
                      audioFilesData ?? File(""),
                    );
                    if (response.result == true) {
                      sharedPreference
                          .setRemainderDate(leadsController.remindDate);
                      audioFilesData = File("");
                      callRecordingFile = File("");
                      leadsController.files = File("");
                      leadsController.clearAll();
                      await dashboardController
                          .fetchDashboardData(dashboardController.leadSeasons);
                      leadsController.fetchIndividualLeads(widget.leadId);
                      setState(() {});
                    }
                  });
            }),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
