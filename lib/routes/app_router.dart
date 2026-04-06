import 'package:admin_product_app/features/auth/screens/login_screen.dart';
import 'package:admin_product_app/features/product/screens/add_edit_product_screen.dart';
import 'package:admin_product_app/features/product/screens/product_list_screen.dart';
import 'package:go_router/go_router.dart';
final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => LoginScreen(),
    ),

    GoRoute(
      path: '/home',
      builder: (context, state) => ProductListScreen(),
    ),

    // 👉 ADD PRODUCT
    GoRoute(
      path: '/add-product',
      builder: (context, state) => AddEditProductScreen(),
    ),

    // 👉 EDIT PRODUCT
    GoRoute(
      path: '/edit-product',
      builder: (context, state) {
        final product = state.extra as Map<String, dynamic>;
        return AddEditProductScreen(product: product);
      },
    ),
  ],
);