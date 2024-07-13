import 'package:flutter/foundation.dart';
import 'package:Notetaking/Constants/cloud_storage_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// It's like the defenition of the "notes table".
@immutable
class CloudNote {
  final String documentId;
  final String ownerUserId;
  final String text;

  const CloudNote({
    required this.documentId,
    required this.ownerUserId,
    required this.text,
  });

// Allowing firestore to give a snapshot of the note and then use that to make instances of the notes.
  CloudNote.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      // for every created element an id must be generated.
      : documentId = snapshot.id,
        // get the rest of data from the constants that u created for the fields.
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        text = snapshot.data()[textFieldName] as String;
}
