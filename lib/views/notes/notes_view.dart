
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
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
        foregroundColor: (Colors.white),
        backgroundColor: (Colors.blue),
        actions: [
          IconButton(
            onPressed: (){
              Navigator.of(context).pushNamed(NewNoteRoute);
            }, 
            icon: const Icon(Icons.add)),
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
                        case ConnectionState.active:
                          if (snapshot.hasData){
                            final allNotes = snapshot.data as List<DatabaseNote>;
                            return ListView.builder(
                              itemCount: allNotes.length,
                              itemBuilder: (context, index) {
                                final note = allNotes[index];
                                return ListTile(
                                  title: Text(
                                    note.text,
                                    maxLines: 1,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,),
                                );
                              },
                            );
                          } else {
                            return const CircularProgressIndicator();
                          }        
                        default:
                        return const CircularProgressIndicator();
                      }

                    }              
                  );
             default:
                return const CircularProgressIndicator();

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