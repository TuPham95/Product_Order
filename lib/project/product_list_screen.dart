import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/auth_product.dart';
import '../models/auth_service.dart';
import '../models/cart_provider.dart';
import 'cart_screen.dart';

class ProductListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: Text("Product"),
        actions: [


          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart_outlined, color: Colors.deepOrangeAccent, size: 28,),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CartScreen()),
                  );
                },
              ),
              if (cartProvider.totalQuantity > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      border: Border.all(width: 1, color: Colors.white),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${cartProvider.totalQuantity}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),

          IconButton(
            onPressed: () async {
              Provider.of<AuthService>(context, listen: false).logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: productProvider.products.isEmpty
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 3 / 4,
        ),
        padding: EdgeInsets.all(10),
        itemCount: productProvider.products.length,
        itemBuilder: (context, index) {
          final product = productProvider.products[index];
          return GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) =>
                    ProductDetailDialog(product: product),
              );
            },
            child: GridTile(
              child: product.image != null
                  ? Image.network(product.image!, fit: BoxFit.cover)
                  : Container(color: Colors.grey),
              footer: GridTileBar(
                backgroundColor: Colors.white,
                title: Text(
                  product.title,
                  textAlign: TextAlign.start,
                  style: TextStyle(color: Colors.black),
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '${product.rate}',
                              textAlign: TextAlign.start,
                              style: TextStyle(color: Colors.black),
                            ),
                            SizedBox(width: 5),
                            Icon(Icons.star,
                                color: Colors.orange, size: 16),
                          ],
                        ),
                        Text(
                          "${product.price} \$",
                          textAlign: TextAlign.start,
                          style:
                          TextStyle(color: Colors.deepOrangeAccent),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        int quantity = 1;
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return StatefulBuilder(
                              builder: (BuildContext context,
                                  StateSetter setState) {
                                return Container(
                                  height: 250,
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      topRight: Radius.circular(8),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Xác nhận mua hàng',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        '${product.title} với giá ${product.price} \$?',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(height: 16),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Text(
                                            'Chọn số lượng:',
                                            style:
                                            TextStyle(fontSize: 16),
                                          ),
                                          Row(
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  if (quantity > 1) {
                                                    setState(() {
                                                      quantity--;
                                                    });
                                                  }
                                                },
                                                icon: Icon(Icons.remove),
                                                color: Colors.red,
                                              ),
                                              Text(
                                                '$quantity',
                                                style: TextStyle(
                                                    fontSize: 18),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    quantity++;
                                                  });
                                                },
                                                icon: Icon(Icons.add),
                                                color: Colors.green,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('Hủy'),
                                          ),
                                          Container(
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.teal,
                                                foregroundColor: Colors.white,
                                                padding: EdgeInsets.symmetric(vertical: 6,horizontal: 8),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                )  ,
                                                elevation: 5,
                                              ),

                                              onPressed: () {
                                                cartProvider
                                                    .addToCart(product, quantity);
                                                Navigator.pop(
                                                    context);
                                              },
                                              child: Text('Xác nhận'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        color: Colors.teal,
                        child: Text(
                          'Mua',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


class ProductDetailDialog extends StatelessWidget {
  final AuthProduct product;

  ProductDetailDialog({required this.product});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(product.title),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            product.image != null ? Image.network(product.image!) : Container(),
            SizedBox(height: 16),
            Text(
              "Price: ${product.price}",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 8),
            Text(
              "Category: ${product.category}",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              "Description: ${product.description}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              "Rating: ${product.rate}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              "Count: ${product.count}",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Close'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
