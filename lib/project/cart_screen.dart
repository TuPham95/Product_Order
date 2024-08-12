import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_provider.dart';

class CartScreen extends StatefulWidget {
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    // Tính tổng số tiền
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
                      ? Image.network(
                    product.image!,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  )
                      : Container(
                    width: 50,
                    height: 50,
                    color: Colors.grey,
                  ),
                  title: Text(product.title),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${product.price} \$',
                        style: TextStyle(fontWeight: FontWeight.bold,color: Colors.deepOrangeAccent),),
                      Row(

                        children: [

                          SizedBox(width: 10),
                          IconButton(
                            onPressed: () {
                              if (quantity > 1) {
                                setState(() {
                                  cartProvider.updateQuantity(
                                      product, quantity - 1);
                                });
                              }
                            },
                            icon: Icon(Icons.remove),
                          ),
                          Text('$quantity'),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                cartProvider.updateQuantity(
                                    product, quantity + 1);
                              });
                            },
                            icon: Icon(Icons.add),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.remove_circle,
                      color: Colors.red,
                    ),
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
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${totalAmount.toStringAsFixed(2)} \$',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
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
                  ),
                  elevation: 5,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/pay');
                },
                child: Text('Thanh toán'),
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
