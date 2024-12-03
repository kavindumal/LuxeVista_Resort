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

  // Save user data
  Future<int> saveUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert('Users', user);
  }

  // Get user data
  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await database;
    return await db.query('Users');
  }

  // Save room data
  Future<int> saveRoom(Map<String, dynamic> room) async {
    final db = await database;
    return await db.insert('Rooms', room);
  }

  // Get room data
  Future<List<Map<String, dynamic>>> getRooms() async {
    final db = await database;
    return await db.query('Rooms');
  }

  // Save booking data
  Future<int> saveBooking(Map<String, dynamic> booking) async {
    final db = await database;
    return await db.insert('Bookings', booking);
  }

  // Get booking data
  Future<List<Map<String, dynamic>>> getBookings() async {
    final db = await database;
    return await db.query('Bookings');
  }

  // Save service data
  Future<int> saveService(Map<String, dynamic> service) async {
    final db = await database;
    return await db.insert('Services', service);
  }

  // Get service data
  Future<List<Map<String, dynamic>>> getServices() async {
    final db = await database;
    return await db.query('Services');
  }

  // Save service booking data
  Future<int> saveServiceBooking(Map<String, dynamic> serviceBooking) async {
    final db = await database;
    return await db.insert('Service_Bookings', serviceBooking);
  }

  // Get service booking data
  Future<List<Map<String, dynamic>>> getServiceBookings() async {
    final db = await database;
    return await db.query('Service_Bookings');
  }

  // Save attraction data
  Future<int> saveAttraction(Map<String, dynamic> attraction) async {
    final db = await database;
    return await db.insert('Attractions', attraction);
  }

  // Get attraction data
  Future<List<Map<String, dynamic>>> getAttractions() async {
    final db = await database;
    return await db.query('Attractions');
  }

  // Save notification data
  Future<int> saveNotification(Map<String, dynamic> notification) async {
    final db = await database;
    return await db.insert('Notifications', notification);
  }

  // Get notification data
  Future<List<Map<String, dynamic>>> getNotifications() async {
    final db = await database;
    return await db.query('Notifications');
  }
}
