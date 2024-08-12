import 'package:flutter/cupertino.dart';
import '../models/auth_product.dart';

class CartProvider with ChangeNotifier {
  Map<AuthProduct, int> _items = {};
  Map<AuthProduct, int> get items => _items;
  int get totalQuantity => _items.values.fold(0, (sum, quantity) => sum + quantity);

  void addToCart(AuthProduct product, int quantity) {
    if (_items.containsKey(product)) {
      _items[product] = _items[product]! + quantity;
    } else {
      _items[product] = quantity;
    }
    notifyListeners();
  }

  void removeFromCart(AuthProduct product) {
    _items.remove(product);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
  void updateQuantity(AuthProduct product, int newQuantity) {
    if (_items.containsKey(product)) {
      _items[product] = newQuantity;
      notifyListeners();
    }
  }
}
