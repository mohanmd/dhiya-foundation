import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '/../constants/fonts.dart';
import '../../config/enums.dart';
import '../../providers/auth_provider.dart';

commonDialog(BuildContext cont, Widget child, {bool isHadborder = false}) {
  return showDialog(
      barrierColor: Colors.transparent,
      context: cont,
      barrierDismissible: false,
      builder: (BuildContext context) {
        var size = MediaQuery.of(context).size;
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                        width: size.width - 24,
                        decoration:
                            isHadborder ? decorBgMutedBorder : decorBgMuted,
                        padding: const EdgeInsets.only(
                            top: 12, left: 8, right: 8, bottom: 8),
                        child: child),
                  ),
                  const SizedBox(width: 8),
                  // SizedBox(
                  //   height: 40,
                  //   child: ElevatedButton(
                  //     style: TextButton.styleFrom(
                  //         backgroundColor: targetDetailColor.brand,
                  //         elevation: 1,
                  //         shape: const RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.only(
                  //                 bottomRight: Radius.circular(12),
                  //                 bottomLeft: Radius.circular(12)))),
                  //     child: Text("Back", style: styleButton),
                  //     onPressed: () => Navigator.pop(context),
                  //   ),
                  // ),
                ],
              )),
        );
      });
}

commonDialogCommon(BuildContext cont, Widget child) {
  return showDialog(
      barrierColor: Colors.transparent,
      context: cont,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: Scaffold(
              backgroundColor: Colors.transparent, body: Center(child: child)),
        );
      });
}

BoxDecoration decorBgMutedTopBorder = BoxDecoration(
    color: targetDetailColor.border,
    borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(8), topRight: Radius.circular(8)));
BoxDecoration decorBgMutedBottomBorder = BoxDecoration(
  color: targetDetailColor.light,
  borderRadius: const BorderRadius.only(
      bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
);
BoxDecoration decorBgMuted = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(16),
);
BoxDecoration decorBgMutedBorder = BoxDecoration(
  color: Colors.white,
  border: Border.all(color: targetDetailColor.brand),
  borderRadius: BorderRadius.circular(16),
);

Widget exitQuit(BuildContext context) => Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text("Exit App?", style: styleForm),
        const SizedBox(height: 12),
        Text("Are you sure! want to exit...", style: styleForm),
        const SizedBox(height: 12),
        Row(
          children: [
            SizedBox(
              height: 40,
              width: MediaQuery.of(context).size.width / 2 - 24,
              child: ElevatedButton(
                style: TextButton.styleFrom(
                    backgroundColor: Colors.grey,
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                child: Text("Exit", style: styleButton),
                onPressed: () {
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  exit(0);
                },
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              height: 40,
              width: MediaQuery.of(context).size.width / 2 - 24,
              child: ElevatedButton(
                style: TextButton.styleFrom(
                    backgroundColor: targetDetailColor.brand,
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                child: Text("Discard", style: styleButton),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        )
      ],
    );

Widget logoutConfirm(BuildContext context) => Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text("Logout?", style: styleForm),
        const SizedBox(height: 12),
        Text("Are you sure! want to logout...", style: styleForm),
        const SizedBox(height: 12),
        Row(
          children: [
            SizedBox(
              height: 40,
              width: MediaQuery.of(context).size.width / 2 - 24,
              child: ElevatedButton(
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.grey,
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  child: Text("Logout", style: styleButton),
                  onPressed: () =>
                      Provider.of<AuthProvider>(context, listen: false)
                          .logout(context)),
            ),
            const SizedBox(width: 8),
            SizedBox(
              height: 40,
              width: MediaQuery.of(context).size.width / 2 - 24,
              child: ElevatedButton(
                style: TextButton.styleFrom(
                    backgroundColor: targetDetailColor.brand,
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                child: Text("Discard", style: styleButton),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        )
      ],
    );
