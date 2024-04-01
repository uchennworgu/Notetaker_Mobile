
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;


enum MenuAction { logout }

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Main UI'),
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
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login/', 
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
        body: 
        const Text('Hello world!'),
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