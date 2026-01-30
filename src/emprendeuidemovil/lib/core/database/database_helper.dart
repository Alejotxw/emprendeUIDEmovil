import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // 1. Instancia Singleton (Solo existirá una copia de la base de datos)
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('TAEK.db');
    return _database!;
  }

  // 2. Inicialización y Configuración
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      // REQUISITO LÍDER: Activar Llaves Foráneas
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  // 3. Creación de Tablas (Relación 1:N)
  Future _createDB(Database db, int version) async {
    // Tabla Padre: Emprendimientos
    await db.execute('''
      CREATE TABLE entrepreneurships (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        owner_name TEXT NOT NULL,
        category TEXT NOT NULL
      )
    ''');

    // Tabla Hijo: Productos/Servicios
    await db.execute('''
      CREATE TABLE items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        price REAL NOT NULL,
        entrepreneurship_id INTEGER NOT NULL,
        -- REQUISITO TÉCNICO: Relación e Integridad
        FOREIGN KEY (entrepreneurship_id) 
          REFERENCES entrepreneurships (id) 
          ON DELETE CASCADE
      )
    ''');
  }

  // 4. Métodos para el Dashboard (Consultas de Agregación)
  // Esto ayudará al Integrante 3 con su tarea
  Future<Map<String, dynamic>> getMarketplaceStats() async {
    final db = await instance.database;
    
    // COUNT: Total productos, SUM: Valor de inventario, AVG: Precio promedio
    final result = await db.rawQuery('''
      SELECT 
        COUNT(*) as totalItems, 
        SUM(price) as inventoryValue, 
        AVG(price) as averagePrice 
      FROM items
    ''');

    if (result.isNotEmpty) {
      return result.first;
    }
    return {'totalItems': 0, 'inventoryValue': 0.0, 'averagePrice': 0.0};
  }

  // Cerrar DB
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}