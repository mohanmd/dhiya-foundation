// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:in4_solution/config/enums.dart';
import 'package:in4_solution/constants/buttons.dart';
import 'package:in4_solution/constants/notifications.dart';
import 'package:in4_solution/constants/text_field.dart';
import 'package:in4_solution/providers/all_providers.dart';
import 'package:in4_solution/screens/utility/bottom_sheets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '/../constants/contexts.dart';
import '/../constants/loaders.dart';
import '/../providers/auth_provider.dart';
import '/../providers/common_provider.dart';
import '/../providers/location_internet.dart';
import '/../screens/layout/sidebar.dart';
import '/../screens/utility/dialogue.dart';
import '../../constants/fonts.dart';
import '../../constants/keys.dart';

final picker = ImagePicker();

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

String remarks = '';

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      provdCommon.getSideBarList();
      // Provider.of<AuthProvider>(context, listen: false)
      //     .setCheckLocalDatas(materialKey.currentContext!);
    });
    super.initState();
    Timer.periodic(const Duration(seconds: 2), (Timer t) => setTime());
  }

  DateTime dateTime = DateTime.now();
  setTime() {
    if (!mounted) return;
    setState(() {
      dateTime = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.now();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, result) async {
        return commonDialog(context, exitQuit(context));
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          key: homeKey,
          backgroundColor: Colors.white,
          drawer: const SideBar(),
          appBar: AppBar(
              automaticallyImplyLeading: false,
              scrolledUnderElevation: 0,
              backgroundColor: Colors.white,
              centerTitle: false,
              title: Padding(
                padding: const EdgeInsets.only(left: 0),
                child: Image(width: 90, image: AssetImage("assets/${targetDetail.appname}.png"), fit: BoxFit.contain),
              ),
              actions: [
                InkWell(
                  onTap: () {
                    homeKey.currentState!.openDrawer();
                    FocusScope.of(context).unfocus();
                  },
                  child: SizedBox(width: 42, height: 40, child: Icon(Icons.menu, size: 24, color: targetDetailColor.dark)),
                ),
              ]),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SingleChildScrollView(
                child: Column(children: [
                  const SizedBox(height: 16),
                  SizedBox(
                    child: Column(children: [
                      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        const SizedBox(width: 36),
                        textTime(DateFormat('hh:mm').format(dateTime).toString()),
                        const SizedBox(width: 8),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: textTimeAm(DateFormat('a').format(dateTime).toString()),
                        )
                      ]),
                      textDate(DateFormat('EEEE, dd MMM yyyy').format(dateTime).toString()),
                    ]),
                  ),
                  const SizedBox(height: 24),
                  // textFormLabel(string),
                  // const SizedBox(height: 24),
                  Consumer<AuthProvider>(builder: (_, provider, __) {
                    return Visibility(
                      visible: provider.isHadAttendance,
                      child: SizedBox(
                        child: Column(children: [
                          (provider.checkInData['in_time'] ?? '').isEmpty ? checkIn(context) : checkOut(context),
                          const SizedBox(height: 12),
                          Consumer3<LocationProvider, CommonProvider, AuthProvider>(
                              builder: ((context, provd, provider, auth, child) => textCheckIn("Punch", targetDetailColor.dark))),
                        ]),
                      ),
                    );
                  }),

                  const SizedBox(height: 30),
                  SizedBox(
                    child: Consumer2<LocationProvider, AuthProvider>(builder: (_, provd, auth, __) {
                      return Column(children: [
                        provd.locationLoading
                            ? Column(children: [
                                textCheckTim("Fetching locations....", targetDetailColor.warning),
                                const SizedBox(height: 12),
                              ])
                            : const SizedBox.shrink(),
                        // Padding(
                        //   padding: const EdgeInsets.all(12.0),
                        //   child: provd.latitude == null
                        //       ? textCheckTim(
                        //           "Verify Your Location, to Check In (or) Out.",
                        //           targetDetailColor.danger,
                        //           align: TextAlign.center)
                        //       : !provd.bioMetric
                        //           ? textCheckTim(
                        //               "Use Screen Lock, to Check In (or) Out.",
                        //               targetDetailColor.danger,
                        //               align: TextAlign.center)
                        //           : textCheckTim(
                        //               "You Can Check In (or) Out Now.",
                        //               targetDetailColor.success),
                        // ),
                      ]);
                    }),
                  ),
                  Consumer<CommonProvider>(builder: (_, provider, __) {
                    return Column(children: [
                      userDetails(),
                      const SizedBox(height: 12),
                      checkOutTime(),
                      verifications(),
                      const SizedBox(height: 12),
                    ]);
                  })
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget checkOutTime() => Consumer<AuthProvider>(builder: (_, provider, __) {
        Map checkInData = provider.checkInData;
        return (provider.checkInData['in_time'] ?? '').isEmpty
            ? const SizedBox.shrink()
            : Container(
                margin: const EdgeInsets.only(bottom: 12),
                width: context.widthFull(),
                decoration: BoxDecoration(
                  border: Border.all(color: targetDetailColor.brand),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Column(children: [
                      textDate(DateFormat('hh:mm a').format(DateFormat("yyyy-MM-dd HH:mm:ss").parse(checkInData['in_time'])).toString()),
                      textCheckTim("Checked On", targetDetailColor.danger),
                    ]),
                    Column(
                      children: [
                        textDate((checkInData['out_time'] ?? '').toString().isNotEmpty
                            ? DateFormat('hh:mm a').format(DateFormat("yyyy-MM-dd HH:mm:ss").parse(checkInData['out_time'])).toString()
                            : "--:--"),
                        textCheckTim("Check Out", targetDetailColor.dark),
                      ],
                    ),
                    Column(children: [
                      textDate((DateTime.now().difference(DateFormat("yyyy-MM-dd HH:mm:ss").parse(checkInData['in_time']))).inHours.toString()),
                      textCheckTim("Working Hr's", targetDetailColor.danger),
                    ])
                  ]),
                ));
      });

  Widget userDetails() => Consumer<AuthProvider>(builder: (_, provider, __) {
        return Container(
            width: context.widthFull(),
            decoration: BoxDecoration(
              border: Border.all(color: targetDetailColor.brand),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        textUser(provider.userData['employee_name'] ?? '${provider.userData['user_name']}' ?? ''),
                        const SizedBox(height: 4),
                        textCheckTim("Employee Name", targetDetailColor.dark),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      //For others
                      textUser(provider.userData['finger_id'].toString()),

                      const SizedBox(height: 4),
                      textCheckTim("Employee Id", targetDetailColor.dark),
                    ],
                  )
                ],
              ),
            ));
      });

  Widget checkOut(BuildContext context) {
    return Consumer<LocationProvider>(builder: (_, location, __) {
      return GestureDetector(
        onTap: location.isLoading
            ? () {}
            : () {
                Provider.of<LocationProvider>(context, listen: false).checkFunction(false, context);
              },
        child: Center(
          child: Container(
            decoration:
                BoxDecoration(shape: BoxShape.circle, border: Border.all(width: 8, color: targetDetailColor.border), color: targetDetailColor.danger),
            height: MediaQuery.of(context).size.width / 3.6,
            width: MediaQuery.of(context).size.width / 3.6,
            child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: location.isLoading
                      ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [loader80()])
                      : Center(
                          child: FaIcon(
                            FontAwesomeIcons.solidHandBackFist,
                            size: 32,
                            color: targetDetailColor.light,
                          ),
                        ),
                )),
          ),
        ),
      );
    });
  }

  Widget checkIn(BuildContext context) {
    return Consumer<LocationProvider>(builder: (_, provider, __) {
      return GestureDetector(
        onTap: provider.isLoading
            ? () {}
            : () {
                Provider.of<LocationProvider>(context, listen: false).checkFunction(true, context);
              },
        child: Center(child: Consumer<LocationProvider>(
          builder: (_, provd, __) {
            return Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: 8, color: targetDetailColor.border),
                color: targetDetailColor.muted,
              ),
              height: MediaQuery.of(context).size.width / 3.6,
              width: MediaQuery.of(context).size.width / 3.6,
              child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: provider.isLoading
                        ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [loader80()])
                        : Center(
                            child: FaIcon(FontAwesomeIcons.solidHandBackFist, size: 32, color: targetDetailColor.dark),
                          ),
                  )),
            );
          },
        )),
      );
    });
  }

  Widget verifications() => Consumer2<LocationProvider, AuthProvider>(builder: (_, provd, auth, __) {
        return Container(
          width: context.widthFull(),
          decoration: BoxDecoration(border: Border.all(color: targetDetailColor.brand), borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        textStatus("Location"),
                        Text(" (Needed)", style: styleHintDark),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        provd.isMockLocation
                            ? Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 6),
                                child: textError("Fake Loc. Detected"),
                              )
                            : provd.latitude != null
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    child: textSuccess("Verified"),
                                  )
                                : const SizedBox.shrink(),
                        provd.latitude == null
                            ? Shimmer.fromColors(
                                baseColor: targetDetailColor.brand,
                                highlightColor: targetDetailColor.danger,
                                enabled: true,
                                child: GestureDetector(
                                  onTap: () => Provider.of<LocationProvider>(context, listen: false).getLocation(),
                                  child: Icon(
                                    Icons.pin_drop_outlined,
                                    size: 34,
                                    color: targetDetailColor.info,
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: () => Provider.of<LocationProvider>(context, listen: false).getLocation(),
                                child: Icon(
                                  Icons.pin_drop_outlined,
                                  size: 36,
                                  color: provd.isMockLocation ? targetDetailColor.danger : targetDetailColor.success,
                                ),
                              ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        textStatus("Fingerprint"),
                        Text(" (Needed)", style: styleHintDark),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        provd.bioMetric
                            ? Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: textSuccess("Verified"),
                              )
                            : const SizedBox.shrink(),
                        provd.bioMetric
                            ? Icon(Icons.fingerprint, size: 34, color: targetDetailColor.success)
                            : Shimmer.fromColors(
                                baseColor: targetDetailColor.brand,
                                highlightColor: targetDetailColor.danger,
                                enabled: true,
                                child: GestureDetector(
                                  onTap: () => Provider.of<LocationProvider>(context, listen: false).getBioMetric(),
                                  child: Icon(Icons.fingerprint, size: 36, color: targetDetailColor.info),
                                ),
                              )
                        // const SizedBox(width: 6),
                        // const SizedBox(
                        //   height: 32,
                        //   child: Image(
                        //       image: AssetImage(
                        //           "assets/fingerprint.png")),
                        // ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        textStatus("Photo"),
                        Text(" (${'Optional'})", style: styleHintDark),
                      ],
                    ),
                    ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(2)),
                        child: SizedBox(
                            child: provd.image == null
                                ? Shimmer.fromColors(
                                    baseColor: targetDetailColor.brand,
                                    highlightColor: targetDetailColor.danger,
                                    enabled: true,
                                    child: GestureDetector(
                                      onTap: () => Provider.of<LocationProvider>(context, listen: false).getCamera(),
                                      child: SizedBox(
                                        height: 34,
                                        child: Icon(Icons.camera_alt_outlined, size: 34, color: targetDetailColor.info),
                                      ),
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () => Provider.of<LocationProvider>(context, listen: false).getCamera(),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 12),
                                          child: textSuccess("Captured"),
                                        ),
                                        const SizedBox.shrink(),
                                        SizedBox(
                                          height: 32,
                                          width: 32,
                                          child: Image.file(provd.image!, fit: BoxFit.fill),
                                        ),
                                      ],
                                    ),
                                  ))),
                  ],
                )
              ],
            ),
          ),
        );
      });
  // @override
  // void dispose() {
  //   _connectivity.disposeStream();
  //   super.dispose();
  // }
}

class CheckInOutDialog extends StatefulWidget {
  const CheckInOutDialog({super.key});

  @override
  State<CheckInOutDialog> createState() => _CheckInOutDialogState();
}

class _CheckInOutDialogState extends State<CheckInOutDialog> {
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(Icons.lock, color: targetDetailColor.primaryDark, size: 38),
          const SizedBox(height: 12),
          textCustom("Authentication Required", size: 18),
          const SizedBox(height: 12),
          textCustom("Kindly enter your login password to punch your attendance", size: 14),
          const SizedBox(height: 12),
          textFieldAuth(passwordController, "Enter Password", TextInputType.text, false, Icons.password),
          const SizedBox(height: 24),
          buttonPrimary(context.widthFull(), 0, "Submit", validate)
        ]),
      ),
    );
  }

  validate() async {
    if (passwordController.text.isEmpty) {
      return notif('Failed', 'Kindly enter the password');
    }
    bool isValidated = await provdLocation.validatePassword(passwordController.text);
    Navigator.pop(context, isValidated);
  }
}
