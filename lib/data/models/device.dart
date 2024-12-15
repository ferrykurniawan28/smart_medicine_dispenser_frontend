import 'package:smart_dispencer/data/models/container.dart';
import 'package:sqflite/sqflite.dart';

const String tableDevices = 'device';
const String columnId = 'id';
const String columnUserId = 'user_id';
const String columnUid = 'uid';
const String columnCurrentState = 'currentState';
const String columnTemperature = 'temperature';
const String columnStatus = 'status';

class Devices {
  int? id;
  int userId;
  final String uid;
  int currentState = 0;
  String? status;
  double? temperature;
  List<MedicineContainer>? containers;

  Devices({
    this.id,
    required this.userId,
    required this.uid,
    this.currentState = 0,
    this.status,
    this.temperature,
    this.containers,
  });

  factory Devices.fromJson(Map<String, dynamic> json) {
    return Devices(
      id: json['id'],
      userId: json['user_id'],
      uid: json['uid'],
      currentState: json['current_state'],
      status: json['status'],
      temperature: json['temperature'] as double?,
      containers: MedicineContainer.fromJsonList(json['device_content']),
    );
  }

  Map<String, Object?> toMap() {
    return {
      columnId: id,
      columnUserId: userId,
      columnUid: uid,
      columnCurrentState: currentState,
      columnTemperature: temperature,
      columnStatus: status,
    };
  }

  factory Devices.fromMap(Map<String, Object?> map) {
    return Devices(
      id: map[columnId] as int?,
      userId: map[columnUserId] as int,
      uid: map[columnUid] as String,
      currentState: map[columnCurrentState] as int,
      temperature: map[columnTemperature] as double?,
      status: map[columnStatus] as String?,
    );
  }
}

class ProviderDevice {
  late Database localdb;

  Future<void> open(String path) async {
    localdb = await openDatabase(
      path,
      version: 3,
      onCreate: (Database db, int version) async {
        await db.execute('DROP TABLE IF EXISTS $tableDevices');
        await db.execute('''
            CREATE TABLE $tableDevices (
              $columnId INTEGER PRIMARY KEY,
              $columnUserId INTEGER NOT NULL,
              $columnUid TEXT NOT NULL,
              $columnCurrentState INTEGER,
              $columnTemperature INTEGER,
              $columnStatus TEXT
            )
            ''');
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        if (oldVersion < newVersion) {
          await db.execute('DROP TABLE IF EXISTS $tableDevices');
          await db.execute('''
            CREATE TABLE $tableDevices (
              $columnId INTEGER PRIMARY KEY,
              $columnUserId INTEGER NOT NULL,
              $columnUid TEXT NOT NULL,
              $columnCurrentState INTEGER,
              $columnTemperature INTEGER,
              $columnStatus TEXT
            )
            ''');
        }
      },
    );
    // var result = await localdb.rawQuery("PRAGMA table_info($tableDevices);");
    // print("Table Schema: $result");
  }

  Future<Devices> insert(Devices device) async {
    await localdb.delete(tableDevices);

    device.id = await localdb.insert(tableDevices, device.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    return device;
  }

  Future<Devices?> getDevice() async {
    List<Map<String, Object?>> maps = await localdb.query(
      tableDevices,
      columns: [
        columnId,
        columnUserId,
        columnUid,
        columnCurrentState,
        columnTemperature,
        columnStatus,
      ],
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return Devices.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> delete(String uid) async {
    return await localdb
        .delete(tableDevices, where: '$columnUid = ?', whereArgs: [uid]);
  }

  Future<int> update(Devices device) async {
    return await localdb.update(tableDevices, device.toMap(),
        where: '$columnId = ?', whereArgs: [device.id]);
  }

  Future close() async => localdb.close();

  Future<void> reset() async {
    await localdb.delete(tableDevices);
  }
}
