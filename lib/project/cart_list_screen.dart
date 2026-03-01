import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/auth_cart.dart';
import '../widgets/cancel_order_dialog.dart';
import '../widgets/skeleton_loader.dart';

class CartListScreen extends StatefulWidget {
  const CartListScreen({Key? key}) : super(key: key);

  @override
  State<CartListScreen> createState() => _CartListScreenState();
}

class _CartListScreenState extends State<CartListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<AuthCart>(context, listen: false).fetchCarts(),
    );
  }

  void _showCancelOrderDialog(BuildContext context, String cartId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CancelOrderDialog(
          cartId: cartId,
          onConfirm: (id) async {
            await Provider.of<AuthCart>(context, listen: false).deleteOrder(id);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch sử đơn hàng'),
      ),
      body: Consumer<AuthCart>(
        builder: (context, authCart, child) {
          if (authCart.isLoading) {
            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 20),
              itemCount: 4,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: const Padding(
                    padding: EdgeInsets.all(14),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SkeletonBox(height: 40, width: 40, radius: 10),
                            SizedBox(width: 12),
                            Expanded(
                              child: SkeletonBox(
                                height: 14,
                                width: double.infinity,
                                radius: 8,
                              ),
                            ),
                            SizedBox(width: 10),
                            SkeletonBox(height: 14, width: 36, radius: 8),
                          ],
                        ),
                        SizedBox(height: 10),
                        SkeletonBox(
                          height: 12,
                          width: double.infinity,
                          radius: 8,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          if (authCart.errorMessage.isNotEmpty) {
            return Center(
              child: Text(
                authCart.errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          if (authCart.cart.isEmpty) {
            return const Center(child: Text('Không có dữ liệu đơn hàng'));
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 20),
            itemCount: authCart.cart.length,
            itemBuilder: (context, index) {
              final cart = authCart.cart[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ExpansionTile(
                  tilePadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  childrenPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  leading: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6F7F5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.inventory_2_outlined,
                      color: Color(0xFF0D9488),
                    ),
                  ),
                  title: Text(
                    'Đơn hàng #${cart.id}',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text('Ngày tạo: ${cart.date}'),
                  trailing: Text(
                    '${cart.products.length} SP',
                    style: const TextStyle(
                      color: Color(0xFF475569),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  children: [
                    ...cart.products.map((product) {
                      return ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.shopping_bag_outlined),
                        title: Text('Sản phẩm ID: ${product.productId}'),
                        subtitle: Text('Số lượng: ${product.quantity}'),
                      );
                    }),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          _showCancelOrderDialog(context, cart.id);
                        },
                        icon: const Icon(Icons.cancel_outlined),
                        label: const Text('Hủy đơn hàng'),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
