import 'dart:math';

import 'package:dequy/models/cart_provider.dart';
import 'package:dequy/models/order_provider.dart';
import 'package:dequy/widgets/CartItemWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/auth_service.dart';

class PayScreen extends StatefulWidget {
  @override
  State<PayScreen> createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _address = '';
  String _phone = '';
  bool _isLoading = false;

  void _submitOrder() async{
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      final products = cartProvider.items.entries.map((entry){
        return {
          "productId": entry.key.id,
          "quantity": entry.value,
        };
        }).toList();
      DateTime now = DateTime.now();
      String formattedDate = '${now.year}-${now.month}-${now.day}';
      var random = Random();
      int randomNumber = random.nextInt(1<<32);
      final orderData = {
      "userId": randomNumber,
        "date": formattedDate,
        "products": products
      };
      print(formattedDate);
      String token = Provider.of<AuthService>(context, listen: false).token as String;
    setState(() {
      _isLoading = true;
    });
      try{
        await orderProvider.submitOrder(orderData,token);
        cartProvider.clearCart();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Color(0xff39D2C0),
          content: Text('Mua hàng thành công'),
        ));
        Navigator.pushReplacementNamed(context, '/navBar');
      }
      catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text('Có lỗi xảy ra. Vui lòng thử lại.'),
        ));
      }finally{
        setState(() {
          _isLoading = false;
        });
      }
  }
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
        title: Text('Thanh toán'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Name',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _name = value!;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Address',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your address';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _address = value!;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Phone',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _phone = value!;
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Divider(),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: cartProvider.items.keys.length,
                    itemBuilder: (context, index) {
                      final cartItem = cartProvider.items.keys.elementAt(index);
                      final quantity = cartProvider.items[cartItem]!;
                      return Cartitemwidget(
                        image: cartItem.image!,
                        title: cartItem.title,
                        price: cartItem.price,
                        quantity: quantity,
                      );
                    },
                  ),
                  Divider(),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${totalAmount.toStringAsFixed(2)}',

                      style: TextStyle(
                        color: Theme.of(context).primaryTextTheme.titleLarge?.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  SizedBox(width: 8,),
                  Container(
                    // width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 6,horizontal: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        )  ,
                        elevation: 5,
                      ),
                      onPressed: _submitOrder,
                      child: _isLoading
                          ? CircularProgressIndicator(color: Colors.white, strokeWidth: 2,)
                          : Text('PAY NOW'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
