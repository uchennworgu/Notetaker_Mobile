import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:notetaker_practiceapp/constants/route.dart';
import 'package:notetaker_practiceapp/utilities/show_error_dialog.dart';


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
      appBar: AppBar(
        title: const Text('Login'),
        foregroundColor: (Colors.white),
        backgroundColor: (Colors.blue),),
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
                    //final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: email, 
                      password: password,
                    );
                    //devtools.log(userCredential.toString());
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      notesRoute, 
                      (_) => false,
                    );
                   }
                   on FirebaseAuthException catch (e) {
                    if (e.code == 'invalid-credential'){
                      devtools.log('user not found or combination incorrect');
                      await showErrorDialog(context, 'User not found or incorrect combination');
                    }
                     if (e.code == 'invalid-email'){
                      devtools.log('Email is not valid');
                      await showErrorDialog(context, 'Email is not valid.');
                    }
                    else{
                      devtools.log('SOMETHING ELSE HAPPENED');
                      devtools.log(e.code);
                      await showErrorDialog(context, 'Error: ${e.code}');
                    }
                   }
                    catch (e) {
                  //     print('Login failed.');
                  //     print(e);
                      await showErrorDialog(context, e.toString());

                    }
               
                  },
                    child: const Text('Login'),
                  ),
                  TextButton(
                    onPressed: (){
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        registerRoute,
                         (route) => false,
                         );
                    }, 
                    child: const Text('Not registered yet? Register here')
                    )
                ],
              ),
    );
    }
  }

  