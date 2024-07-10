import 'package:flutter/material.dart';
import 'package:in4_solution/constants/buttons.dart';
import 'package:in4_solution/constants/contexts.dart';
import 'package:in4_solution/constants/loaders.dart';
import 'package:in4_solution/constants/notifications.dart';
import 'package:in4_solution/constants/text_field.dart';
import 'package:in4_solution/constants/topnavbar.dart';
import 'package:in4_solution/providers/auth_provider.dart';
import 'package:in4_solution/screens/main_screen/permission/permission_ask_screen.dart';
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController contNewPassword = TextEditingController();
  final TextEditingController contConfirmPassword = TextEditingController();
  bool isVisiblePass = true;
  bool isVisibleConfirmPass = true;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          topnavBar('Change Password', () => Navigator.pop(context), size),
          const SizedBox(height: 12),
          heading('New Password'),
          textFieldCommon(contNewPassword, "Enter a new password",
              TextInputType.visiblePassword, isVisiblePass,
              onTap: () => setState(() => isVisiblePass = !isVisiblePass)),
          const SizedBox(height: 12),
          heading('Confirm Password'),
          textFieldCommon(contConfirmPassword, "Re-enter new password",
              TextInputType.visiblePassword, isVisibleConfirmPass,
              onTap: () =>
                  setState(() => isVisibleConfirmPass = !isVisibleConfirmPass)),
          const SizedBox(height: 24),
          Consumer<AuthProvider>(
              builder: (context, auth, child) => auth.authLoading
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [loader35()])
                  : buttonPrimary(
                      context.widthFull(), 24, "Submit", () => hitApi())),
        ],
      )),
    );
  }

  hitApi() {
    FocusScope.of(context).unfocus();
    if (contNewPassword.text.isEmpty) {
      return notif('Failed', 'Kindly enter a new password');
    }
    if (contConfirmPassword.text.isEmpty) {
      return notif('Failed', 'Kindly enter confirm password');
    }
    if (contNewPassword.text != contConfirmPassword.text) {
      return notif('Failed', 'Password does not match');
    }
    Provider.of<AuthProvider>(context, listen: false)
        .changePassword(context, contConfirmPassword.text);
  }
}
