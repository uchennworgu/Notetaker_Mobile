
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;
import 'package:notetaker_practiceapp/constants/route.dart';
import 'package:notetaker_practiceapp/enums/menu_action.dart';
import 'package:notetaker_practiceapp/services/auth/auth_service.dart';
import 'package:notetaker_practiceapp/services/crud/notes_service.dart';


class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  // get an instance of note service to load relevant data
  late final NotesService _notesService;

  // retrieve email from firbase user info.
  String get UserEmail => AuthService.firebase().currentUser!.email!;

  @override
  void initState(){
    _notesService = NotesService();
    _notesService.open();
    super.initState();
  }

  @override
  void dispose(){
    _notesService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Main UI'),
        foregroundColor: (Colors.white),
        backgroundColor: (Colors.blue),
        actions: [
          PopupMenuButton<MenuAction> (
            onSelected: (value) async {
            //devtools.log(value.toString()); // THIS IS THE PREFERRED PRINT STRING METHOD
            switch (value) {

              case MenuAction.logout:
              final shouldLogout = await showLogOutDialog(context);
              if (shouldLogout){
                AuthService.firebase().logOut();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  loginRoute, 
                  (_) => false);
              }
              //devtools.log(shouldLogout.toString());
              //break;
                         }
          }, itemBuilder:(context){
            return const [
               PopupMenuItem<MenuAction> (
                value: MenuAction.logout, 
                child: Text('Logout')
                )
              ]; 
          }
          )
        ],
        ),
        body: FutureBuilder(
          future: _notesService.getOrCreateUser(email: UserEmail),
          builder: (context, snapshot) {
           switch (snapshot.connectionState){

             case ConnectionState.done:
                return StreamBuilder(
                  stream: _notesService.allNotes, 
                  builder: (context,snapshot){
                      switch (snapshot.connectionState){       
                        case ConnectionState.waiting:
                          return const Text('waiting for all notes');
                        default:
                        return const CircularProgressIndicator();
                      }

                    }              
                  );
             default:
                return CircularProgressIndicator();

             }
           
            },
          ),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context){
 return showDialog<bool>(
    context: context, 
    builder: (context){
      return  AlertDialog(
        title:   const Text('Sign out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(onPressed: () {
            Navigator.of(context).pop(false);
          }, child: const Text('Cancel')),
          TextButton(onPressed: () {
            Navigator.of(context).pop(true);
          }, child: const Text('Log Out'),),
        ],
      );
  },
  ).then((value) => value ?? false);
}