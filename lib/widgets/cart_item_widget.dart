import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Cartitemwidget extends StatelessWidget {
 // final int id;
 final String title;
final int quantity;
 final String price;
 final String image;

 Cartitemwidget({
   // required this.id,
   required this.title,
   required  this.price,
   required this.quantity,
   required this.image,
});

  @override
  Widget build(BuildContext context) {
    final double parsedPrice = double.parse(price);
    // final int parsedQuantity = int.parse(quantity);
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: ListTile(
          leading: CircleAvatar(
            child: Padding(
              padding: EdgeInsets.all(5),
              child: FittedBox(
                child: Image.network('$image'),
              ),
            ),
          ),
          title: Text(title),
          subtitle: Text('Total: \$${(parsedPrice * quantity).toStringAsFixed(2)}'),
          trailing: Text('$quantity x'),
        ),
      ),
    );
  }
}
