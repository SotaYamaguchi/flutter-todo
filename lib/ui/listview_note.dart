import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

import 'package:flutter/material.dart';

import 'package:flutter_sample/model/note.dart';
import 'package:flutter_sample/ui/note_screen.dart';

class ListViewNote extends StatefulWidget {
  ListViewNote({Key key, this.title, this.analytics, this.observer})
      : super(key: key);

  final String title;
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _ListViewNoteState createState() =>
      new _ListViewNoteState(analytics, observer);
}

final notesReference = FirebaseDatabase.instance.reference().child('notes');

class _ListViewNoteState extends State<ListViewNote> {
  _ListViewNoteState(this.analytics, this.observer);

  final FirebaseAnalyticsObserver observer;
  final FirebaseAnalytics analytics;
  List<Note> items;
  StreamSubscription<Event> _onNoteAddedSubscription;
  StreamSubscription<Event> _onNoteChangedSubscription;

  @override
  void initState() {
    super.initState();

    items = new List();

    _onNoteAddedSubscription = notesReference.onChildAdded.listen(_onNoteAdded);
    _onNoteChangedSubscription =
        notesReference.onChildChanged.listen(_onNoteUpdated);
  }

  @override
  void dispose() {
    _onNoteAddedSubscription.cancel();
    _onNoteChangedSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Todo List'),
          centerTitle: true,
        ),
        body: _showListView(),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => _createNewNote(context),
        ),
      ),
    );
  }

  Widget _showListView() {
    return Center(
      child: ListView.builder(
          itemCount: items.length,
          padding: const EdgeInsets.all(15.0),
          itemBuilder: (context, position) {
            return Column(
              children: <Widget>[
                Divider(height: 5.0),
                Card(
                  child: InkWell(
                    child: Row(
                      children: <Widget>[
                        _showTskNumber(position),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              _showTaskTitle(position),
                              _showTaskDescription(position),
                            ],
                          ),
                        ),
                        _showDeleteButton(position),
                      ],
                    ),
                    onTap: () => _navigateToNote(context, items[position]),
                  ),
                ),
              ],
            );
          }),
    );
  }

  Widget _showTskNumber(int position) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: CircleAvatar(
        backgroundColor: Colors.blueAccent,
        radius: 10.0,
        child: Text(
          '${position + 1}',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _showTaskTitle(int position) {
    return Padding(
      padding: EdgeInsets.only(left: 10),
      child: SizedBox(
        width: 300,
        child: Text(
          '${items[position].title}',
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
      ),
    );
  }

  Widget _showTaskDescription(int position) {
    return Padding(
      padding: EdgeInsets.only(right: 0),
      child: SizedBox(
        width: 250,
        child: Text(
          '${items[position].description}',
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 3,
        ),
      ),
    );
  }

  Widget _showDeleteButton(int position) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: IconButton(
        icon: const Icon(Icons.remove_circle_outline),
        onPressed: () => _deleteNote(context, items[position], position)
      ),
    );
  }

  void _onNoteAdded(Event event) {
    setState(() {
      items.add(new Note.fromSnapshot(event.snapshot));
    });
  }

  void _onNoteUpdated(Event event) {
    var oldNoteValue =
        items.singleWhere((note) => note.id == event.snapshot.key);
    setState(() {
      items[items.indexOf(oldNoteValue)] =
          new Note.fromSnapshot(event.snapshot);
    });
  }

  void _deleteNote(BuildContext context, Note note, int position) async {
    await notesReference.child(note.id).remove().then((_) {
      setState(() {
        items.removeAt(position);
      });
    });
  }

  void _navigateToNote(BuildContext context, Note note) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteScreen(note)),
    );
  }

  void _createNewNote(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteScreen(Note(null, '', ''))),
    );
  }
}
