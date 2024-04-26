
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;
import 'package:notetaker_practiceapp/constants/route.dart';
import 'package:notetaker_practiceapp/enums/menu_action.dart';
import 'package:notetaker_practiceapp/services/auth/auth_service.dart';
import 'package:notetaker_practiceapp/services/crud/notes_service.dart';
import 'package:notetaker_practiceapp/utilities/dialogs/logout_dialog.dart';
import 'package:notetaker_practiceapp/views/notes/notes_list_view.dart';


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
                            return NotesListView(
                              notes: allNotes,
                               onDeleteNote: (note) async{
                                await _notesService.deleteNote(id: note.id);
                               }
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

