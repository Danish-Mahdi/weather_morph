import 'package:flutter/material.dart';

void showMsgToUser(String msg, BuildContext context){
  showDialog(context: context, builder: (context) =>
    AlertDialog(
      title: Text(
        msg
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Dismiss the dialog
          },
          child: const Text('Ok',
          style: TextStyle(
            fontSize: 15

          ),
          ),
        ),
      ],
    )
  );
}