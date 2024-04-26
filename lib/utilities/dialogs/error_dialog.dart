
import 'package:flutter/widgets.dart';
import 'package:notetaker_practiceapp/utilities/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
){
  return showGenericDialog<void>(
    context: context,
     title: 'An error occured',
      content: text,
       optionsBuilder: () =>{
        'OK': null,
       },
       );
}