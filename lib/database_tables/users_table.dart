import 'package:Notetaking/Constants/crud_constants.dart';

class DatabaseUser {
  final int id;
  final String email;

  DatabaseUser({
    required this.id,
    required this.email,
  });

  // Represent a row inside the table.
  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColumn] as String;

  // This one to show the details of the user if I want to.
  @override
  String toString() => "Person details: id = $id, email = $email";

  // Comparing between two objects of the class so overriding the '==' operator, put covariant because u can only use Objects to compare between two things, in this case we're comapring 2 instance of DatabaseUser.
  // My id is equal to the other instance's id.
  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}
