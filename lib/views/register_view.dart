import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:notetaker_practiceapp/constants/route.dart';
import 'package:notetaker_practiceapp/services/auth/auth_exceptions.dart';
import 'package:notetaker_practiceapp/services/auth/auth_service.dart';
import 'package:notetaker_practiceapp/utilities/show_error_dialog.dart';


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
    return Scaffold(
      appBar:AppBar(
        title: const Text('Register'),
        foregroundColor: (Colors.white),
        backgroundColor: (Colors.blue),) ,
      body: Column(
                children: [
                  TextField(
                    controller: _email,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'Enter your email here',
                    ),
                  ),
                  TextField(
                    controller: _password,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                     decoration: const InputDecoration(
                      hintText: 'Enter your password here',
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                   final email = _email.text;
                   final password = _password.text;
                   try{  
                   // final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      await AuthService.firebase().createUser(
                      email: email, 
                      password: password,
                      );
                      final user = AuthService.firebase().sendEmailVerification();
                      //devtools.log(userCredential.toString());
                      Navigator.of(context).pushNamed(verifyEmailRoute);
                    }
                    on WeakPasswordAuthException{
                      devtools.log('weak password');
                      await showErrorDialog(context, 'Password is weak, enter a stronger password!');
                    }
                    on EmailAlreadyInUseAuthException{
                      devtools.log('Email is already in use for another account');
                      await showErrorDialog(context, 'Email is already in use for another account');
                    }
                    on InvalidEmailAuthException{
                       devtools.log('Invalid email entered');
                      await showErrorDialog(context, 'Invalid email entered');
                    }
                    on GenericAuthException{
                       devtools.log('SOMETHING ELSE HAPPENED');
                      await showErrorDialog(context, 'Failed to register.');
                    
                    }
                  },
                    child: const Text('Register'),
                  ),
                   TextButton(
                  onPressed: (){
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                       (route) => false);
                  }, 
                  child: const Text('Already registered? Login here')
                  ),
                ],
              ),
    );
  }
}