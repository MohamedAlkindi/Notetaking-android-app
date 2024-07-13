import 'package:Notetaking/Constants/cloud_storage_constants.dart';
import 'package:Notetaking/Error_Handling/cloud_storage_exceptions.dart';
import 'package:Notetaking/services/cloud/cloud_note.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Rewatch part 36
class FirebaseCloudStorage {
  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  // Private constructor.
  FirebaseCloudStorage._sharedInstance();
  // return the singelton instance.
  factory FirebaseCloudStorage() => _shared;

  // Extract the collection from firestore.
  final notes = FirebaseFirestore.instance.collection('notes');

  Future<CloudNote> createNewNote({required String ownerUserId}) async {
    final document = await notes.add(
      {
        ownerUserIdFieldName: ownerUserId,
        textFieldName: '',
      },
    );
    final fetchedNote = await document.get();
    return CloudNote(
      documentId: fetchedNote.id,
      ownerUserId: ownerUserId,
      text: '',
    );
  }

  // read more about this headache.
  Future<Iterable<CloudNote>> getNotes({required String ownerUserId}) async {
    try {
      return await notes
          .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
          // use .get() to execute the query.
          .get()
          .then(
            (value) => value.docs.map(
              (doc) => CloudNote.fromSnapshot(doc),
            ),
          );
    } catch (e) {
      throw CouldNotGetAllNotesNoteException;
    }
  }

  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) =>
      notes.snapshots().map((event) => event.docs
          .map((doc) => CloudNote.fromSnapshot(doc))
          .where((note) => note.ownerUserId == ownerUserId));

  Future<void> updateNote(
      {required String documentId, required String text}) async {
    try {
      await notes.doc(documentId).update({textFieldName: text});
    } catch (_) {
      throw CouldNotUpdateNoteException;
    }
  }

  Future<void> deleteNote({required String documentId}) async {
    try {
      await notes.doc(documentId).delete();
    } catch (_) {
      throw CouldNotDeleteNoteNoteException;
    }
  }
}
