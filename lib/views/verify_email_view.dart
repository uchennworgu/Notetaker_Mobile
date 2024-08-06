import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notetaker_practiceapp/constants/route.dart';
import 'package:notetaker_practiceapp/services/auth/auth_service.dart';
import 'package:notetaker_practiceapp/services/auth/bloc/auth_bloc.dart';
import 'package:notetaker_practiceapp/services/auth/bloc/auth_event.dart';



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
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Text("A verification email has been sent to your provided email. Please click on the link to within the email to verify your account."),
            const Text('If you do not see the email in the next few buttons, please click the button below to send another verification email.'),
            TextButton(
              onPressed: () async {
                  context.read<AuthBloc>().add(
                    AuthEventSendEmailVerification()
                    );
                  }, 
                child: const Text('Re-send email verification'),
                ),
            TextButton(
              onPressed: () {
                  context.read<AuthBloc>().add(
                    AuthEventLogOut()
                    );
                }, 
                child: const Text('Restart'),
                ),
                ],
                ),
      ),
    );
  }
}
