import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class AuthProduct with ChangeNotifier {
  int? id;
  String title;
  String price;
  String? category;
  String? description;
  String? image;
  String? rate;
  String? count;

  AuthProduct(
      {this.id,
      required this.title,
      required this.price,
      required this.category,
      required this.description,
      required this.image,
      required this.count,
      required this.rate});

  factory AuthProduct.fromJson(Map<String, dynamic> json) {
    return AuthProduct(
      id: json['id'],
      title: json['title'],
      price: json['price'].toString(),
      category: json['category'],
      description: json['description'],
      image: json['image'],
      count: json['rating']['count'].toString(),
      rate: json['rating']['rate'].toString(),
    );
  }
}

class ProductProvider with ChangeNotifier {
  List<AuthProduct> _products = [];

  List<AuthProduct> get products => _products;

  ProductProvider() {
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    String apiUrl = "https://fakestoreapi.com/products";
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      _products =
          jsonResponse.map((post) => AuthProduct.fromJson(post)).toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load products');
    }
  }
}
