import 'dart:async';
import 'package:Notetaking/Constants/crud_constants.dart';
import 'package:Notetaking/Error_Handling/crud_exceptions.dart';
import 'package:Notetaking/database_tables/notes_table.dart';
import 'package:Notetaking/database_tables/users_table.dart';
import 'package:Notetaking/extensions/list/filter.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart'
    show MissingPlatformDirectoryException, getApplicationDocumentsDirectory;
import 'package:path/path.dart';

class NoteService {
  // Creating a singleton instance.
  static final NoteService _singletonShared = NoteService._sharedInstance();
  // private initalizer to be used.
  NoteService._sharedInstance() {
    _notesStreamController = StreamController<List<DatabaseNote>>.broadcast(
      onListen: () {
        _notesStreamController.sink.add(_notes);
      },
    );
  }

  // return the instance when the class called.
  factory NoteService() => _singletonShared;

  // Caching notes, to save the notes somewhere and get it from there.
  // Having data, use stream controller to manipulate that data 'add, remove update...'
  // Stream, stream controller to manipulate the stream 'stream manager, in charge of doing so'.

  // Stream:
  List<DatabaseNote> _notes = [];

  // Stream controller of the type List<DatabaseNote>:
  // Deleted 👇🏼
  // Broadcast means that it can have multiple listeners to the stream.
  // So you can have a listener for new notes added, and a listener for getting all notes and so on..
  // Otherwise you'll have to close it or you'll get an exception.
  late final StreamController<List<DatabaseNote>> _notesStreamController;

  // !Create a currentUser instance to filter notes by currentUser.
  DatabaseUser? _user;

  // Getter to get all
  Stream<List<DatabaseNote>> get allNotes =>
      _notesStreamController.stream.filter((note) {
        final currentUser = _user;
        if (currentUser != null) {
          return note.userId == currentUser.id;
        } else {
          throw UserShouldBeSetBeforeReadingAllNotes;
        }
      });

  // The purpose of this function is to read the notes from the database and cache it to _notes and update the streamController with new data.
  Future<void> _cacheNotes() async {
    final allNotes = await getAllNotes();
    _notes = allNotes.toList();
    _notesStreamController.add(_notes);
  }

  // Create a database instance.
  Database? _db;

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }
    try {
      // Getting the documents folder path of the os.
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);

      // This function will create the db if it doesn't exist already.
      final db = await openDatabase(dbPath);
      _db = db;

      db.execute(createUserTable);
      db.execute(createNoteTable);
      // cache all notes after creating the table 'it'll be empty but the stream is chunks of data in certain time 'empty, one element, another new element......'
      await _cacheNotes();
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectory();
    }
  }

  // Ensure the database is open.
  Future<void> ensureDBIsOpen() async {
    try {
      await open();
    } on DatabaseAlreadyOpenException {
      // Skip.
    }
  }

  Future<void> close() async {
    // final db = _db;
    if (_db == null) {
      throw DatabaseNotOpen();
    } else {
      // if it wasn't null close it.
      await _db?.close();
      _db = null;
    }
  }

  Database _getDatabaseOrThrowException() {
    // final db = _db;
    if (_db == null) {
      throw DatabaseNotOpen();
    } else {
      // return db;
      // 100% sure that it wont return null!
      return _db!;
    }
  }

  Future<void> deleteUser({required String email}) async {
    await ensureDBIsOpen();
    final db = _getDatabaseOrThrowException();

    // NOT UNDERSTOOD!
    final deletedCount = await db.delete(
      userTable,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );

    // Assertion that the user is deleted. as the db.delete returns the number of affected rows.
    if (deletedCount != 1) throw CouldNotDeleteUser();
  }

  Future<DatabaseUser> createUser({required String email}) async {
    await ensureDBIsOpen();
    final db = _getDatabaseOrThrowException();

// Looking for at least one person with the same email.
    final result = await db.query(
      userTable,
      limit: 1,
      where: "email = ?",
      whereArgs: [email.toLowerCase()],
    );

    if (result.isNotEmpty) throw UserAlreadyExists();

    // The second parameter is a map, a map consists of a key and a value, the key will be the column name, and the value will be the value it'll take from the user. And then return the Id of the inserted column.
    final userId = await db.insert(userTable, {
      emailColumn: email,
    });

    return DatabaseUser(
      id: userId,
      email: email,
    );
  }

// Retrieve a user based on their email address.
  Future<DatabaseUser> getUser({required String email}) async {
    await ensureDBIsOpen();
    final db = _getDatabaseOrThrowException();
    final result = await db.query(
      userTable,
      limit: 1,
      where: "email = ?",
      whereArgs: [email.toLowerCase()],
    );

    if (result.isEmpty) {
      throw CouldNotFindUser();
    } else {
      return DatabaseUser.fromRow(result.first);
    }
  }

  Future<DatabaseNote> createNote({required DatabaseUser noteOwner}) async {
    await ensureDBIsOpen();
    final db = _getDatabaseOrThrowException();

// make sure owner exist with the correct id.
    final dbUser = await getUser(email: noteOwner.email);
    if (dbUser != noteOwner) {
      throw CouldNotFindUser();
    }

    const text = '';

    // Create the note.
    final noteId = await db.insert(notesTable, {
      userIdColumn: noteOwner.id,
      textColumn: text,
      isSyncedWithCloudColumn: 1,
    });

    final note = DatabaseNote(
      id: noteId,
      userId: noteOwner.id,
      text: text,
      isSyncedWithCloud: true,
    );

    // Add the created note to the stream and update the streamController.
    _notes.add(note);
    _notesStreamController.add(_notes);

    return note;
  }

  Future<void> deleteNote({required int id}) async {
    await ensureDBIsOpen();
    final db = _getDatabaseOrThrowException();

    final deletedCount = await db.delete(
      notesTable,
      // The question mark value will be passed from the value of whereArgs!!!
      where: 'id = ?',
      whereArgs: [id],
    );

    if (deletedCount == 0) {
      throw CouldNotDeleteNote();
    } else {
      _notes.removeWhere((note) => note.id == id);
      _notesStreamController.add(_notes);
    }
  }

  Future<int> deleteAllNotes() async {
    await ensureDBIsOpen();
    final db = _getDatabaseOrThrowException();
    final numberOfDeletion = await db.delete(notesTable);
    _notes = [];
    _notesStreamController.add(_notes);
    return numberOfDeletion;
  }

  // Get specific note.
  Future<DatabaseNote> getNote({required int id}) async {
    await ensureDBIsOpen();
    final db = _getDatabaseOrThrowException();
    final notes = await db.query(
      notesTable,
      limit: 1,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (notes.isEmpty) {
      throw CouldNotFindNote();
    } else {
      // update the note in cache first.
      final note = DatabaseNote.fromRow(notes.first);

      // just to make sure that we have the newest version of the note in cache.
      // remove the old note.
      _notes.removeWhere((note) => note.id == id);

      // readd the new note.
      _notes.add(note);
      // update streamController/
      _notesStreamController.add(_notes);
      return note;
    }
  }

  // Get all notes.
  Future<Iterable<DatabaseNote>> getAllNotes() async {
    await ensureDBIsOpen();
    final db = _getDatabaseOrThrowException();
    final notes = await db.query(notesTable);

    return notes.map((noteRow) => DatabaseNote.fromRow(noteRow));
  }

  Future<DatabaseNote> updateNote({
    required DatabaseNote note,
    required String text,
  }) async {
    await ensureDBIsOpen();
    final db = _getDatabaseOrThrowException();

    // to make sure the note is existing before updating it.
    await getNote(id: note.id);

    // Update in database.
    final updateCount = await db.update(
      notesTable,
      {
        textColumn: text,
        isSyncedWithCloudColumn: 0,
      },
      where: 'id = ?',
      whereArgs: [note.id],
    );

    if (updateCount == 0) {
      throw CouldNotUpdateNote();
    } else {
      // use the getNote to return the note 'which it what it does'.
      final updatedNote = await getNote(id: note.id);
      // Remove the old note.
      _notes.removeWhere((note) => note.id == updatedNote.id);

      // Update the note.
      _notes.add(updatedNote);
      _notesStreamController.add(_notes);
      return updatedNote;
    }
  }

  // Create or get the current user that's registered with firebase account but might not have an account in our db.
  Future<DatabaseUser> getOrCreateUser({
    required String email,
    bool setAsCurrentUser = true,
  }) async {
    await ensureDBIsOpen();
    try {
      final user = await getUser(email: email);
      if (setAsCurrentUser) {
        _user = user;
      }
      return user;
    } on CouldNotFindUser {
      final createdUser = await createUser(email: email);
      if (setAsCurrentUser) {
        _user = createdUser;
      }
      return createdUser;
    } catch (e) {
      rethrow;
    }
  }
}
