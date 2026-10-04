import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/item_model.dart';

class InventoryDBHelper {
  static final instance=InventoryDBHelper._(); static Database? _database; InventoryDBHelper._();
  Future<Database> get database async=>_database ??=await _init('accountant_pro_inventory.db');
  Future<Database> _init(String name) async{final path=join(await getDatabasesPath(),name);return openDatabase(path,version:1,onCreate:(db,v)async{
    await db.execute('''CREATE TABLE items(id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT NOT NULL,category TEXT NOT NULL,barcode TEXT,sell_price REAL NOT NULL,cost_price REAL NOT NULL DEFAULT 0,quantity INTEGER NOT NULL DEFAULT 0,image_path TEXT,expiry_date TEXT,notes TEXT)''');
    await db.execute('CREATE INDEX idx_items_name ON items(name)'); await db.execute('CREATE INDEX idx_items_barcode ON items(barcode)'); await db.execute('CREATE INDEX idx_items_category ON items(category)');
  });}
  Future<int> insertItem(ItemModel x)async=>(await database).insert('items',x.toMap());
  Future<List<ItemModel>> getAllItems()async{final r=await (await database).query('items',orderBy:'id DESC');return r.map(ItemModel.fromMap).toList();}
  Future<int> updateItem(ItemModel x)async=>(await database).update('items',x.toMap(),where:'id=?',whereArgs:[x.id]);
  Future<int> deleteItem(int id)async=>(await database).delete('items',where:'id=?',whereArgs:[id]);
}