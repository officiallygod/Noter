import 'package:flutter/material.dart';
import 'package:notes/screens/note_list_alternate.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Note Keeper',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.yellow,
        splashColor: Colors.yellowAccent,
        accentColor: Colors.yellowAccent,
      ),
      home: NoteListNew(),
    );
  }
}
