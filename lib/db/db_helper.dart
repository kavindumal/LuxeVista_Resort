import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'hotel_management.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Users (
        user_id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT UNIQUE,
        password TEXT,
        phone_number TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE Rooms (
        room_id INTEGER PRIMARY KEY AUTOINCREMENT,
        room_type TEXT,
        description TEXT,
        price_per_night REAL,
        availability BOOLEAN
      );
    ''');

    await db.execute('''
      CREATE TABLE Bookings (
        booking_id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        room_id INTEGER,
        check_in_date TEXT,
        check_out_date TEXT,
        status TEXT,
        FOREIGN KEY (user_id) REFERENCES Users(user_id),
        FOREIGN KEY (room_id) REFERENCES Rooms(room_id)
      );
    ''');

    await db.execute('''
      CREATE TABLE Services (
        service_id INTEGER PRIMARY KEY AUTOINCREMENT,
        category TEXT,
        name TEXT,
        description TEXT,
        price REAL,
        availability TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE Service_Bookings (
        service_booking_id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        service_id INTEGER,
        booking_date TEXT,
        booking_time TEXT,
        status TEXT,
        FOREIGN KEY (user_id) REFERENCES Users(user_id),
        FOREIGN KEY (service_id) REFERENCES Services(service_id)
      );
    ''');

    await db.execute('''
      CREATE TABLE Attractions (
        attraction_id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        description TEXT,
        location TEXT,
        image_url TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE Notifications (
        notification_id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        message TEXT,
        status TEXT,
        created_at TEXT,
        FOREIGN KEY (user_id) REFERENCES Users(user_id)
      );
    ''');
  }
}
