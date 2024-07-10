import 'package:flutter/material.dart';
import 'package:in4_solution/config/enums.dart';
import 'package:in4_solution/constants/buttons.dart';
import 'package:in4_solution/constants/contexts.dart';
import 'package:in4_solution/constants/fonts.dart';
import 'package:in4_solution/providers/all_providers.dart';

class LeaveCancelationScreen extends StatefulWidget {
  const LeaveCancelationScreen({super.key, required this.data});
  final Map data;

  @override
  State<LeaveCancelationScreen> createState() => LeaveCancelationScreenState();
}

class LeaveCancelationScreenState extends State<LeaveCancelationScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8), color: Colors.white),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // const SizedBox(width: 24),
                textTittle("Cancel Leave", targetDetailColor.brand),
                // InkWell(
                //     onTap: () => Navigator.pop(context),
                //     child:
                //         Icon(Icons.cancel_outlined, color: targetDetailColor.brand))
              ],
            ),
            const SizedBox(height: 12),
            textCustom("Do you really want to cancel this leave?",
                color: Colors.grey),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                    child: buttonPrimary(context.widthFull(), 0, 'Discard', () {
                  Navigator.pop(context);
                })),
                const SizedBox(width: 12),
                Expanded(
                    child: buttonPrimary(context.widthFull(), 0, 'Confirm', () {
                  cancelLeave(widget.data);
                  Navigator.pop(context);
                }))
              ],
            ),
            const SizedBox(height: 8)
          ],
        ),
      ),
    ]);
  }

  void cancelLeave(data) {
    var params = {
      'employee_id': '${data['employee_id']}',
      'leave_application_id': '${data['leave_application_id']}',
    };
    provdLeave.cancelLeave(params);
  }
}
