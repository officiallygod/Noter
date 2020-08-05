import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes/models/note.dart';
import 'package:notes/screens/note_details_specific_alternate.dart';
import 'package:notes/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

import '../constants/constants.dart';
import '../screens/note_details_alternate.dart';

class NoteListNew extends StatefulWidget {
  @override
  _NoteListStateNew createState() => _NoteListStateNew();
}

class _NoteListStateNew extends State<NoteListNew> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList;
  int count = 0;

  static Color getRandomColour() {
    final _random = new Random();
    final List<Color> colours = [
      Color(0xFFFFAB91),
      Color(0xFFFFCC80),
      Color(0xFFE6EE9B),
      Color(0xFF80DEEA),
      Color(0xFFCF93D9),
      Color(0xFF80CBC4),
      Color(0xFFF48FB1),
    ];

    return colours[_random.nextInt(7)];
  }

  Widget getPriorityWidget(int priority) {
    switch (priority) {
      case 1:
        return Icon(
          Icons.star,
          color: Colors.yellowAccent,
        );
        break;
      case 2:
        return Icon(
          Icons.star_border,
          color: Colors.grey,
        );
        break;
      default:
        return Icon(
          Icons.star_border,
          color: Colors.grey,
        );
    }
  }

  void _delete(BuildContext context, Note note) async {
    int result = await databaseHelper.deleteNote(note.id);
    if (result != 0) {
      _showSnackBar(context, 'Note Destroyed');
      updateListView();
    }
  }

  void _favorite(Note note) async {
    note.priority == 1 ? note.priority = 2 : note.priority = 1;
    int result = await databaseHelper.updateNote(note);
    if (result != 0) {
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      backgroundColor: backButtonColorAddNotesPage,
      content: Text(
        message,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = List<Note>();
      updateListView();
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColorAddNotesPage,
        elevation: 0,
        title: Text(
          'Notes',
          style: GoogleFonts.raleway(
            letterSpacing: 2,
            fontSize: 25.0,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: backgroundColorAddNotesPage,
      body: count == 0
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 150,
                    width: 180,
                    child: Image(
                      image: AssetImage('assets/write.png'),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    'Looks so Empty',
                    style: GoogleFonts.raleway(
                      letterSpacing: 2,
                      fontSize: 25.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            )
          : Container(
              padding: EdgeInsets.only(
                  top: 20.0, bottom: 10.0, left: 10.0, right: 10.0),
              child: getNoteListView(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NoteDetailNew(Note('', '', 2)),
            ),
          );
          if (result) {
            updateListView();
          }
        },
        backgroundColor: Colors.yellowAccent,
        elevation: 6.0,
        tooltip: 'Add Note',
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }

  StaggeredGridView getNoteListView() {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 4,
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
      itemCount: count,
      staggeredTileBuilder: (int index) {
        return StaggeredTile.count(2, index.isEven ? 2.8 : 2);
      },
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () async {
            bool result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    NoteDetailNewSpecific(this.noteList[index]),
              ),
            );
            if (result) {
              updateListView();
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: getRandomColour(),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          splashColor: Colors.yellowAccent,
                          onTap: () {
                            _favorite(this.noteList[index]);
                          },
                          child:
                              getPriorityWidget(this.noteList[index].priority),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          splashColor: Colors.yellowAccent,
                          onTap: () {
                            _delete(context, this.noteList[index]);
                          },
                          child: Icon(
                            Icons.delete_outline,
                            size: 30.0,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          this.noteList[index].title,
                          softWrap: true,
                          maxLines: index.isEven ? 5 : 3,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.nunito(
                            fontSize: index.isEven ? 24.0 : 18.0,
                            letterSpacing: 1,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          this.noteList[index].date,
                          style: GoogleFonts.nunito(
                            fontSize: 13.0,
                            letterSpacing: 1,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
