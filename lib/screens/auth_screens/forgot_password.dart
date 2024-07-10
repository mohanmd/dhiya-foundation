import 'package:flutter/material.dart';
import 'package:in4_solution/constants/buttons.dart';
import 'package:in4_solution/constants/contexts.dart';
import 'package:in4_solution/constants/fonts.dart';
import 'package:in4_solution/constants/loaders.dart';
import 'package:in4_solution/constants/notifications.dart';
import 'package:in4_solution/constants/text_field.dart';
import 'package:in4_solution/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class ForgotPassWordScreen extends StatefulWidget {
  const ForgotPassWordScreen({super.key, this.name});

  final String? name;

  @override
  State<ForgotPassWordScreen> createState() => _ForgotPassWordScreenState();
}

class _ForgotPassWordScreenState extends State<ForgotPassWordScreen> {
  final TextEditingController userNameController = TextEditingController();
  bool foucs = true;

  @override
  void dispose() {
    userNameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    userNameController.text = widget.name ?? '';
    foucs = userNameController.text.isEmpty ? true : false;
    super.initState();
  }

  hitApi() {
    if (userNameController.text.isEmpty) {
      return notif('Failed', 'Kindly Enter your name');
    }
    Provider.of<AuthProvider>(context, listen: false)
        .forgotPassword(context, userNameController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, child) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(children: [
              textHeadCommon('Forgot Password'),
              const SizedBox(height: 12),
              textFieldAuth(userNameController, "Username", TextInputType.text,
                  false, Icons.person),
              const SizedBox(height: 24),
              auth.authLoading
                  ? loader35()
                  : Row(children: [
                      Expanded(child: buttonOutlined(context)),
                      const SizedBox(width: 12),
                      buttonPrimary(context.widthHalf() - 31, 0, "Submit",
                          () => hitApi()),
                    ]),
              const SizedBox(height: 12),
            ]),
          ],
        ),
      ),
    );
  }
}
