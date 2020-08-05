import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:notes/models/note.dart';
import 'package:notes/utils/database_helper.dart';

import '../constants/constants.dart';

class NoteDetailNew extends StatefulWidget {
  final Note note;

  NoteDetailNew(this.note);

  @override
  _NoteDetailNewState createState() => _NoteDetailNewState(this.note);
}

class _NoteDetailNewState extends State<NoteDetailNew> {
  Note note;
  DatabaseHelper databaseHelper = DatabaseHelper();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  _NoteDetailNewState(this.note);

  @override
  Widget build(BuildContext context) {
    if (note != null) {
      titleController.text = note.title;
      descriptionController.text = note.description;
    }

    return Scaffold(
      backgroundColor: backgroundColorAddNotesPage,
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.all(16.0),
                  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    color: backButtonColorAddNotesPage,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Center(
                    child: InkWell(
                      onTap: () => Navigator.pop(context, true),
                      child: Icon(
                        Icons.chevron_left,
                        size: 38.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(16.0),
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                  decoration: BoxDecoration(
                    color: backButtonColorAddNotesPage,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Center(
                    child: InkWell(
                        onTap: () {
                          if (titleController.text.length < 3) {
                            _showSnackBar(context, 'Title Too Short');
                          } else {
                            _save(context);
                          }
                        },
                        splashColor: Colors.yellowAccent,
                        child: Text(
                          'Save',
                          style: GoogleFonts.nunito(
                            fontSize: 20.0,
                            letterSpacing: 1,
                            color: Colors.white,
                          ),
                        )),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: 20.0, bottom: 5.0, left: 25.0, right: 16.0),
              child: TextField(
                controller: titleController,
                onChanged: (value) {
                  updateTitle();
                },
                style: GoogleFonts.nunito(
                  fontSize: 42.0,
                  letterSpacing: 1,
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  hintText: 'Title',
                  hintStyle: GoogleFonts.nunito(
                    fontSize: 42.0,
                    letterSpacing: 1,
                    color: Colors.grey,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: 5.0, bottom: 15.0, left: 26.0, right: 16.0),
              child: TextField(
                controller: descriptionController,
                onChanged: (value) {
                  updateDescription();
                },
                style: GoogleFonts.poppins(
                    fontSize: 20.0, letterSpacing: 1, color: Colors.white70),
                decoration: InputDecoration(
                  hintText: 'Type Something...',
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 20.0,
                    letterSpacing: 1,
                    color: Colors.grey,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updateTitle() {
    note.title = titleController.text;
  }

  void updateDescription() {
    note.description = descriptionController.text;
  }

  void _save(BuildContext contextNew) async {
    Navigator.pop(context, true);

    note.priority = 2;
    note.date = DateFormat.yMMMd().format(DateTime.now());

    int result;
    if (note.id != null) {
      result = await databaseHelper.updateNote(note);
    } else {
      result = await databaseHelper.insertNote(note);
    }

    if (result != 0) {
      _showSnackBar(contextNew, 'You did it!');
    } else {
      _showSnackBar(contextNew, 'Encountered an Error!');
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }
}
