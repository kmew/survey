import 'package:flutter/material.dart';

class FormScreen extends StatelessWidget {

  const FormScreen({this.onTypeForm, this.onSubmitName});
  final TypeCallback onTypeForm;
  final SubmitCallback onSubmitName;


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text("Input Band Name"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(30.0),
            child: TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              onChanged: (text) {
                this.onTypeForm(text);
              },
            ),
          ),
          Center(
            child: RaisedButton(
              onPressed: () {
                this.onSubmitName();
                Navigator.pop(context);
              },
              child: Text('Submit!'),
            ),
          ),
        ],
      ),
    );
  }
}

typedef TypeCallback = void Function(String tmp);
typedef SubmitCallback = void Function();