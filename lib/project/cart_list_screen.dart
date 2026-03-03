import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/auth_cart.dart';
import '../models/cart_provider.dart';
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
    final unpaidCartProvider = Provider.of<CartProvider>(context);
    final hasUnpaidOrder = unpaidCartProvider.items.isNotEmpty;
    final unpaidTotalQuantity = unpaidCartProvider.totalQuantity;
    final unpaidItemsCount = unpaidCartProvider.items.length;

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
          if (authCart.cart.isEmpty && !hasUnpaidOrder) {
            return const Center(child: Text('Không có dữ liệu đơn hàng'));
          }

          return RefreshIndicator(
            onRefresh: () =>
                Provider.of<AuthCart>(context, listen: false).fetchCarts(),
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 20),
              itemCount: authCart.cart.length + (hasUnpaidOrder ? 1 : 0) + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _OverviewHeader(
                    paidOrderCount: authCart.cart.length,
                    hasUnpaidOrder: hasUnpaidOrder,
                    unpaidTotalQuantity: unpaidTotalQuantity,
                  );
                }

                final listIndex = index - 1;
                if (hasUnpaidOrder && listIndex == 0) {
                  return _UnpaidOrderCard(
                    unpaidTotalQuantity: unpaidTotalQuantity,
                    unpaidItemsCount: unpaidItemsCount,
                    onCheckout: () => Navigator.pushNamed(context, '/pay'),
                  );
                }

                final paidOrderIndex = hasUnpaidOrder ? listIndex - 1 : listIndex;
                final cart = authCart.cart[paidOrderIndex];

                return TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.95, end: 1),
                  duration: Duration(milliseconds: 220 + (paidOrderIndex * 35)),
                  curve: Curves.easeOutBack,
                  builder: (context, value, child) {
                    return Transform.scale(scale: value, child: child);
                  },
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      childrenPadding: const EdgeInsets.fromLTRB(14, 2, 14, 10),
                      leading: Container(
                        height: 44,
                        width: 44,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF14B8A6), Color(0xFF0D9488)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.inventory_2_outlined,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        'Đơn hàng #${cart.id}',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Text('Ngày tạo: ${cart.date}'),
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE6F7F5),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          '${cart.products.length} SP',
                          style: const TextStyle(
                            color: Color(0xFF0F766E),
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0FDF4),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: const Text(
                              'Đã thanh toán',
                              style: TextStyle(
                                color: Color(0xFF166534),
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        ...cart.products.map((product) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 34,
                                  height: 34,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE2E8F0),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.shopping_bag_outlined,
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Sản phẩm ID: ${product.productId}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Text(
                                  'x${product.quantity}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF334155),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                        const SizedBox(height: 4),
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
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _OverviewHeader extends StatelessWidget {
  final int paidOrderCount;
  final bool hasUnpaidOrder;
  final int unpaidTotalQuantity;

  const _OverviewHeader({
    required this.paidOrderCount,
    required this.hasUnpaidOrder,
    required this.unpaidTotalQuantity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [Color(0xFF0F766E), Color(0xFF14B8A6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.receipt_long, color: Colors.white),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tổng quan đơn hàng',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$paidOrderCount đơn đã tạo'
                  '${hasUnpaidOrder ? ' • $unpaidTotalQuantity sản phẩm chờ thanh toán' : ''}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UnpaidOrderCard extends StatelessWidget {
  final int unpaidTotalQuantity;
  final int unpaidItemsCount;
  final VoidCallback onCheckout;

  const _UnpaidOrderCard({
    required this.unpaidTotalQuantity,
    required this.unpaidItemsCount,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xFFFFF7ED), Color(0xFFFFEDD5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          leading: Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFFB923C),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.pending_actions_outlined,
              color: Colors.white,
            ),
          ),
          title: const Text(
            'Đơn hàng chưa thanh toán',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          subtitle: Text('$unpaidItemsCount loại sản phẩm • $unpaidTotalQuantity sản phẩm'),
          trailing: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEA580C),
              foregroundColor: Colors.white,
            ),
            onPressed: onCheckout,
            child: const Text('Thanh toán'),
          ),
        ),
      ),
    );
  }
}
