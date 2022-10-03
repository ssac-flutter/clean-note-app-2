import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';
import 'di_setup.config.dart';

// @singleton, injectabl 어노테니션 설정 후
// 'di_setup.config.dart' 수동 임포트 후 build_runner 실행

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  Database database = await openDatabase(
    'note_db',
    version: 1,
    onCreate: (db, version) async {
      await db.execute('''
      CREATE TABLE note (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        content TEXT,
        color INTEGER,
        timestamp INTEGER
    )
      ''');
    },
  );
  getIt.registerSingleton(database);
  $initGetIt(getIt);
}
