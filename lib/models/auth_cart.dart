import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_service.dart'; // Nếu cần thiết

class AuthCart with ChangeNotifier {
  List<Cart> _cart = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Cart> get cart => _cart;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchCarts() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if (userId == null) {
      _errorMessage = 'User ID is not found';
      _isLoading = false;
      notifyListeners();
      return;
    }

    final String apiUrl = 'https://fakestoreapi.com/carts/user/$userId';
    // print('Fetching carts from: $apiUrl');

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        _cart = data.map((json) => Cart.fromJson(json)).toList();
      } else {
        _errorMessage = 'Failed to load cart. Status code: ${response.statusCode}';
      }
    } catch (error) {
      _errorMessage = 'An error occurred: $error';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteOrder(String cartId) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    final String apiUrl = 'https://fakestoreapi.com/carts/$cartId';
    print('Deleting order from: $apiUrl');

    try {
      final response = await http.delete(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // Remove the cart item from the local list
        _cart.removeWhere((cart) => cart.id == cartId);
        _errorMessage = 'Order successfully deleted';
      } else {
        _errorMessage = 'Failed to delete order. Status code: ${response.statusCode}';
      }
    } catch (error) {
      _errorMessage = 'An error occurred: $error';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

class Cart {
  final String id;
  final String userId;
  final String date;
  final List<Product> products;

  Cart({
    required this.id,
    required this.userId,
    required this.date,
    required this.products,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    var productsFromJson = json['products'] as List;
    List<Product> products = productsFromJson.map((i) => Product.fromJson(i)).toList();
    return Cart(
      id: json['id'].toString(),
      userId: json['userId'].toString(),
      date: json['date'],
      products: products,
    );
  }
}

class Product {
  final String productId;
  final String quantity;

  Product({
    required this.productId,
    required this.quantity,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['productId'].toString(),
      quantity: json['quantity'].toString(),
    );
  }
}
