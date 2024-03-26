import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notetaker_practiceapp/firebase_options.dart';
import 'package:notetaker_practiceapp/views/login_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized;
  runApp(MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    ));
}

class HomePage
 extends StatelessWidget {
  const HomePage
  ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        foregroundColor: ( Colors.white),
        backgroundColor: ( Colors.blue),
        ),
        body: 
          FutureBuilder(
            future: Firebase.initializeApp(
                  options: DefaultFirebaseOptions.currentPlatform,
                 ),
            builder: (context, snapshot) {
              switch (snapshot.connectionState){
                case ConnectionState.done:
                final user = FirebaseAuth.instance.currentUser;
                if (user?.emailVerified ?? false){
                  print('you are a verified user!');
                }
                else{
                  print('You need to verify your email first');
                }
                return Text('Done');
            default:
            return Text('Loading...');
              }
            },
          ),
    );
  }

}


