import 'package:Notetaking/Dialogs/logout_dialog.dart';
import 'package:Notetaking/enums/menu_action.dart';
import 'package:Notetaking/services/auth/auth_service.dart';
import 'package:Notetaking/services/notes_service.dart';
import 'package:flutter/material.dart';
import 'package:Notetaking/Constants/routes.dart';
// devtools is an alias, only get log from that package 'will be used instead of print()'
// import 'dart:developer' as devtools show log;

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  // Assuring that their is a current user and that user has an email.
  String get userEmail => AuthService.fireBase().currentUser!.email!;

  // Upon initialization, open the db.
  late final NoteService _noteService;
  @override
  void initState() {
    _noteService = NoteService();
    _noteService.open();
    super.initState();
  }

  @override
  void dispose() {
    _noteService.close();
    super.dispose();
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
              Navigator.of(context).pushNamed(newNoteRoute);
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
                    await AuthService.fireBase().logOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (_) => false,
                    );
                  }
              }
            },
          ),
        ],
      ),
      body: FutureBuilder(
        // Creating the user if it doesn't exist or return it if it does.
        future: _noteService.getOrCreateUser(email: userEmail),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            // if FutureBuilder use mostly use 'done'.
            case ConnectionState.done:
              // Listen to the changes happen to that stream getter called allNotes, from that List which has a streamController in notes_service.dart, which will build the UI.
              // in StreamBuilder use mostly 'waiting' because a stream will most likly keep on going...
              return StreamBuilder(
                stream: _noteService.allNotes,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const Text('waiting for notes');
                    default:
                      return const CircularProgressIndicator();
                  }
                },
              );
            default:
              return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
