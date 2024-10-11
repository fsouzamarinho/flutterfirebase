import 'package:shared_preferences/shared_preferences.dart';

class SPUser {
  static const String _uidKey = 'uid';

  // Função para salvar o UID no SharedPreferences
  static Future<void> setUid(String uid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_uidKey, uid);
  }

  // Função para obter o UID do SharedPreferences
  static Future<String?> getUid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_uidKey);
  }

  
}