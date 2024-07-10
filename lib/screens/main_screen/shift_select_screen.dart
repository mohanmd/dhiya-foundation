import 'package:flutter/material.dart';
import 'package:in4_solution/config/enums.dart';
import 'package:in4_solution/constants/buttons.dart';
import 'package:in4_solution/constants/contexts.dart';
import 'package:in4_solution/constants/fonts.dart';
import 'package:in4_solution/constants/notifications.dart';
import 'package:in4_solution/providers/all_providers.dart';
import 'package:in4_solution/screens/utility/drop_down.dart';

class ShiftSelectScreen extends StatefulWidget {
  const ShiftSelectScreen({super.key});

  @override
  State<ShiftSelectScreen> createState() => _ShiftSelectScreenState();
}

class _ShiftSelectScreenState extends State<ShiftSelectScreen> {
  Map? selectedShift;
  List shifts = [
    {'id': '1', 'shift': 'Day Shift'},
    {'id': '2', 'shift': 'Night Shift'}
  ];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 4),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const SizedBox(width: 24),
          textTittle("Check In", targetDetailColor.brand),
          InkWell(onTap: () => Navigator.pop(context), child: Icon(Icons.cancel_outlined, color: targetDetailColor.brand))
        ]),
        const SizedBox(height: 12),
        textCustom('Work shift', size: 12, weight: FontWeight.w400),
        const SizedBox(height: 6),
        // textFieldCommon(contShift, 'Select work shift', Tex, obscure)
        dropdownButtonCustom(
            selectedShift, shifts, 'shift', label: 'Select your work shift', (p0) => setState(() => selectedShift = p0 as Map)),
        const SizedBox(height: 12),
        buttonPrimary(context.widthFull(), 0, 'Confirm', () => hitAPi()),
      ]),
    );
  }

  hitAPi() {
    if (selectedShift == null) {
      return notif('Failed', 'Kinldy select your work shift');
    }
    Navigator.pop(context);
    provdLocation.selectedShift(selectedShift?['id']);
    provdLocation.checkFunction(true);
  }
}
