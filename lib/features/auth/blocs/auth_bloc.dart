import 'package:admin_product_app/features/auth/blocs/auth_event.dart';
import 'package:admin_product_app/features/auth/blocs/auth_state.dart';
import 'package:admin_product_app/features/auth/data/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc(this.repository) : super(AuthInitial()) {
    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        await repository.login(event.email, event.password);
        emit(AuthSuccess());
      } on FirebaseAuthException catch (e) {
        final message = switch (e.code) {
          'user-not-found'        => 'Email hoặc mật khẩu không đúng',
          'wrong-password'        => 'Email hoặc mật khẩu không đúng',
          'invalid-credential'    => 'Email hoặc mật khẩu không đúng',
          'invalid-email'         => 'Email không hợp lệ',
          'user-disabled'         => 'Tài khoản đã bị vô hiệu hóa',
          'too-many-requests'     => 'Quá nhiều lần thử, vui lòng thử lại sau',
          _                       => 'Đăng nhập thất bại, vui lòng thử lại',
        };
        emit(AuthError(message));
      } catch (e) {
        emit(AuthError('Đã có lỗi xảy ra, vui lòng thử lại'));
      }
    });

    on<LogoutEvent>((event, emit) async {
      emit(AuthLoading());
      await repository.logout();
      emit(AuthInitial());
    });

    on<ForgotPasswordEvent>((event, emit) async {
      await repository.forgotPassword(event.email);
    });
  }
}