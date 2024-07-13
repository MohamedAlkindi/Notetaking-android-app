import 'package:Notetaking/database_tables/notes_table.dart';
import 'package:Notetaking/generics/get_arguments.dart';
import 'package:Notetaking/services/auth/auth_service.dart';
import 'package:Notetaking/services/notes_service.dart';
import 'package:flutter/material.dart';

class CreateUpdateNote extends StatefulWidget {
  const CreateUpdateNote({super.key});

  @override
  State<CreateUpdateNote> createState() => _CreateUpdateNoteState();
}

class _CreateUpdateNoteState extends State<CreateUpdateNote> {
  // To keep hold of the current note, as we don't want a new note empty note to be created when hotreload or restart.
  DatabaseNote? _note;
  late final NoteService _noteService;

  // as the user enters text we'll automatically sync that with the info in the db.
  late final TextEditingController _textEditingController;

  @override
  initState() {
    _noteService = NoteService();
    _textEditingController = TextEditingController();
    super.initState();
  }

  // Upon coming to this view a new note will be created, this function is for that purpose.
  Future<DatabaseNote> createOrGetExistingNote(BuildContext context) async {
    // Extracting database note from the getArgument function.
    final widgetNote = context.getArgument<DatabaseNote>();

    // if the user clicked on a note, so widgetNote won't be null.
    if (widgetNote != null) {
      _note = widgetNote;
      _textEditingController.text = widgetNote.text;
      return widgetNote;
    }
    // otherwise continue.
    // check if the note already existing.
    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }

    // We're expecting a user to be there, as if the user entered the notes view, the user is already registered firebase AND in our db.
    final currentUser = AuthService.fireBase().currentUser!;

    // get email from currentUser.
    final userEmail = currentUser.email;

    // put the email as the owner.
    final owner = await _noteService.getUser(email: userEmail);

    // Saving the note.
    final newNote = await _noteService.createNote(noteOwner: owner);
    _note = newNote;

    return newNote;
  }

  // Delete note if it's empty.
  void _deleteNoteIfTextIsEmpty() {
    final note = _note;
    if (_textEditingController.text.isEmpty && note != null) {
      _noteService.deleteNote(id: note.id);
    }
  }

  // Save the note automatically if the note has any character. for this u need listeners.
  void _saveNoteIfTextNoteEmpty() async {
    final note = _note;
    final text = _textEditingController.text;

    if (note != null && text.isNotEmpty) {
      await _noteService.updateNote(
        note: note,
        text: text,
      );
    }
  }

  // !to update current note as the user enters text u need listeners...
  void _textControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }

    final text = _textEditingController.text;
    await _noteService.updateNote(
      note: note,
      text: text,
    );
  }

  // setup the listener..
  void _setupTextControllerListener() {
    _textEditingController.removeListener(_textControllerListener);
    _textEditingController.addListener(_textControllerListener);
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNoteEmpty();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Note'),
      ),
      body: FutureBuilder(
        future: createOrGetExistingNote(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _setupTextControllerListener();

              return TextField(
                controller: _textEditingController,
                keyboardType: TextInputType.multiline,
                // to create a textField that has multilines and expand as u type write this line.
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'Add your text...',
                ),
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
