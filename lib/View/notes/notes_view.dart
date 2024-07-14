// ignore_for_file: use_build_context_synchronously

import 'package:Notetaking/Dialogs/logout_dialog.dart';
import 'package:Notetaking/View/notes_list_view.dart';
import 'package:Notetaking/enums/menu_action.dart';
import 'package:Notetaking/services/auth/auth_service.dart';
import 'package:Notetaking/services/auth/bloc/auth_bloc.dart';
import 'package:Notetaking/services/auth/bloc/auth_event.dart';
import 'package:Notetaking/services/cloud/cloud_note.dart';
import 'package:flutter/material.dart';
import 'package:Notetaking/Constants/routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/cloud/firebase_cloud_storage.dart';
// devtools is an alias, only get log from that package 'will be used instead of print()'
// import 'dart:developer' as devtools show log;

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  // Assuring that their is a current user and that user has an email.
  String get userId => AuthService.fireBase().currentUser!.id;

  // Upon initialization, open the db.
  late final FirebaseCloudStorage _noteService;
  @override
  void initState() {
    _noteService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your notes'),
        // A list of Widgets to display in a row after the [title] widget.
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
            },
            icon: const Icon(Icons.add),
          ),
          // Add a dropwown menu for the user, which gets its values from the enum we created eariler.
          PopupMenuButton<MenuAction>(
            // Creates the dropdown menu items using the values in the enum.
            itemBuilder: (context) {
              return [
                const PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Logout'),
                ),
              ];
            },
            onSelected: (value) async {
              // The value which we created earlier in itemBuilder.
              switch (value) {
                case MenuAction.logout:
                  bool shouldLogout = await showLogoutDialog(context);

                  if (shouldLogout) {
                    context.read<AuthBloc>().add(
                          const AuthEventLogOut(),
                        );
                  }
              }
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _noteService.allNotes(ownerUserId: userId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            // 'fall through' when it has 0 or more notes:
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allNote = snapshot.data as Iterable<CloudNote>;
                return NotesListView(
                  notes: allNote,
                  onDeleteNote: (note) async {
                    await _noteService.deleteNote(documentId: note.documentId);
                  },
                  onTap: (note) {
                    Navigator.of(context)
                        .pushNamed(createOrUpdateNoteRoute, arguments: note);
                  },
                );
              } else {
                return const CircularProgressIndicator();
              }
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
