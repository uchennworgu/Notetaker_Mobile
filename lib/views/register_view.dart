import 'package:flutter/material.dart';
import 'package:notetaker_practiceapp/extensions/buildcontext/loc.dart';

import 'package:notetaker_practiceapp/services/auth/auth_exceptions.dart';
import 'package:notetaker_practiceapp/services/auth/bloc/auth_bloc.dart';
import 'package:notetaker_practiceapp/services/auth/bloc/auth_event.dart';
import 'package:notetaker_practiceapp/services/auth/bloc/auth_state.dart';
import 'package:notetaker_practiceapp/utilities/dialogs/error_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {

  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
   void initState() {
     _email =TextEditingController();
     _password= TextEditingController();
     super.initState();
   }

   @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

   @override
  Widget build(BuildContext context) {

    final ThemeData theme = Theme.of(context);

    return BlocListener<AuthBloc , AuthState>(
      listener: (context , state) async {
        if (state is AuthStateRegistering){
          if (state.exception is WeakPasswordAuthException){
              await showErrorDialog(context, context.loc.register_error_weak_password);
          } else if (state.exception is EmailAlreadyInUseAuthException){
              await showErrorDialog(context, context.loc.register_error_email_already_in_use);
          } else if (state.exception is InvalidEmailAuthException){
              await showErrorDialog(context, context.loc.register_error_invalid_email);
          } else if (state.exception is GenericAuthException){
              await showErrorDialog(context, context.loc.register_error_generic);
            }
          
        }
      },
      child: Scaffold(
        appBar:AppBar(
          title:  Text(context.loc.register),
          //foregroundColor: (Colors.white),
         // backgroundColor: (Colors.blue),
          ) ,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                 const SizedBox(
                      height: 60,
                    ),

                
                 Text(context.loc.register_view_prompt, style: theme.textTheme.titleMedium!.copyWith(color: theme.primaryColor),textAlign: TextAlign.center),

                  const SizedBox(
                      height: 80,
                    ),

                
                TextField(
                  controller: _email,
                  enableSuggestions: false,
                  autocorrect: false,
                  autofocus: true,
                  keyboardType: TextInputType.emailAddress,
                  decoration:  InputDecoration(
                    hintText: context.loc.email_text_field_placeholder,
                  ),
                ),

                  const SizedBox(
                      height: 20,
                    ),

                TextField(
                  controller: _password,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                    decoration:  InputDecoration(
                    hintText: context.loc.password_text_field_placeholder,
                  ),
                ),

                  const SizedBox(
                      height: 140,
                    ),


                Center(
                  child: Column(
                    children: [
                      TextButton(
                        onPressed: () async {
                        final email = _email.text;
                        final password = _password.text;
                        context.read<AuthBloc>().add(
                        AuthEventRegister(email,password)
                        );
                      },
                        child:  Text(context.loc.register),
                      ),
                      TextButton(
                        onPressed: (){
                        context.read<AuthBloc>().add(
                        const AuthEventLogOut()
                        );}, 
                        child:  Text(context.loc.register_view_already_registered)
                          ),
                  
                    ],
                  ),
                ),
              
              ],
            ),
          ),
        ),
      ),
    );
  }
}