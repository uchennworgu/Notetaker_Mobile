import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notetaker_practiceapp/constants/route.dart';
import 'package:notetaker_practiceapp/helpers/loading/loading_screen.dart';
import 'package:notetaker_practiceapp/services/auth/bloc/auth_bloc.dart';
import 'package:notetaker_practiceapp/services/auth/bloc/auth_event.dart';
import 'package:notetaker_practiceapp/services/auth/bloc/auth_state.dart';
import 'package:notetaker_practiceapp/services/auth/firebase_auth_provider.dart';
import 'package:notetaker_practiceapp/views/forgot_password_view.dart';
import 'package:notetaker_practiceapp/views/login_view.dart';
import 'package:notetaker_practiceapp/views/notes/create_update_note_view.dart';
import 'package:notetaker_practiceapp/views/notes/notes_view.dart';
import 'package:notetaker_practiceapp/views/register_view.dart';
import 'package:notetaker_practiceapp/views/verify_email_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
//import 'dart:developer' as devtools show log;

void main() {
  WidgetsFlutterBinding.ensureInitialized;
  runApp(
    MaterialApp(
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    title: 'Flutter Demo',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 58, 183, 127)),
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
    return BlocConsumer<AuthBloc,AuthState>(
      listener: (context, state) {
        if (state.isLoading){
          LoadingScreen().show(
            context: context, 
            text: state.loadingText ?? 'Please wait a moment',);
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context,state){
        if (state is AuthStateLoggedIn){
          return const NotesView();
        } else if (state is AuthStateNeedsVerification){
          return const VerifyEmailView();
        } else if (state is AuthStateLoggedOut){
          return const LoginView();
        } else if (state is AuthStateForgotPassword){
          return const ForgotPasswordView();
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
