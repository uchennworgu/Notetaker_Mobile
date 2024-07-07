import 'package:flutter/material.dart';
import 'package:notetaker_practiceapp/utilities/dialogs/generic_dialog.dart';

Future<void> showPasswordResetSentDialog(BuildContext context){
  return showGenericDialog(
    context: context, 
    title: 'Passwword Reset', 
    content: 'We have sent you a password reset link. Check your email please', 
    optionsBuilder: () => {
      	'OK': null,
      },
    );
}