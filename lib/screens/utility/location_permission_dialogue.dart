import 'package:flutter/material.dart';
import 'package:in4_solution/config/enums.dart';
import 'package:in4_solution/constants/contexts.dart';
import 'package:in4_solution/constants/fonts.dart';

class LocationPermissionDialogue extends StatefulWidget {
  const LocationPermissionDialogue({super.key, required this.onTap});
  final VoidCallback onTap;
  @override
  State<LocationPermissionDialogue> createState() => _LocationPermissionDialogueState();
}

class _LocationPermissionDialogueState extends State<LocationPermissionDialogue> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return willPop();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              decoration: BoxDecoration(
                  border: Border.all(color: targetDetailColor.brand, width: 1),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8)),
              width: context.widthFull() - 32,
              child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('assets/location_permission.png', height: 250),

                      textCustom(
                          ' Hi there! To provide you with accurate check-in and check-out information, we need your permission to access your location. This will help us determine your current whereabouts and offer you relevant services.',
                          align: TextAlign.center,
                          size: 12),
                      // hgap4px(),
                      const SizedBox(height: 16),
                      TextButton.icon(
                        onPressed: widget.onTap,
                        icon: const Icon(Icons.my_location, size: 20),
                        label: textCustom('Continue'),
                      )
                    ],
                  ))),
        ],
      ),
    );
  }

  willPop() {
    // toastMsg("Turn on Location to access Nearest Service");
    return Future.value(false);
  }
}
