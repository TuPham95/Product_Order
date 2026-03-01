import 'package:flutter/material.dart';

class CancelOrderDialog extends StatelessWidget {
  final String cartId;
  final Future<void> Function(String cartId) onConfirm;

  const CancelOrderDialog({
    Key? key,
    required this.cartId,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Xác nhận hủy đơn hàng'),
      content: const Text('Bạn có chắc chắn muốn hủy đơn hàng này?'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Không'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          onPressed: () async {
            await onConfirm(cartId);
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          },
          child: const Text('Xác nhận'),
        ),
      ],
    );
  }
}
