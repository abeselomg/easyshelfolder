import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPref {
  read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    var result = prefs.getString(key);
    return result != null ? jsonDecode(result): result;
  }

  Future<String> readStr(String key) async {
    final prefs = await SharedPreferences.getInstance();
    var result = prefs.getString(key);
    return result;
  }

  readBool(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  checkIfAuthenticated() async {
    await Future.delayed(Duration(seconds: 2));  // could be a long running task, like a fetch from keychain
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLogged = prefs.getBool('isLoggedIn') ?? false;
    return isLogged;
  }

  save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, jsonEncode(value));
  }

  saveString(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  setLoggedIn(String key,bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  reload() async{
    final prefs = await SharedPreferences.getInstance();
    prefs.reload();
  }
}