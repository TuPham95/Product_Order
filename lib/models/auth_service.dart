import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class AuthService with ChangeNotifier{
  String? _token;

  Future<bool> login(String username, String password ) async{
    final url = Uri.parse('https://fakestoreapi.com/auth/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'password': password})
    );
    if(response.statusCode == 200){
      final data = json.decode(response.body);
      _token = data['token'];
      print(_token);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', _token!); //set token data to the pool data/shared preferences

      notifyListeners(); // notify login succees for the Listener(every widgets)

      return true;
    }
    return false;
  }

  Future<void> logout() async{
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    notifyListeners();
  }

  Future<void> tryAutoLogin() async{
    final prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey('token')){
      return; // khong lam gi ca
    }
    _token = prefs.getString('token');
    notifyListeners();
  }
  String? get token{
    return _token;
  }
}