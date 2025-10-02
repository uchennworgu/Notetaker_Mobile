import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'dart:developer' as devtools show log;
import 'package:notetaker_practiceapp/services/auth/auth_exceptions.dart';
import 'package:notetaker_practiceapp/services/auth/bloc/auth_bloc.dart';
import 'package:notetaker_practiceapp/services/auth/bloc/auth_event.dart';
import 'package:notetaker_practiceapp/services/auth/bloc/auth_state.dart';
import 'package:notetaker_practiceapp/utilities/dialogs/error_dialog.dart';
import 'package:notetaker_practiceapp/extensions/buildcontext/loc.dart';


class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;


  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
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

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          if (state.exception is InvalidCredentialAuthException) {
            await showErrorDialog(
            context, context.loc.login_error_cannot_find_user);
        } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(context, 
            context.loc.login_error_wrong_credentials);
        } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, context.loc.login_error_auth_error);
        }
      }
     },
      child: Scaffold(
        //backgroundColor: Colors.pink,
        appBar: AppBar(
          title:  Text(context.loc.my_notes, style: TextStyle(fontSize: 40),),
          centerTitle: true,
          //title: Text(AppLocalizations.of(context)!.my_title),
          // ^ using arb file to create title that will switch based on language settings
          //title: Text(context.loc.my_title), 
          // ^same function as other line but uses a getter in loc.dart file to 
          // unwrap context automatically, making code more readable
          //foregroundColor: (Colors.white),
          //backgroundColor: colorTheme.secondary,
        ),
        body: SizedBox.expand(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0), 
            child: SingleChildScrollView(
              child: SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    const SizedBox(
                      height: 70,
                    ),

                    Text(context.loc.login_view_prompt, style: theme.textTheme.titleMedium!.copyWith(color: theme.primaryColor),textAlign: TextAlign.center,),
                    
                    const SizedBox(
                      height: 70,
                    ),

                    TextField(
                      textAlign: TextAlign.center,
                      controller: _email,
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      decoration:  InputDecoration(
                        hintText: context.loc.email_text_field_placeholder,
                        hintStyle: theme.textTheme.bodyLarge!.copyWith(color: theme.primaryColor),
                      ),
                    ),

                       const SizedBox(
                      height: 20,
                    ),

                    TextField(
                      textAlign: TextAlign.center,
                      controller: _password,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration:  InputDecoration(
                        hintText: context.loc.password_text_field_placeholder,
                        hintStyle: theme.textTheme.bodyLarge!.copyWith(color: theme.primaryColor),
                      ),
                    ),           

                     const SizedBox(
                      height: 110,
                    ),

                    TextButton(
                      onPressed: () async {
                        final email = _email.text;
                        final password = _password.text;
                        context.read<AuthBloc>().add(
                              AuthEventLogIn(email, password),
                            );
                      },
                      child:  Text(
                        context.loc.login,
                        ),
                    ),

                    TextButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(const AuthEventForgotPassword());
                      },
                      child:  Text(
                        context.loc.login_view_forgot_password,
                      )),
                    
                    TextButton(
                          onPressed: () {
                            context.read<AuthBloc>().add(const AuthEventShouldRegister());
                          },
                          child:  Text(
                            context.loc.login_view_not_registered_yet,
                          )),
                    
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
