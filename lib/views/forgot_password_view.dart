import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notetaker_practiceapp/services/auth/bloc/auth_bloc.dart';
import 'package:notetaker_practiceapp/services/auth/bloc/auth_event.dart';
import 'package:notetaker_practiceapp/services/auth/bloc/auth_state.dart';
import 'package:notetaker_practiceapp/utilities/dialogs/error_dialog.dart';
import 'package:notetaker_practiceapp/utilities/dialogs/password_reset_email_sent_dialog.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {

  late final TextEditingController _controller;

  @override
  void initState(){
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc,AuthState>(
      listener: (context, state) async{
        if (state is AuthStateForgotPassword){
          if (state.hasSentEmail){
            _controller.clear();
            await showPasswordResetSentDialog(context);
          }
          if (state.exception != null){
            await showErrorDialog(context, 'We could not process your request. Verify that user registration is completed.');
          }
        }
    },
     child : Scaffold(
      appBar: AppBar(
        title: const Text('Forgot PAssword'),
        ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Forgot password? Enter your email and we will send a password reset link'),
            TextField( 
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              autofocus: true,
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Your email address......',
              ),
            ),
            TextButton(
              onPressed: (){
                final email = _controller.text;
                context.read<AuthBloc>().add(AuthEventForgotPassword(email:email));
              }, 
              child: 
                const Text('Send reset password link')
                ),

            TextButton(
              onPressed: (){
                context.read<AuthBloc>().add(const AuthEventLogOut());
              }, 
              child: 
                const Text('Back to login page')
                )
          ],
        ),
      ),
     ),
     
      );
  }
}