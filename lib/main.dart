
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notetaker_practiceapp/firebase_options.dart';
import 'package:notetaker_practiceapp/views/login_view.dart';
import 'package:notetaker_practiceapp/views/notes_view.dart';
import 'package:notetaker_practiceapp/views/register_view.dart';
import 'package:notetaker_practiceapp/views/verify_email_view.dart';

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
        '/login/': (context)=> const LoginView(),
         '/register/': (context)=> const RegisterView(),
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
            future: Firebase.initializeApp(
                  options: DefaultFirebaseOptions.currentPlatform,
                 ),
            builder: (context, snapshot) {
              switch (snapshot.connectionState){
                 case ConnectionState.done:
                  	final user = FirebaseAuth.instance.currentUser;
                    print(user);
                    if (user != null){
                      if (user.emailVerified){
                        print('you are a verified user!');
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





