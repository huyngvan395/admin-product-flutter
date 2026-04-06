import 'package:admin_product_app/core/services/auth_service.dart';
import 'package:admin_product_app/core/services/users_service.dart';

class AuthRepository {
  final AuthService authService;
  final UsersService usersService;

  AuthRepository(this.authService, this.usersService);

  Future<String> login(String email, String password) async {
    final user = await authService.login(email, password);

    final userData = await usersService.getUser(user!.uid);

    if (userData?['role'] != 'admin') {
      throw Exception('Không phải admin');
    }

    return "success";
  }

  Future<void> logout() async {
    await authService.logout();
  }


  Future<void> forgotPassword(String email) async {
    await authService.forgotPassword(email);
  }
}