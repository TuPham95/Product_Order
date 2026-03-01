import 'package:dequy/models/auth_cart.dart';
import 'package:dequy/models/auth_service.dart';
import 'package:dequy/models/order_provider.dart';
import 'package:dequy/project/login_screen.dart';
import 'package:dequy/project/pay_screen.dart';
import 'package:dequy/project/product_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/auth_product.dart';
import 'models/auth_profile.dart';
import 'models/cart_provider.dart';
import 'project/navigationBar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authService = AuthService();
  await authService.tryAutoLogin();
  runApp(MyApp(authService: authService));
}

class MyApp extends StatelessWidget {
  final AuthService authService;

  const MyApp({Key? key, required this.authService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const seedColor = Color(0xFF0D9488);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authService),
        ChangeNotifierProvider(create: (context) => ProductProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => OrderProvider()),
        ChangeNotifierProvider(create: (context) => AuthCart()),
        ChangeNotifierProvider(create: (context) => UserProfileProvider()),
      ],
      child: Consumer<AuthService>(
        builder: (context, auth, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Sale Application',
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
              fontFamily: 'Roboto',
              textTheme: const TextTheme(
                headlineSmall: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
                titleLarge: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
                titleMedium: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                bodyLarge: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
                bodyMedium: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 1.35,
                ),
              ),
              scaffoldBackgroundColor: const Color(0xFFF3F6F8),
              appBarTheme: const AppBarTheme(
                centerTitle: false,
                backgroundColor: Colors.transparent,
                foregroundColor: Color(0xFF0F172A),
                elevation: 0,
                surfaceTintColor: Colors.transparent,
                titleTextStyle: TextStyle(
                  color: Color(0xFF0F172A),
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              cardTheme: CardThemeData(
                color: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: seedColor, width: 1.5),
                ),
              ),
            ),
            home: auth.token == null ? const LoginScreen() : MainScreen(),
            routes: {
              '/navBar': (context) => MainScreen(),
              '/login': (context) => const LoginScreen(),
              '/products': (context) => ProductListScreen(),
              '/pay': (context) => PayScreen(),
            },
          );
        },
      ),
    );
  }
}
