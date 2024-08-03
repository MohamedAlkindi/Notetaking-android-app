import 'package:Notetaking/Constants/crud_constants.dart';

class DatabaseNote {
  final int id;
  final int userId;
  final String text;
  final bool isSyncedWithCloud;

  DatabaseNote({
    required this.id,
    required this.userId,
    required this.text,
    required this.isSyncedWithCloud,
  });

  // Represent a row inside the table.
  DatabaseNote.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userId = map[userIdColumn] as int,
        text = map[textColumn] as String,
        isSyncedWithCloud =
            (map[isSyncedWithCloudColumn] as int) == 1 ? true : false;

  // This one to show the details of the user if I want to.
  @override
  String toString() =>
      "Person details: id = $id, userId = $userId, is Synced = $isSyncedWithCloud, text = $text";

  // Comparing between two objects of the class so overriding the '==' operator, put covariant because u can only use Objects to compare between two things, in this case we're comapring 2 instance of DatabaseUser.
  // My id is equal to the other instance's id.
  @override
  bool operator ==(covariant DatabaseNote other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}
