// lib/widgets/cancel_order_dialog.dart

import 'package:flutter/material.dart';

class CancelOrderDialog extends StatelessWidget {
  final String cartId;
  final Future<void> Function(String cartId) onConfirm;

  CancelOrderDialog({
    required this.cartId,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Xác nhận hủy đơn hàng'),
      content: Text('Bạn có chắc chắn muốn hủy đơn hàng này?'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Hủy'),
        ),
        TextButton(
          onPressed: () async {
            await onConfirm(cartId);
            Navigator.of(context).pop();
          },
          child: Text('Xác nhận'),
        ),
      ],
    );
  }
}
