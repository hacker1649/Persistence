import 'dart:io';
import 'dart:convert';

class AppService{
  static AppService? _instance;
  factory AppService(){
    if (_instance==null){
      throw Exception("Initialise the Singleton Object");
    }
    return _instance!;
  }
  AppService._privateConstructor();
  static void init(){
    _instance??=AppService._privateConstructor();
  }

  Future<void> saveToFile(String path, Map<String, bool> todos) async {
    final file=File(path);
    if (!await file.exists()) {
      await file.create(recursive: true);
    }
    file.writeAsString(jsonEncode(todos));
  }

  Future<Map<String, bool>> readFromFile(String path) async {
    final file=File(path);
    if (await file.exists()) {
      final todos=await file.readAsString();
      if (todos.isNotEmpty) {
        return Map<String, bool>.from(jsonDecode(todos));
      }
    }
    return {};
  }
}
