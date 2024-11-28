import 'package:flutter/material.dart';
import 'package:in4_solution/config/enums.dart';
import 'package:in4_solution/constants/buttons.dart';
import 'package:in4_solution/constants/loaders.dart';
import 'package:in4_solution/constants/topnavbar.dart';
import 'package:in4_solution/providers/employee_provider.dart';
import 'package:in4_solution/screens/main_screen/employee_report/Mapview_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EmployeeViewScreen extends StatefulWidget {
  const EmployeeViewScreen({super.key, required this.id});

  final String id;

  @override
  State<EmployeeViewScreen> createState() => _EmployeeViewScreenState();
}

class _EmployeeViewScreenState extends State<EmployeeViewScreen> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    var params = {
      'finger_id': widget.id,
      'date': DateFormat('yyyy-MM-dd')
          .format(
            Provider.of<EmployeeProvider>(context, listen: false).fromDate,
          )
          .toString(),
    };
    await Provider.of<EmployeeProvider>(context, listen: false).getEmployeeDetail(context, params);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<EmployeeProvider>(builder: (_, provider, __) {
      return Scaffold(
          body: SafeArea(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: provider.employeeListLoading
                      ? Center(child: loader50())
                      : Container(
                          height: size.height,
                          width: size.width,
                          color: Colors.white,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            physics: const ClampingScrollPhysics(),
                            child: Column(
                              children: [
                                topnavBar("Employee Detail", () {
                                  Navigator.pop(context);
                                  // Provider.of<EmployeeProvider>(context, listen: false).clearAttendanceList();
                                }, size),
                                EmployeeDetailCard(provider.employeeDetail)
                              ],
                            ),
                          )))));
    });
  }

  Widget EmployeeDetailCard(data) => Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoText(label: "Employee Name", value: "${data['employee_name'] ?? '-'}"),
            InfoText(label: "Employee ID", value: "${widget.id ?? '-'}"),
            InfoText(label: "Department", value: "${data['department'] ?? '-'}"),
            InfoText(label: "Designation", value: "${data['designation'] ?? '-'}"),
            InfoText(label: "Address", value: "${data['address'] ?? '-'}"),
            Divider(
              height: 40,
              color: Colors.grey.shade200,
            ),
            Text(
              "Punch In Data",
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...((data['data'] ?? []) as List).map((punchData) => PunchTimeEntry(punchData: punchData)).toList(),
          ],
        ),
      );
}

class InfoText extends StatelessWidget {
  final String label;
  final String value;

  const InfoText({Key? key, required this.label, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
        Text(
          value,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

class PunchTimeEntry extends StatelessWidget {
  final Map<String, dynamic> punchData;

  const PunchTimeEntry({Key? key, required this.punchData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(punchData['date_time']);
    final formattedTime = DateFormat("hh:mm a").format(dateTime);
    final formattedDate = DateFormat("dd MMM, yyyy").format(dateTime);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 0,
      child: ListTile(
        titleAlignment: ListTileTitleAlignment.top,
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text(
            "Remarks",
            style: TextStyle(fontSize: 11),
          ),
          Text("${punchData['remark']}"),
        ]),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Date",
              style: TextStyle(fontSize: 11),
            ),
            Text(
              "$formattedDate at $formattedTime",
              style: const TextStyle(color: Colors.black54),
            ),
          ],
        ),
        leading: const Icon(Icons.location_on, color: Colors.redAccent),
        trailing: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MapviewScreen(
                    latitude: double.tryParse(punchData['latitude'] ?? '0.0') ?? 0.0,
                    longitude: double.tryParse(punchData['longitude'] ?? '0.0') ?? 0.0,
                  ),
                ),
              );
            },
            icon: Icon(
              Icons.remove_red_eye,
              color: targetDetailColor.brand.withOpacity(0.8),
            )),
      ),
    );
  }
}
