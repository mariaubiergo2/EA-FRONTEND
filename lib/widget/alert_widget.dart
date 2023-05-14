import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String message;

  const CustomAlertDialog({required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return
    // return SnackBar(
    //       elevation: 0,
    //       behavior: SnackBarBehavior.floating,
    //       backgroundColor: Colors.transparent,
    //       content: AwesomeSnackbarContent(
    //         title: 'Wrong credentials!',
    //         message: 'Please, try again',
    //         /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
    //         contentType: ContentType.failure,
    //       ),
    //     );
    AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context); // Close the dialog
          },
          child: Text('OK'),
        ),
      ],
    );
  }
}
