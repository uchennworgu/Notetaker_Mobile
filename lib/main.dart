import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notetaker_practiceapp/constants/route.dart';
import 'package:notetaker_practiceapp/services/auth/bloc/auth_bloc.dart';
import 'package:notetaker_practiceapp/services/auth/bloc/auth_event.dart';
import 'package:notetaker_practiceapp/services/auth/bloc/auth_state.dart';
import 'package:notetaker_practiceapp/services/auth/firebase_auth_provider.dart';
import 'package:notetaker_practiceapp/views/login_view.dart';
import 'package:notetaker_practiceapp/views/notes/create_update_note_view.dart';
import 'package:notetaker_practiceapp/views/notes/notes_view.dart';
import 'package:notetaker_practiceapp/views/register_view.dart';
import 'package:notetaker_practiceapp/views/verify_email_view.dart';
//import 'dart:developer' as devtools show log;

void main() {
  WidgetsFlutterBinding.ensureInitialized;
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    home:  BlocProvider <AuthBloc>(
      create: (context) => AuthBloc(FirebaseAuthProvider()),
      child: const HomePage(),
    ),
    routes: {
      createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocBuilder<AuthBloc,AuthState>(
      builder: (context,state){
        if (state is AuthStateLoggedIn){
          return const NotesView();
        } else if (state is AuthStateNeedsVerification){
          return const VerifyEmailView();
        } else if (state is AuthStateLoggedOut){
          return const LoginView();
        } else if (state is AuthStateRegistering){
          return const RegisterView();
        }
        else {
          return const Scaffold(
            body: Text('deadzone'),
          );
        }
    },);
  }
}
