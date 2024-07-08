import 'package:Notetaking/Constants/crud_constants.dart';
import 'package:Notetaking/Error_Handling/crud_exceptions.dart';
import 'package:Notetaking/database_tables/notes_table.dart';
import 'package:Notetaking/database_tables/users_table.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart'
    show MissingPlatformDirectoryException, getApplicationDocumentsDirectory;
import 'package:path/path.dart';

class NoteService {
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
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectory();
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

    return note;
  }

  Future<void> deleteNote({required int id}) async {
    final db = _getDatabaseOrThrowException();

    final deletedCount = await db.delete(
      notesTable,
      // The question mark value will be passed from the value of whereArgs!!!
      where: 'id = ?',
      whereArgs: [id],
    );

    if (deletedCount == 0) throw CouldNotDeleteNote();
  }

  Future<int> deleteAllNotes() async {
    final db = _getDatabaseOrThrowException();
    return await db.delete(notesTable);
  }

// Get specific note.
  Future<DatabaseNote> getNote({required int id}) async {
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
      return DatabaseNote.fromRow(notes.first);
    }
  }

  // Get all notes.
  Future<Iterable<DatabaseNote>> getAllNotes() async {
    final db = _getDatabaseOrThrowException();
    final notes = await db.query(notesTable);

    return notes.map((noteRow) => DatabaseNote.fromRow(noteRow));
  }

  Future<DatabaseNote> updateNote({
    required DatabaseNote note,
    required String text,
  }) async {
    final db = _getDatabaseOrThrowException();

    // to make sure the note is existing before updating it.
    await getNote(id: note.id);

    final updateCount = await db.update(notesTable, {
      textColumn: text,
      isSyncedWithCloudColumn: 0,
    });

    if (updateCount == 0) {
      throw CouldNotUpdateNote();
    } else {
      // use the getNote to return the note 'which it what it does'.
      return await getNote(id: note.id);
    }
  }
}
