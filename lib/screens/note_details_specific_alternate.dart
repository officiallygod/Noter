import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes/models/note.dart';
import 'package:notes/utils/database_helper.dart';

import '../constants/constants.dart';
import 'note_details_alternate.dart';

class NoteDetailNewSpecific extends StatefulWidget {
  final Note note;

  NoteDetailNewSpecific(this.note);

  @override
  _NoteDetailNewSpecificState createState() =>
      _NoteDetailNewSpecificState(this.note);
}

class _NoteDetailNewSpecificState extends State<NoteDetailNewSpecific> {
  Note note;
  DatabaseHelper databaseHelper = DatabaseHelper();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  _NoteDetailNewSpecificState(this.note);

  @override
  Widget build(BuildContext context) {
    bool _didUpdate = false;
    titleController.text = note.title;
    descriptionController.text = note.description;

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
                      onTap: () => Navigator.pop(context, _didUpdate),
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
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: backButtonColorAddNotesPage,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Center(
                    child: InkWell(
                      onTap: () async {
                        bool result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NoteDetailNew(note),
                          ),
                        );
                        if (result) {
                          _didUpdate = result;
                          Navigator.pop(context, true);
                        }
                      },
                      splashColor: Colors.yellowAccent,
                      child: Icon(
                        Icons.edit,
                        size: 35.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: 20.0, bottom: 5.0, left: 25.0, right: 16.0),
              child: Text(
                titleController.text,
                style: GoogleFonts.nunito(
                  fontSize: 42.0,
                  letterSpacing: 1,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: 5.0, bottom: 15.0, left: 26.0, right: 16.0),
              child: Text(
                descriptionController.text,
                style: GoogleFonts.poppins(
                    fontSize: 20.0, letterSpacing: 1, color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
