import 'package:flutter/material.dart';
import 'package:in4_solution/config/enums.dart';

Future<void> commonBottomSheet(BuildContext context, child) {
  return showModalBottomSheet<void>(
      isScrollControlled: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
      context: context,
      builder: (BuildContext context) => child);
}

bottomSheet(BuildContext context, Widget child) =>
    showModalBottomSheet<dynamic>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        useRootNavigator: true,
        backgroundColor: Colors.transparent,
        showDragHandle: true,
        builder: (BuildContext context) {
          return BottomSheetWrap(child: child);
        });

class BottomSheetWrap extends StatefulWidget {
  const BottomSheetWrap({super.key, required this.child});
  final Widget child;
  @override
  State<BottomSheetWrap> createState() => _BottomSheetWrapState();
}

class _BottomSheetWrapState extends State<BottomSheetWrap> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
            topRight: Radius.circular(32), topLeft: Radius.circular(32)),
        child: Container(
          color: Colors.white,
          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              Container(
                height: 6,
                margin:
                    const EdgeInsets.symmetric(horizontal: 180, vertical: 16),
                decoration: BoxDecoration(
                    color: targetDetailColor.brand.withOpacity(.3),
                    borderRadius: BorderRadius.circular(8)),
              ),
              widget.child,
              const SizedBox(height: 16)
            ],
          ),
        ),
      ),
    );
  }
}
