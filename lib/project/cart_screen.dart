import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_provider.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);


    double totalAmount = cartProvider.items.entries.fold(0, (sum, entry) {
      final product = entry.key;
      final quantity = entry.value;


      final price = double.tryParse(product.price) ?? 0.0;

      return sum + (price * quantity);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: cartProvider.items.isEmpty
          ? Center(child: Text('No items in cart'))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartProvider.items.keys.length,
              itemBuilder: (context, index) {
                final product = cartProvider.items.keys.elementAt(index);
                final quantity = cartProvider.items[product]!;

                return ListTile(
                  leading: product.image != null
                      ? Image.network(product.image!, width: 50, height: 50, fit: BoxFit.cover)
                      : Container(width: 50, height: 50, color: Colors.grey),
                  title: Text(product.title),
                  subtitle: Text('Price: ${product.price} \$\nQuantity: $quantity'),
                  trailing: IconButton(
                    icon: Icon(Icons.remove_circle,color: Colors.red,),
                    onPressed: () {
                      cartProvider.removeFromCart(product);
                    },
                  ),
                );
              },
            ),
          ),
          Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tổng tiền:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${totalAmount.toStringAsFixed(2)} \$',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  )  ,
                  elevation: 5,
                ),
                onPressed: () {
                  cartProvider.clearCart();
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        backgroundColor: Color(0xff39D2C0),
                        content: Text('Mua hàng thành công!')),
                  );
                }, child: Text('Thanh toán'),
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
