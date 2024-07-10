import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in4_solution/config/enums.dart';
import 'package:in4_solution/constants/contexts.dart';

TextStyle styleMessage = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: targetDetailColor.light,
    letterSpacing: 0.25);

notif(String head, String desc) => Get.snackbar(head, desc,
    margin: const EdgeInsets.only(left: 8, top: 8, right: 8),
    maxWidth: Get.context!.widthFull(),
    duration: const Duration(seconds: 2),
    dismissDirection: DismissDirection.horizontal,
    animationDuration: const Duration(milliseconds: 600));

// notif('Error',(String head, String desc) {
//   return showOverlayNotification((context) {
//     return MessageNotificationError(
//       desc: desc,
//       head: head,
//     );
//   }, duration: const Duration(seconds: 3));
// }

// notif('Success',String desc) {
//   return showOverlayNotification((context) {
//     return MessageNotificationSuccess(
//       desc: desc,
//     );
//   }, duration: const Duration(seconds: 2));
// }

// notif('Failed',String desc) {
//   return showOverlayNotification((context) {
//     return MessageNotificationFail(
//       desc: desc,
//     );
//   }, duration: const Duration(seconds: 2));
// }

class MessageNotificationError extends StatelessWidget {
  final String head;
  final String desc;
  const MessageNotificationError(
      {Key? key, required this.head, required this.desc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      SafeArea(
        child: GestureDetector(
          child: Card(
            color: targetDetailColor.danger,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            margin: const EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox.fromSize(
                        size: const Size(40, 40),
                        child: ClipOval(
                            child: Icon(Icons.warning,
                                size: 20, color: targetDetailColor.light))),
                    const SizedBox(width: 16),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(head, style: styleMessage),
                          const SizedBox(height: 4),
                          SizedBox(
                              width: context.widthFull() - 96,
                              child: Text(desc, style: styleMessage))
                        ]),
                  ]),
            ),
          ),
        ),
      ),
    ]);
  }
}

class MessageNotificationFail extends StatelessWidget {
  final String desc;
  const MessageNotificationFail({Key? key, required this.desc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Card(
              color: targetDetailColor.warning,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              margin: const EdgeInsets.all(8),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox.fromSize(
                        size: const Size(40, 40),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: CircleAvatar(
                              backgroundColor: targetDetailColor.light,
                              child: Icon(Icons.priority_high,
                                  size: 16, color: targetDetailColor.warning)),
                        )),
                    const SizedBox(width: 16),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 96,
                      child: Text(
                        desc,
                        maxLines: 2,
                        style: styleMessage,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MessageNotificationSuccess extends StatelessWidget {
  final String desc;
  const MessageNotificationSuccess({Key? key, required this.desc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Card(
              color: targetDetailColor.success,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              margin: const EdgeInsets.all(8),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox.fromSize(
                        size: const Size(40, 40),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: CircleAvatar(
                              backgroundColor: targetDetailColor.light,
                              child: Icon(Icons.done,
                                  size: 16, color: targetDetailColor.success)),
                        )),
                    const SizedBox(width: 16),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 96,
                      child: Text(
                        desc,
                        maxLines: 2,
                        style: styleMessage,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
