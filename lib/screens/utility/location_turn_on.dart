import 'package:flutter/material.dart';
import 'package:in4_solution/config/enums.dart';
import 'package:in4_solution/constants/contexts.dart';
import 'package:in4_solution/constants/fonts.dart';

class LocationTurnOnDialogue extends StatefulWidget {
  const LocationTurnOnDialogue({super.key, required this.onTap});
  final VoidCallback onTap;
  @override
  State<LocationTurnOnDialogue> createState() => _LocationTurnOnDialogueState();
}

class _LocationTurnOnDialogueState extends State<LocationTurnOnDialogue> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 200,
        decoration: BoxDecoration(
            border: Border.all(color: targetDetailColor.brand, width: 1),
            color: Colors.white,
            borderRadius: BorderRadius.circular(8)),
        width: context.widthFull() - 80,
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.location_off, color: targetDetailColor.danger),
                textCustom('Device location not enabled'),
                textCustom('Kindly enable device location to check In/Out',
                    align: TextAlign.center),
                // hgap4px(),

                TextButton.icon(
                  onPressed: widget.onTap,
                  icon: const Icon(Icons.my_location, size: 20),
                  label: textCustom('Enable device location'),
                )
              ],
            )));
  }
}
