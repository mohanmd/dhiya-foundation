import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in4_solution/config/enums.dart';
import 'package:in4_solution/constants/buttons.dart';
import 'package:in4_solution/constants/contexts.dart';
import 'package:in4_solution/constants/fonts.dart';
import 'package:in4_solution/constants/keys.dart';
import 'package:in4_solution/constants/loaders.dart';
import 'package:in4_solution/constants/text_field.dart';
import 'package:in4_solution/constants/topnavbar.dart';
import 'package:in4_solution/providers/all_providers.dart';
import 'package:in4_solution/providers/leave_provider.dart';
import 'package:in4_solution/screens/main_screen/leave/leave_reports.dart';
import 'package:in4_solution/screens/utility/empty_list.dart';
import 'package:in4_solution/screens/utility/shimmer.dart';
import 'package:provider/provider.dart';

class LeaveApplicationAdmin extends StatefulWidget {
  const LeaveApplicationAdmin({super.key});

  @override
  State<LeaveApplicationAdmin> createState() => _LeaveApplicationAdminState();
}

class _LeaveApplicationAdminState extends State<LeaveApplicationAdmin> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      provdLeave.adminLeaveApplication(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<LeaveProvider>(builder: (_, provider, __) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Container(
              height: size.height,
              width: size.width,
              color: Colors.white,
              child: Column(
                children: [
                  topnavBar("Leave Applications", () {
                    Navigator.of(context).pop();
                  }, size),
                  const SizedBox(height: 12),
                  provider.leaveLoading
                      ? const ShimmerList()
                      : provider.adminApplicationList.isNotEmpty
                          ? Expanded(
                              child: ListView.builder(
                                itemCount: provider.adminApplicationList.length,
                                scrollDirection: Axis.vertical,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  var status = provider
                                      .adminApplicationList[index]['status'];
                                  return leaveContainer(
                                      provider.adminApplicationList[index],
                                      status,
                                      index);
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

  Widget leaveContainer(Map data, String stat, int index1) {
    bool isFunctional = '${provdAuth.userData['employee_id']}' ==
        '${data['employee']['functional_head_id']}';

    String functionalStatus = '${data['functional_head_status']}';
    String hodStatus = '${data['status']}';
    String status = isFunctional
        ? hodStatus == '3'
            ? hodStatus
            : functionalStatus
        : hodStatus;
    return InkWell(
      onTap: () => setState(() {
        Map<String, dynamic> balanceLeave = {
          "leave_application_id": data["leave_application_id"].toString(),
          "employee_id": data["employee_id"].toString()
        };
        Get.to(LeaveApplicationDetails(data: data));
        provdLeave.adminBalanceLeave(balanceLeave);
      }),
      child: Column(
        children: [
          Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  border: Border.all(color: targetDetailColor.brand, width: 1)),
              child: Column(children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${data['employee']["first_name"]}${data['employee']["last_name"] ?? ""}"
                            .toUpperCase(),
                        style: styleReport(size: 12),
                      ),
                      Text("${data['employee']['emp_code']}".toUpperCase(),
                          style: styleReport(size: 12))
                    ]),
                const SizedBox(height: 8),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${data['leave_type']['leave_type_name']}"
                            .toUpperCase(),
                        style: styleReport(size: 12),
                      ),
                      Text(getStatus(status).toUpperCase(),
                          style:
                              styleReport(size: 12, color: getColor(status))),
                    ]),
                const SizedBox(height: 6),
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Text(
                    "${data['application_from_date']} to ${data['application_to_date']}",
                    style: styleReport(size: 10, color: Colors.grey),
                  ),
                ])
              ])

              // Column(
              //   children: [
              //     Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: <Widget>[
              //           Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               textCustom("Type",
              //                   color: targetDetailColor.primaryDark),
              //               const SizedBox(height: 4),
              //               Text(
              //                 "${data['leave_type']['leave_type_name']}"
              //                     .toUpperCase(),
              //                 style: styleReport(size: 12),
              //               ),
              //             ],
              //           ),
              //           Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               textCustom("Status      ",
              //                   color: targetDetailColor.primaryDark),
              //               const SizedBox(height: 4),
              //               Text("${data['status']}".toUpperCase(),
              //                   style: styleReport(size: 12)),
              //             ],
              //           ),
              //         ]),
              //     const SizedBox(height: 10),
              //     Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: <Widget>[
              //           Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               textCustom("Emp Code",
              //                   color: targetDetailColor.primaryDark),
              //               const SizedBox(height: 4),
              //               Text("${data['employee']['emp_code']}".toUpperCase(),
              //                   style: styleReport(size: 12)),
              //             ],
              //           ),
              //           Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               textCustom("Date",
              //                   color: targetDetailColor.primaryDark),
              //               const SizedBox(height: 4),
              //               Text(
              //                   "${data['application_from_date']} to ${data['application_to_date']}",
              //                   style: styleReport(size: 12)),
              //             ],
              //           ),
              //         ]),
              //   ],
              // ),
              ),
          ListView(
            shrinkWrap: true,
            children: const [],
          )
        ],
      ),
    );
  }
}

Color getColor(String stat) {
  Color color = stat == '3' || stat == '5'
      ? targetDetailColor.danger
      : stat == "2"
          ? targetDetailColor.success
          : stat == "4"
              ? targetDetailColor.warning
              : targetDetailColor.info;
  return color;
}

class LeaveApplicationDetails extends StatefulWidget {
  const LeaveApplicationDetails({super.key, required this.data});
  final Map data;

  @override
  State<LeaveApplicationDetails> createState() =>
      _LeaveApplicationDetailsState();
}

class _LeaveApplicationDetailsState extends State<LeaveApplicationDetails> {
  TextEditingController remarkCont = TextEditingController();

  @override
  void dispose() {
    remarkCont.dispose();
    super.dispose();
  }

  // List leaveList = [
  //   {'casual_leave': 'Casual Leave'},
  //   {'privilege_leave': 'Casual Leave'},
  //   {'sick_leave': 'Casual Leave'},
  //   {'OD': 'Casual Leave'},
  //   {'paternity_leave': 'Paternity Leave'},
  //   {'paternity_leave': 'Paternity Leave'},
  // ];
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<LeaveProvider>(
        builder: (context, balance, child) {
          Map balanceData =
              balance.leaveApplicationDetails['leave_transactions'] ?? {};
          Map data = balance.leaveLoading
              ? {}
              : balance.leaveApplicationDetails["leave_application"] ?? {};
          Map employee = data["employee"] ?? {};
          double usedCount = double.parse('${balanceData['utilized'] ?? 0}');
          double balanceCount = double.parse('${balanceData['balance'] ?? 0}');
          double totalCount = usedCount + balanceCount;
          bool isFunctional = '${provdAuth.userData['employee_id']}' ==
              '${employee['functional_head_id']}';

          String functionalStatus = '${data['functional_head_status']}';
          String status = '${data['status']}';
          logger.e(isFunctional);
          return SafeArea(
            child: ListView(children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: topnavBar("Leave Application Details", () {
                  Navigator.of(context).pop();
                  // Provider.of<LayoutProvider>(context, listen: false)
                  //.changeNav(0);
                }, size),
              ),
              balance.leaveLoading
                  ? const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: ShimmerList(),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(children: [
                        ReportTile(
                            text1: 'Name',
                            text2:
                                "${employee["first_name"] ?? '-'}${employee["last_name"] ?? ""}"),
                        const SizedBox(height: 8),
                        ReportTile(
                            text1: 'Emp Code',
                            text2: "${employee['emp_code'] ?? 'N/A'}"),
                        const SizedBox(height: 8),
                        ReportTile(
                            text1: 'Leave Type',
                            text2: Map.from(data['leave_type'] ?? {}).isEmpty
                                ? 'N/A'
                                : "${data['leave_type']['leave_type_name'] ?? 'N/A'}"),
                        const SizedBox(height: 8),
                        ReportTile(
                            text1: 'Applied On',
                            text2: data['application_date'] ?? 'N/A'),
                        const SizedBox(height: 8),
                        ReportTile(
                            text1: 'From Date',
                            text2: data['application_from_date'] ?? 'N/A'),
                        const SizedBox(height: 8),
                        ReportTile(
                            text1: 'To Date',
                            text2: data['application_to_date'] ?? 'N/A'),
                        const SizedBox(height: 8),
                        ReportTile(
                            text1: 'Days',
                            text2: data['number_of_day'] ?? 'N/A'),
                        const SizedBox(height: 8),
                        // ReportTile(
                        //     text1: 'Destination',
                        //     text2: "${data['employee']["first_name"]}" ?? 'N/A'),
                        // const SizedBox(height: 8),
                        // ReportTile(
                        //     text1: 'Department',
                        //     text2: "${data['employee']['emp_code']}" ?? 'N/A'),
                        // const SizedBox(height: 8),
                        // ReportTile(
                        //     text1: 'Phone',
                        //     text2: "${data['employee']['emp_code']}" ?? 'N/A'),
                        // const SizedBox(height: 8),
                        // ReportTile(
                        //     text1: 'Leave From',
                        //     text2: data['application_from_date'] ?? 'N/A'),
                        // const SizedBox(height: 8),
                        // ReportTile(
                        //     text1: 'Leave To',
                        //     text2: data['application_to_date'] ?? 'N/A'),
                        // const SizedBox(height: 8),
                        ReportTile(
                            text1: 'No of Days',
                            text2: '${data['number_of_day'] ?? 'N/A'}'),
                        const SizedBox(height: 8),
                        ReportTile(
                            text1: 'Purpose',
                            text2: '${data['purpose'] ?? 'N/A'}'),
                        data["remarks"] == null
                            ? const SizedBox.shrink()
                            : Column(
                                children: [
                                  const SizedBox(height: 8),
                                  ReportTile(
                                      text1: 'HOD Remarks',
                                      text2: '${data['remarks'] ?? 'N/A'}'),
                                ],
                              ),
                        data["functional_head_remark"] == null
                            ? const SizedBox.shrink()
                            : Column(
                                children: [
                                  const SizedBox(height: 8),
                                  ReportTile(
                                      text1: 'Functional Remarks',
                                      text2:
                                          '${data['functional_head_remark'] ?? 'N/A'}'),
                                ],
                              ),
                        const SizedBox(height: 8),
                        if (status == '3' || status == '5') ...[
                          ReportTile(text1: 'Status', text2: getStatus(status)),
                          const SizedBox(height: 8),
                        ] else ...[
                          ReportTile(
                              text1: 'HOD Status', text2: getStatus(status)),
                          const SizedBox(height: 8),
                          ReportTile(
                              text1: 'Functional Status',
                              text2: getStatus(functionalStatus))
                        ],
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.only(
                              right: 12, left: 12, top: 12),
                          // height: 62,
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                              border: Border.all(
                                  color: targetDetailColor.brand, width: 1)),
                          child: Column(
                            children: [
                              Text("Balance Leave",
                                  style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Leave Type",
                                            style: styleReport(
                                                weight: FontWeight.w400,
                                                color: Colors.grey,
                                                size: 12)),
                                        const SizedBox(height: 12),
                                        Text('CL',
                                            style: styleReport(
                                                weight: FontWeight.w400,
                                                color: Colors.black,
                                                size: 12)),
                                        const SizedBox(height: 8)
                                      ]),
                                  Column(children: [
                                    Text("Total",
                                        style: styleReport(
                                            weight: FontWeight.w400,
                                            color: Colors.grey,
                                            size: 12)),
                                    const SizedBox(height: 12),
                                    Text('$totalCount',
                                        style: styleReport(
                                            weight: FontWeight.w400,
                                            color: Colors.black,
                                            size: 12)),
                                    const SizedBox(height: 8)
                                  ]),
                                  Column(children: [
                                    Text("Used",
                                        style: styleReport(
                                            weight: FontWeight.w400,
                                            color: Colors.grey,
                                            size: 12)),
                                    const SizedBox(height: 12),
                                    Text('$usedCount',
                                        style: styleReport(
                                            weight: FontWeight.w400,
                                            color: Colors.black,
                                            size: 12)),
                                    const SizedBox(height: 8)
                                  ]),
                                  Column(children: [
                                    Text("Available",
                                        style: styleReport(
                                            weight: FontWeight.w400,
                                            color: Colors.grey,
                                            size: 12)),
                                    const SizedBox(height: 12),
                                    Text("$balanceCount",
                                        style: styleReport(
                                            weight: FontWeight.w400,
                                            color: Colors.black,
                                            size: 12)),
                                    const SizedBox(height: 8)
                                  ]),
                                ],
                              ),
                              const SizedBox(height: 12),
                              // Column(
                              //   children: [
                              //     Row(
                              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //       children: [
                              //         Text("Casual Leave",
                              //             style: styleReport(
                              //                 weight: FontWeight.w400,
                              //                 color: Colors.black,
                              //                 size: 12)),
                              //         Text(
                              //             "${balance.balanceDetails["used"]["casual_leave"]}",
                              //             style: styleReport(
                              //                 weight: FontWeight.w400,
                              //                 color: Colors.black,
                              //                 size: 12)),
                              //         Text(
                              //             "${balance.balanceDetails["balance"]["casual_leave"]}",
                              //             style: styleReport(
                              //                 weight: FontWeight.w400,
                              //                 color: Colors.black,
                              //                 size: 12)),
                              //       ],
                              //     ),
                              //     const SizedBox(height: 8)
                              //   ],
                              // ),
                            ],
                          ),
                        ),
                        if (!isFunctional && status == '1') ...[
                          textField(remarkCont, "remarks", TextInputType.name),
                          const SizedBox(height: 16),
                          balance.isloading
                              ? loader35()
                              : Row(children: [
                                  Expanded(
                                      child:
                                          buttonPrimary(100, 20, "Reject", () {
                                    hitApi(data, "3");
                                  }, color: targetDetailColor.danger)),
                                  const SizedBox(width: 12),
                                  Expanded(
                                      child:
                                          buttonPrimary(100, 20, "Approve", () {
                                    hitApi(data, "2");
                                  }, color: targetDetailColor.success)),
                                  const SizedBox(width: 12),
                                  Expanded(
                                      child: buttonPrimary(100, 20, "Pass", () {
                                    hitApi(data, "4");
                                  }, color: targetDetailColor.warning))
                                ])
                        ],
                        if ((isFunctional && functionalStatus == '1') &&
                            status != '3' &&
                            status != '5') ...[
                          textField(remarkCont, "remarks", TextInputType.name),
                          const SizedBox(height: 16),
                          balance.isloading
                              ? loader35()
                              : Row(children: [
                                  Expanded(
                                      child:
                                          buttonPrimary(100, 20, "Reject", () {
                                    hitApi(data, "3");
                                  }, color: Colors.orange)),
                                  const SizedBox(width: 12),
                                  Expanded(
                                      child:
                                          buttonPrimary(100, 20, "Approve", () {
                                    hitApi(data, "2");
                                  }, color: Colors.green)),
                                ])
                        ]
                      ]),
                    ),
            ]),
          );
        },
      ),
    );
  }

  hitApi(Map data, String id) {
    Map<String, String> params = {
      "leave_application_id": data['leave_application_id'].toString(),
      "employee_id": provdAuth.userData["employee_id"].toString(),
      "status": id,
      "remarks": remarkCont.text,
    };
    provdLeave.leaveApprovedAdmin(params);
  }
}

class ReportTile extends StatelessWidget {
  const ReportTile({super.key, required this.text1, required this.text2});

  final String text1, text2;

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
          width: context.widthHalf() - 50,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(text1,
                style:
                    styleReport(weight: FontWeight.w400, color: Colors.grey)),
            Text(':', style: styleReport(weight: FontWeight.w400)),
          ])),
      const SizedBox(width: 8),
      Expanded(child: Text(text2, style: styleReport())),
    ]);
  }
}
