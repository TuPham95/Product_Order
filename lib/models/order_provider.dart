import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class OrderProvider with ChangeNotifier {
  Future<void> submitOrder(Map<String, dynamic> orderData, String token) async {
    final url = 'https://fakestoreapi.com/carts';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorizatoin": "Bearer $token",
        },
        body: json.encode(orderData),
      );
      if (response.statusCode == 200) {
        notifyListeners();
      } else {
        throw Exception('Failed to place order');
      }
    } catch (error) {
      throw Exception('Failed to connect to the server');
    }
  }
}
