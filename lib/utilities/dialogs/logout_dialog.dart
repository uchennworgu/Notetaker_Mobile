import 'package:flutter/widgets.dart';
import 'package:notetaker_practiceapp/extensions/buildcontext/loc.dart';
import 'package:notetaker_practiceapp/utilities/dialogs/generic_dialog.dart';

Future<bool> showLogOutDialog(BuildContext context){
  return showGenericDialog<bool>(
    context: context, 
    title: context.loc.logout_button, 
    content: context.loc.logout_dialog_prompt, 
    optionsBuilder: () => {
      context.loc.cancel: false,
      context.loc.logout_button: true,
    },
    ).then((value)=> value ?? false,
    );
}