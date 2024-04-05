import 'package:flutter/material.dart';
import 'package:notetaker_practiceapp/constants/route.dart';
import 'package:notetaker_practiceapp/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Email'),
        foregroundColor: (Colors.white),
        backgroundColor: (Colors.blue),),
      body: Column(
        children: [
          const Text("A verification email has been sent to your provided email. Please click on the link to within the email to verify your account."),
          const Text('If you do not see the email in the next few buttons, please click the button below to send another verification email.'),
          TextButton(
            onPressed: () async {
              AuthService.firebase().sendEmailVerification();
                }, 
              child: const Text('Re-send email verification'),
              ),
          TextButton(
            onPressed: () async{
                AuthService.firebase().sendEmailVerification();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  registerRoute, 
                  (route) => false,
                  );
              }, 
              child: const Text('Restart'),
              ),
              ],
              ),
    );
  }
}
