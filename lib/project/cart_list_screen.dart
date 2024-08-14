import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/auth_cart.dart';

class CartListScreen extends StatefulWidget {
  @override
  _CartListScreenState createState() => _CartListScreenState();
}

class _CartListScreenState extends State<CartListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<AuthCart>(context, listen: false).fectchCarts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách giỏ hàng'),
      ),
      body: Consumer<AuthCart>(
        builder: (context, authCart, child) {
          if (authCart.isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (authCart.errorMessage.isNotEmpty) {
            return Center(
              child: Text(
                authCart.errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            );
          }
          if (authCart.cart.isEmpty) {
            return Center(
              child: Text('Không có dữ liệu'),
            );
          }
          return ListView.builder(
            itemCount: authCart.cart.length,
            itemBuilder: (context, index) {
              final cart = authCart.cart[index];
              return Card(
                elevation: 4.0,
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ExpansionTile(
                  title: Text(
                    'Giỏ hàng #${cart.id}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Ngày: ${cart.date}'),
                  trailing: Text(
                    'Sản phẩm: ${cart.products.length}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  children: cart.products.map((product) {
                    return ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      title: Text('Sản phẩm ID: ${product.productId}'),
                      subtitle: Text('Số lượng: ${product.quantity}'),
                    );
                  }).toList(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
