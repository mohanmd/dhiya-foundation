import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in4_solution/config/enums.dart';
import 'package:in4_solution/constants/buttons.dart';
import 'package:in4_solution/constants/fonts.dart';
import 'package:in4_solution/constants/keys.dart';
import 'package:in4_solution/constants/loaders.dart';
import 'package:in4_solution/constants/text_field.dart';
import 'package:in4_solution/constants/topnavbar.dart';
import 'package:in4_solution/providers/all_providers.dart';
import 'package:in4_solution/providers/permission_provider.dart';
import 'package:in4_solution/screens/main_screen/leave/leave_application_admin.dart';
import 'package:in4_solution/screens/main_screen/leave/leave_reports.dart';
import 'package:in4_solution/screens/utility/empty_list.dart';
import 'package:in4_solution/screens/utility/shimmer.dart';
import 'package:provider/provider.dart';

class PermissionApplicationAdmin extends StatefulWidget {
  const PermissionApplicationAdmin({super.key});

  @override
  State<PermissionApplicationAdmin> createState() =>
      _PermissionApplicationAdminState();
}

class _PermissionApplicationAdminState
    extends State<PermissionApplicationAdmin> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      provdPermission.adminPermissionIndex();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Consumer<PermissionProvider>(builder: (_, provider, __) {
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
                // shrinkWrap: true,
                children: [
                  topnavBar("Permission Applications", () {
                    Navigator.of(context).pop();
                    // Provider.of<LayoutProvider>(context, listen: false)
                    //     .changeNav(0);
                  }, size),
                  const SizedBox(height: 12),
                  provider.isGetting
                      ? const ShimmerList()
                      : provider.adminPermissionList.isNotEmpty
                          ? Expanded(
                              // height: size.height - 155,
                              child: ListView.builder(
                                itemCount: provider.adminPermissionList.length,
                                scrollDirection: Axis.vertical,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  var status = provider
                                      .adminPermissionList[index]['status'];
                                  return provider.adminPermissionList.isNotEmpty
                                      ?
                                      // targetDetail.functions.any(
                                      //             (element) => element == 17) &&
                                      //         provdAuth.userData['role_id'] < 4
                                      //     ?
                                      permissionContainer(
                                          provider.adminPermissionList[index],
                                          status.toString(),
                                          index)
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

  Widget permissionContainer(Map data, String stat, int index1) {
    logger.e(data);
    return InkWell(
      onTap: () => setState(() {
        Map<String, dynamic> permission = {
          "leave_permission_id": data["leave_permission_id"].toString(),
          "employee_id": provdAuth.userData["employee_id"].toString()
        };

        Get.to(const PermissionApplicationDetailsScreen());
        provdPermission.adminPermissionView(permission);
      }),
      child: Column(
        children: [
          Container(
              // padding: const EdgeInsets.symmetric(horizontal: 12),
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 12),
              // height: 62,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  border: Border.all(color: targetDetailColor.brand, width: 1)),
              child: Column(
                children: [
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
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${data['leave_permission_date']}".toUpperCase(),
                        style: styleReport(size: 12),
                      ),
                      Text(getStatus(data['status'].toString()).toUpperCase(),
                          style: styleReport(
                              size: 12,
                              color: getColor(data['status'].toString()))),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "${data['from_time']} to ${data['to_time']}",
                        style: styleReport(size: 10, color: Colors.grey),
                      ),
                    ],
                  )
                ],
              )),
          ListView(
            shrinkWrap: true,
            children: const [],
          )
        ],
      ),
    );
  }
}

class PermissionApplicationDetailsScreen extends StatefulWidget {
  const PermissionApplicationDetailsScreen({super.key});

  @override
  State<PermissionApplicationDetailsScreen> createState() =>
      _PermissionApplicationDetailsScreenState();
}

class _PermissionApplicationDetailsScreenState
    extends State<PermissionApplicationDetailsScreen> {
  TextEditingController remarkCont = TextEditingController();

  @override
  void dispose() {
    remarkCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<PermissionProvider>(
        builder: (context, permission, child) {
          Map data = permission.adminPermissionDeatils;
          Map employee = data["employee"] ?? {};
          return SafeArea(
            child: ListView(children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: topnavBar("Permission Application", () {
                  Navigator.of(context).pop();
                  // Provider.of<LayoutProvider>(context, listen: false)
                  //.changeNav(0);
                }, size),
              ),
              permission.isGetting
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
                                "${employee["first_name"]}${employee["last_name"] ?? ""}"),
                        const SizedBox(height: 8),
                        ReportTile(
                            text1: 'Emp Code',
                            text2: "${employee['emp_code']}"),
                        const SizedBox(height: 8),
                        ReportTile(
                            text1: 'Applied On',
                            text2: data['leave_permission_date'] ?? 'N/A'),
                        const SizedBox(height: 8),
                        ReportTile(
                            text1: 'From Date',
                            text2: data['from_time'] ?? 'N/A'),
                        const SizedBox(height: 8),
                        ReportTile(
                            text1: 'To Date', text2: data['to_time'] ?? 'N/A'),
                        const SizedBox(height: 8),
                        ReportTile(
                            text1: 'Phone', text2: "${employee['phone']}"),
                        const SizedBox(height: 8),
                        ReportTile(
                            text1: 'Purpose',
                            text2:
                                '${data['leave_permission_purpose'] ?? 'N/A'}'),
                        const SizedBox(height: 8),
                        ReportTile(
                            text1: 'Leave Status',
                            text2: getStatus(data['status'].toString())),
                        const SizedBox(height: 8),
                        ReportTile(
                            text1: 'Remarks',
                            text2: '${data['head_remarks'] ?? 'N/A'}'),
                        const SizedBox(height: 8),
                        if (data["status"] == 1) ...[
                          textField(remarkCont, "remarks", TextInputType.name),
                          const SizedBox(height: 16),
                          permission.isloading
                              ? loader35()
                              : Row(children: [
                                  Expanded(
                                    child: buttonPrimary(100, 20, "Reject", () {
                                      hitApi(data, "3");
                                    }, color: Colors.orange),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child:
                                        buttonPrimary(100, 20, "Approve", () {
                                      hitApi(data, "2");
                                    }, color: Colors.green),
                                  )
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
    FocusScope.of(context).unfocus();
    Map<String, String> params = {
      "leave_permission_id": data['leave_permission_id'].toString(),
      "employee_id": provdAuth.userData["employee_id"].toString(),
      "status": id,
      "remarks": remarkCont.text,
    };

    provdPermission.adminPermissionUpdate(params);
  }
}

class ReportTile extends StatelessWidget {
  const ReportTile({super.key, required this.text1, required this.text2});

  final String text1, text2;

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
          width: 104,
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
