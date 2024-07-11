import 'package:Notetaking/Dialogs/delete_dialog.dart';
import 'package:Notetaking/database_tables/notes_table.dart';
import 'package:flutter/material.dart';

// Creating a callback to give values to the notes_view.
// Define a function which will take a database note which will be called when the user presses 'yes' in the dialog.
typedef DeleteNoteCallback = void Function(DatabaseNote note);

class NotesListView extends StatelessWidget {
  // Passing the list of notes to this file to render them.
  final List<DatabaseNote> notes;

  final DeleteNoteCallback onDeleteNote;

  const NotesListView({
    super.key,
    required this.notes,
    required this.onDeleteNote,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return ListTile(
          title: Text(
            note.text,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          // use trailing to add something at the end of the note 'to the right'. which will be used for the delete button.
          trailing: IconButton(
            onPressed: () async {
              final shouldDelete = await showDeleteDialog(context);
              if (shouldDelete) {
                onDeleteNote(note);
              }
            },
            icon: const Icon(Icons.delete),
          ),
        );
      },
    );
  }
}
