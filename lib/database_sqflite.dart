import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqflite.dart';

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""
    CREATE TABLE catatan(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      judul TEXT,
      deskripsi TEXT,
      topping TEXT,
      total TEXT,
      note TEXT
    )
    """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase('catatan.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  //Tambah Database
  static Future<int> tambahCatatan(String judul, String deskripsi,
      String topping, String total, String note) async {
    final db = await SQLHelper.db();
    final data = {
      'judul': judul,
      'deskripsi': deskripsi,
      'topping': topping,
      'total': total,
      'note': note
    };
    return await db.insert('catatan', data);
  }

  //Ambil Data
  static Future<List<Map<String, dynamic>>> getCatatan() async {
    final db = await SQLHelper.db();
    return db.query('catatan');
  }

  //Ubah Data
  static Future<int> ubahCatatan(int id, String judul, String deskripsi,
      String topping, String total, String note) async {
    final db = await SQLHelper.db();

    final data = {
      'judul': judul,
      'deskripsi': deskripsi,
      'topping': topping,
      'total': total,
      'note': note
    };

    return await db.update('catatan', data, where: "id = $id");
  }

  //Hapus Data
  static Future<void> hapusCatatan(int id) async {
    final db = await SQLHelper.db();
    await db.delete('catatan', where: "id = $id");
  }

  //Hapus Database
  Future<void> deleteDatabase(String path) =>
      databaseFactory.deleteDatabase(path);
}
