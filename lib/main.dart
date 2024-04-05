import 'package:flutter/material.dart';
import 'package:notetaker_practiceapp/constants/route.dart';
import 'package:notetaker_practiceapp/services/auth/auth_service.dart';
import 'package:notetaker_practiceapp/views/login_view.dart';
import 'package:notetaker_practiceapp/views/notes_view.dart';
import 'package:notetaker_practiceapp/views/register_view.dart';
import 'package:notetaker_practiceapp/views/verify_email_view.dart';
import 'dart:developer' as devtools show log;


void main() {
  WidgetsFlutterBinding.ensureInitialized;
  runApp(MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
      routes: {
        loginRoute: (context)=> const LoginView(),
        registerRoute: (context)=> const RegisterView(),
        notesRoute: (context)=> const NotesView(),
        verifyEmailRoute: (context)=> const VerifyEmailView(),
      },
    ));
}

class HomePage
 extends StatelessWidget {
  const HomePage
  ({super.key});

  @override
  Widget build(BuildContext context) {
    return     FutureBuilder(
            future: AuthService.firebase().initialize(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState){
                 case ConnectionState.done:
                  	final user =AuthService.firebase().currentUser;
                    devtools.log(user.toString());
                    if (user != null){
                      if (user.isEmailVerified){
                        devtools.log('you are a verified user!');
                        return const NotesView();
                      }
                      else{
                        return const VerifyEmailView();
                      }
                    }
                    else{
                      return const LoginView();
                    }

                 default:
              return const CircularProgressIndicator();
              }
            },
          );
  }

}





