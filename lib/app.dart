import 'package:admin_product_app/core/services/auth_service.dart';
import 'package:admin_product_app/core/services/products_service.dart';
import 'package:admin_product_app/core/services/users_service.dart';
import 'package:admin_product_app/features/auth/blocs/auth_bloc.dart';
import 'package:admin_product_app/features/auth/data/auth_repository.dart';
import 'package:admin_product_app/features/product/blocs/product_bloc.dart';
import 'package:admin_product_app/features/product/data/product_repository.dart';
import 'package:admin_product_app/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ProductBloc(ProductRepository(ProductsService())),
        ),
        BlocProvider(
          create: (_) => AuthBloc(
            AuthRepository(AuthService(), UsersService()),
          ),
        ),
      ],
      child: MaterialApp.router(
        title: 'Admin Product App',
        debugShowCheckedModeBanner: false,

        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
          ),
          useMaterial3: true,
        ),

        routerConfig: router,
      ),
    );
  }
}