import 'package:flutter/material.dart';
import 'package:in4_solution/constants/fonts.dart';
import 'package:in4_solution/providers/all_providers.dart';
import 'package:in4_solution/screens/auth_screens/forgot_password.dart';
import 'package:in4_solution/screens/auth_screens/saved_password.dart';
import 'package:in4_solution/screens/utility/bottom_sheets.dart';
import 'package:in4_solution/screens/utility/dialogue.dart';
import 'package:in4_solution/services/locations.dart';
import 'package:provider/provider.dart';

import '/../constants/buttons.dart';
import '/../constants/contexts.dart';
import '/../constants/loaders.dart';
import '/../constants/text_field.dart';
import '/../providers/auth_provider.dart';
import '../../config/enums.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool visiblity = true;
  List langaugeList = ['English', 'عربي'];
  bool isRemember = false;
  @override
  void initState() {
    determinePosition();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (provdAuth.loginCreds.isNotEmpty) {
        commonBottomSheet(context, SavedPasswordScreen(creds: provdAuth.loginCreds, onTap: () => setValue()));
      }
    });
    super.initState();
  }

  void setValue() {
    Map creds = provdAuth.loginCreds ?? {};
    email.text = creds['user_name'] ?? '';
    password.text = creds['password'] ?? '';
    isRemember = true;
    Navigator.pop(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Image.asset("assets/${targetDetail.appname}.png",
                  width: MediaQuery.of(context).viewInsets.bottom != 0 ? context.widthQuarter() : context.widthHalf(), fit: BoxFit.cover),
              const SizedBox(height: 64),
              textFieldAuth(email, "Name", TextInputType.text, false, Icons.person),
              Stack(children: [
                textFieldAuth(password, "Password", TextInputType.visiblePassword, visiblity, Icons.key),
                Positioned(
                    right: 12,
                    top: 22,
                    child: GestureDetector(
                      onTap: () => setState(() {
                        visiblity = !visiblity;
                      }),
                      child: visiblity
                          ? Icon(
                              Icons.visibility_off,
                              color: targetDetailColor.brand.withOpacity(0.45),
                            )
                          : Icon(Icons.visibility, color: targetDetailColor.brand),
                    ))
              ]),
              const SizedBox(height: 16),
              InkWell(
                onTap: () => setState(() => isRemember = !isRemember),
                child: Row(children: [
                  Container(
                      height: 24,
                      width: 24,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: isRemember ? targetDetailColor.brand : Colors.white,
                          border: Border.all(color: !isRemember ? targetDetailColor.brand : Colors.white)),
                      child: const Icon(Icons.check, size: 18, color: Colors.white)),
                  const SizedBox(width: 8),
                  textCustom('Remember me')
                ]),
              ),
              const SizedBox(height: 16),
              Consumer<AuthProvider>(builder: (_, provider, __) {
                return provider.authLoading
                    ? loader35()
                    : buttonPrimary(context.widthFull(), 0, "LOGIN",
                        () => Provider.of<AuthProvider>(context, listen: false).login(context, email.text, password.text, isRemember));
              }),
              Column(children: [
                const SizedBox(height: 14),
                InkWell(
                  onTap: () => commonDialog(context, ForgotPassWordScreen(name: email.text), isHadborder: true),
                  child: textCustom('Forgot password', color: targetDetailColor.brand, decoration: TextDecoration.underline),
                ),
              ]),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  String selectecdLanguage = 'English';
  Widget dropdownButton(List list) {
    return SizedBox(
        height: 45,
        width: 130,
        child: DropdownButtonFormField(
            value: selectecdLanguage,
            decoration: const InputDecoration(
                filled: false, counterText: "", enabledBorder: InputBorder.none, focusedBorder: InputBorder.none, icon: Icon(Icons.language)),
            icon: const Icon(Icons.expand_more),
            items: list.map((items) {
              return DropdownMenuItem(value: items, child: textCustom(items));
            }).toList(),
            onChanged: (newValue) {
              selectecdLanguage = newValue.toString();
              setState(() {});
            }));
  }
}
