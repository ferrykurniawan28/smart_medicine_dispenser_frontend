import 'package:sqflite/sqflite.dart';

const String tableUser = 'user';
const String columnId = 'id';
const String columnName = 'name';
const String columnEmail = 'email';
const String columnRole = 'role';
const String columnToken = 'token';

class User {
  int id;
  final String name;
  final String role;
  final String email;
  String? token;

  User({
    required this.id,
    required this.name,
    required this.role,
    required this.email,
    this.token,
  });

  Map<String, Object?> toMap() {
    return {
      columnId: id,
      columnName: name,
      columnRole: role,
      columnEmail: email,
      columnToken: token,
    };
  }

  factory User.fromMap(Map<String, Object?> map) {
    return User(
      id: map[columnId] as int,
      name: map[columnName] as String,
      role: map[columnRole] as String,
      email: map[columnEmail] as String,
      token: map[columnToken] as String?,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      role: json['role'],
      email: json['email'],
      token: json['token'],
    );
  }
}

class ProviderUser {
  late Database localdb;

  Future<void> open(String path) async {
    localdb = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
          create table $tableUser ( 
            $columnId integer primary key autoincrement, 
            $columnName text not null,
            $columnRole text not null,
            $columnEmail text not null,
            $columnToken text
          )
        ''');
    });
  }

  // insert or update user
  Future<void> insertOrUpdate(User user) async {
    await localdb.delete(tableUser);

    await localdb.insert(
      tableUser,
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace, // Replaces existing record
    );
  }

  Future<User?> getUser() async {
    List<Map<String, Object?>> maps = await localdb.query(
      tableUser,
      columns: [columnId, columnName, columnRole, columnEmail, columnToken],
      limit: 1, // Get only the first user
    );
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<int> delete(int id) async {
    return await localdb
        .delete(tableUser, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(User user) async {
    return await localdb.update(tableUser, user.toMap(),
        where: '$columnId = ?', whereArgs: [user.id]);
  }

  Future close() async => localdb.close();

  Future<void> reset() async {
    await localdb.delete(tableUser);
  }
}
