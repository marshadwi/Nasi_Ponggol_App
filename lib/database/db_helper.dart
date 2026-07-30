import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'ponggol_app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE cart (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nama_makanan TEXT,
            harga INTEGER,
            jumlah INTEGER
          )
        ''');
      },
    );
  }

  // CREATE (Menambah ke Keranjang)
  Future<int> insertCart(Map<String, dynamic> item) async {
    final db = await database;
    
    // Cek apakah item sudah ada di keranjang
    List<Map<String, dynamic>> existing = await db.query(
      'cart',
      where: 'nama_makanan = ?',
      whereArgs: [item['nama_makanan']],
    );

    if (existing.isNotEmpty) {
      // Jika ada, update jumlahnya
      int id = existing.first['id'];
      int jumlahSekarang = existing.first['jumlah'];
      return await db.update(
        'cart',
        {'jumlah': jumlahSekarang + 1},
        where: 'id = ?',
        whereArgs: [id],
      );
    } else {
      // Jika belum ada, masukkan data baru
      return await db.insert('cart', item);
    }
  }

  // READ (Mendapatkan isi Keranjang)
  Future<List<Map<String, dynamic>>> getCart() async {
    final db = await database;
    return await db.query('cart');
  }
  // UPDATE (Mengubah jumlah item)
  Future<int> updateQuantity(int id, int jumlahBaru) async {
    final db = await database;
    if (jumlahBaru <= 0) {
      return await deleteItem(id);
    }
    return await db.update(
      'cart',
      {'jumlah': jumlahBaru},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // DELETE (Menghapus isi Keranjang berdasarkan ID)
  Future<int> deleteItem(int id) async {
    final db = await database;
    return await db.delete(
      'cart',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Hapus semua (setelah checkout)
  Future<void> clearCart() async {
    final db = await database;
    await db.delete('cart');
  }
}
