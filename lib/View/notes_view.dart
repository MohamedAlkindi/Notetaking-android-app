import 'package:Notetaking/Dialogs/logout_dialog.dart';
import 'package:Notetaking/enums/menu_action.dart';
import 'package:Notetaking/services/auth/auth_service.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main UI'),
        // A list of Widgets to display in a row after the [title] widget.
        actions: [
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
      body: const Text('Hi'),
    );
  }
}
