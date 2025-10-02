import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notetaker_practiceapp/extensions/buildcontext/loc.dart';
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

    final ThemeData theme = Theme.of(context);

    return BlocListener<AuthBloc,AuthState>(
      listener: (context, state) async{
        if (state is AuthStateForgotPassword){
          if (state.hasSentEmail){
            _controller.clear();
            await showPasswordResetSentDialog(context);
          }
          if (state.exception != null){
            await showErrorDialog(
              context, 
              context.loc.forgot_password_view_generic_error);
          }
        }
    },
     child : Scaffold(
      appBar: AppBar(
        title: Text(context.loc.forgot_password),
        // all text would usually have const with it BUT replacing with arb strings will generate errors w/ const so we are removing them 
        ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [

                const SizedBox(
                      height: 60,
                    ),

               Text(
                context.loc.forgot_password_view_prompt,
                style: theme.textTheme.titleMedium!.copyWith(color: theme.primaryColor),textAlign: TextAlign.center,
                ),

                const SizedBox(
                      height: 110,
                    ),


              TextField( 
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                autofocus: true,
                controller: _controller,
                decoration: InputDecoration(
                  hintText: context.loc.email_text_field_placeholder,
                ),
              ),

               const SizedBox(
                      height: 170,
                    ),

              TextButton(
                onPressed: (){
                  final email = _controller.text;
                  context.read<AuthBloc>().add(AuthEventForgotPassword(email:email));
                }, 
                child: 
                   Text(context.loc.forgot_password_view_send_me_link)
                  ),
          
              TextButton(
                onPressed: (){
                  context.read<AuthBloc>().add(const AuthEventLogOut());
                }, 
                child: 
                   Text(context.loc.forgot_password_view_back_to_login)
                  )
            ],
          ),
        ),
      ),
     ),
     
      );
  }
}