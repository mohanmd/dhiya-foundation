import 'package:flutter/material.dart';
import 'package:in4_solution/config/enums.dart';
import 'package:in4_solution/constants/buttons.dart';
import 'package:in4_solution/constants/contexts.dart';
import 'package:in4_solution/constants/loaders.dart';
import 'package:in4_solution/screens/main_screen/leave/leave_cancelation_dialog.dart';
import 'package:in4_solution/screens/utility/dialogue.dart';
import 'package:provider/provider.dart';
import '/../constants/fonts.dart';
import '/../screens/utility/empty_list.dart';
import '../../../constants/keys.dart';
import '../../../constants/topnavbar.dart';
import '../../../providers/leave_provider.dart';
import '../../utility/shimmer.dart';

class LeaveReport extends StatefulWidget {
  const LeaveReport({Key? key}) : super(key: key);

  @override
  State<LeaveReport> createState() => _LeaveReportState();
}

class _LeaveReportState extends State<LeaveReport> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<LeaveProvider>(context, listen: false)
          .leaveApplications(context);
    });
    super.initState();
  }

  int selectedIndex = 0;
  TextEditingController remarkCont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<LeaveProvider>(builder: (_, provider, __) {
      return Scaffold(
        key: leaveReportKey,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Container(
              height: size.height,
              width: size.width,
              color: Colors.white,
              child: Column(
                // shrinkWrap: true,
                children: [
                  topnavBar("Leave Report", () {
                    Navigator.of(context).pop();
                    // Provider.of<LayoutProvider>(context, listen: false)
                    //     .changeNav(0);
                  }, size),
                  const SizedBox(height: 12),
                  provider.leaveLoading
                      ? const ShimmerList()
                      : provider.leaveApplicationList.isNotEmpty
                          ? Expanded(
                              // height: size.height - 155,
                              child: ListView.builder(
                                itemCount: provider.leaveApplicationList.length,
                                scrollDirection: Axis.vertical,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  var status = provider
                                      .leaveApplicationList[index]
                                          ["manager_status"
                                          // ? 'functionalhead_status'
                                          ]
                                      .toString();
                                  return provider
                                          .leaveApplicationList.isNotEmpty
                                      ?
                                      // targetDetail.functions.any(
                                      //             (element) => element == 17) &&
                                      //         provdAuth.userData['role_id'] < 4
                                      //     ? leaveContainerTesamm(
                                      //         provider
                                      //             .leaveApplicationList[index],
                                      //         status,
                                      //         index)
                                      //     :
                                      leaveContainer(
                                          provider.leaveApplicationList[index],
                                          status)
                                      : const Center(
                                          child: Text("No Data Found"));
                                },
                              ),
                            )
                          : const Expanded(
                              child: Column(children: [
                                Spacer(),
                                EmptyList(),
                                Spacer(flex: 2),
                              ]),
                            ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget leaveContainer(Map data, String stat) {
    Color color = stat == '3' || stat == '4'
        ? targetDetailColor.danger
        : stat == "2"
            ? targetDetailColor.success
            : targetDetailColor.info;

    return InkWell(
      onTap: () =>
          commonDialog(context, LeaveReportData(data: data), isHadborder: true),
      child: Container(
        // padding: const EdgeInsets.symmetric(horizontal: 12),
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 8),
        // height: 62,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            border: Border.all(color: targetDetailColor.brand, width: 1)),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("${data['leave_type']['leave_type_name']}".toUpperCase(),
                      style: styleReport()),
                  const SizedBox(height: 8),
                  Text(
                      "${data['application_from_date']} - ${data['application_to_date']}",
                      style: styleReportDate),
                ],
              ),
              buttonPrimary1("View Status", () {
                commonDialog(context, LeaveReportData(data: data),
                    isHadborder: true);
              }, height: 36.0, size: 12.0)
              // Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: <Widget>[
              //       Text(getStatus(stat),
              //           style: GoogleFonts.inter(
              //               fontSize: 16,
              //               fontWeight: FontWeight.bold,
              //               color: color)),
              //     ]),
            ]),
      ),
    );
  }
}

String getStatus(String stat) {
  String status = stat == '3'
      ? 'Rejected'
      : stat == '2'
          ? 'Approved'
          : stat == '4'
              ? 'Passed'
              : stat == '5'
                  ? 'Cancelled'
                  : 'Pending';
  return status;
}

class LeaveBalanceReport extends StatelessWidget {
  const LeaveBalanceReport({super.key, required this.data});
  final Map data;
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 24),
          textTittle("Balance Leave", targetDetailColor.brand),
          InkWell(
              onTap: () => Navigator.pop(context),
              child:
                  Icon(Icons.cancel_outlined, color: targetDetailColor.brand))
        ],
      ),
      const SizedBox(height: 12),
      const SizedBox(height: 8),
    ]);
  }
}

class LeaveReportData extends StatelessWidget {
  const LeaveReportData({super.key, required this.data});
  final Map data;
  @override
  Widget build(BuildContext context) {
    logger.f(data['status']);
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 24),
          textTittle("Leave Report", targetDetailColor.brand),
          InkWell(
              onTap: () => Navigator.pop(context),
              child:
                  Icon(Icons.cancel_outlined, color: targetDetailColor.brand))
        ],
      ),
      const SizedBox(height: 12),
      ReportTile(
          text1: 'Leave Type',
          text2: "${data['leave_type']['leave_type_name'] ?? 'N/A'}"),
      const SizedBox(height: 8),
      ReportTile(
          text1: 'HOD Status', text2: getStatus('${data['status'] ?? ''}')),
      data['status'] == "3"
          ? const SizedBox.shrink()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                ReportTile(
                    text1: 'Functional Status',
                    // text2: getStatus('${data['functionalhead_status'] ?? ''}')
                    text2:
                        getStatus('${data['functional_head_status'] ?? ''}')),
              ],
            ),
      const SizedBox(height: 8),
      ReportTile(
          text1: 'Leave From', text2: data['application_from_date'] ?? 'N/A'),
      const SizedBox(height: 8),
      ReportTile(
          text1: 'Leave To', text2: data['application_to_date'] ?? 'N/A'),
      const SizedBox(height: 8),
      ReportTile(
          text1: 'No of Days', text2: '${data['number_of_day'] ?? 'N/A'}'),
      const SizedBox(height: 8),
      ReportTile(text1: 'Purpose', text2: '${data['purpose'] ?? 'N/A'}'),
      const SizedBox(height: 8),
      if (data['cancel'] ?? false)
        Consumer<LeaveProvider>(
            builder: (_, value, __) => value.isloading
                ? loader35()
                : buttonPrimary(context.widthFull(), 0, 'Cancel', () {
                    commonDialog(context, LeaveCancelationScreen(data: data));
                  }))
      else ...[
        ReportTile(text1: 'Remarks', text2: '${data['remarks'] ?? 'N/A'}'),
        const SizedBox(height: 8)
      ],
    ]);
  }
}

class ReportTile extends StatelessWidget {
  const ReportTile({super.key, required this.text1, required this.text2});

  final String text1, text2;

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
          width: context.widthHalf() - 40,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: Text(text1,
                        style: styleReport(
                            weight: FontWeight.w400, color: Colors.grey))),
                Text(':', style: styleReport(weight: FontWeight.w400)),
              ])),
      const SizedBox(width: 8),
      Expanded(child: Text(text2, style: styleReport())),
    ]);
  }
}
