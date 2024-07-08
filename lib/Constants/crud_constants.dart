// Creating variables that have the same name as the columns in a table.
// the Id column is for both note and user primary key id.
const idColumn = 'id';
const emailColumn = 'email';
const userIdColumn = 'user_id';
const textColumn = 'text';
const isSyncedWithCloudColumn = 'is_synced_with_cloud';

// variables for the db and tables.
const dbName = 'notesDb.db';
const notesTable = 'note';
const userTable = 'user';

// Tables creation query.
// Creating the user table if it doesn't exist already.
const createUserTable = ''' 
          CREATE TABLE IF NOT EXISTS "user" (
          "id"	INTEGER NOT NULL,
          "email"	TEXT NOT NULL UNIQUE,
          PRIMARY KEY("id" AUTOINCREMENT)
        );
      ''';

// Creating the notes table if it doesn't exist already.
const createNoteTable = ''' 
        CREATE TABLE IF NOT EXISTS "note" (
          "id"	INTEGER NOT NULL,
          "user_id"	INTEGER NOT NULL,
          "text"	TEXT,
          "is_synced_with_cloud"	INTEGER DEFAULT 0,
          FOREIGN KEY("user_id") REFERENCES "user"("id"),
          PRIMARY KEY("id" AUTOINCREMENT)
        );
      ''';
