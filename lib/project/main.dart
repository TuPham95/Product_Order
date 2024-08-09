
import 'package:dequy/models/auth_service.dart';
import 'package:dequy/project/login_screen.dart';
import 'package:dequy/project/product_list_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/auth_product.dart';
import '../models/cart_provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();// thuc hien no minh se xem duoc da login chua

  final authService = AuthService();
  await authService.tryAutoLogin();
  runApp(MyApp(authService: authService,));

}
class MyApp extends StatelessWidget{
  final AuthService authService;
  MyApp({required this.authService});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
    ChangeNotifierProvider.value(value: authService),
      ChangeNotifierProvider(create: (context) => ProductProvider(),
      ),
    ChangeNotifierProvider(create: (context) => CartProvider()),
    ],
      child: Consumer<AuthService>(
        builder: (context, auth, _){
          return MaterialApp(
            title: 'Sale Application',
            theme:  ThemeData(primarySwatch: Colors.blue),
            home: auth.token == null ? LoginScreen() : ProductListScreen(),
            routes: {
              '/login' :(context) => LoginScreen(),
              '/products': (context) => ProductListScreen(),
            },
          );
        },
      ),
    );
  }

}