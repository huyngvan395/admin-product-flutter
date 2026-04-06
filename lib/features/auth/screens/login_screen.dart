import 'package:admin_product_app/features/auth/blocs/auth_bloc.dart';
import 'package:admin_product_app/features/auth/blocs/auth_event.dart';
import 'package:admin_product_app/features/auth/blocs/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        LoginEvent(emailController.text.trim(), passwordController.text.trim()),
      );
    }
  }

  void _forgotPassword() {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      _showSnack("Vui lòng nhập email trước");
      return;
    }
    context.read<AuthBloc>().add(ForgotPasswordEvent(email));
    _showSnack("Đã gửi email reset mật khẩu ✓");
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(color: Color(0xFFF5F5F0))),
        backgroundColor: const Color(0xFF1A1A1A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) context.go('/home');
          if (state is AuthError) _showSnack(state.message);
        },
        builder: (context, state) {
          return Stack(
            children: [
              // Ambient glow top-right
              Positioned(
                top: -60,
                right: -60,
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [Color(0x40EAA71B), Colors.transparent],
                    ),
                  ),
                ),
              ),

              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Icon
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFEAA71B), Color(0xFFF5C518)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(Icons.layers_rounded, color: Color(0xFF0D0D0D), size: 26),
                          ),

                          const SizedBox(height: 28),

                          const Text(
                            "Chào mừng\ntrở lại, Admin",
                            style: TextStyle(
                              fontFamily: 'Georgia',
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFF5F5F0),
                              height: 1.2,
                            ),
                          ),

                          const SizedBox(height: 6),

                          const Text(
                            "QUẢN LÍ SẢN PHẨM",
                            style: TextStyle(
                              fontSize: 10,
                              letterSpacing: 2.0,
                              color: Color(0xFF666666),
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          const SizedBox(height: 36),

                          // Email field
                          _buildLabel("EMAIL"),
                          const SizedBox(height: 6),
                          _buildField(
                            controller: emailController,
                            hint: "admin@example.com",
                            icon: Icons.alternate_email_rounded,
                            validator: (v) {
                              if (v == null || v.isEmpty) return "Không được để trống";
                              if (!v.contains("@")) return "Email không hợp lệ";
                              return null;
                            },
                          ),

                          const SizedBox(height: 16),

                          // Password field
                          _buildLabel("PASSWORD"),
                          const SizedBox(height: 6),
                          _buildField(
                            controller: passwordController,
                            hint: "••••••••••",
                            icon: Icons.lock_outline_rounded,
                            obscure: _obscurePassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                color: const Color(0xFF555555),
                                size: 18,
                              ),
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) return "Không được để trống";
                              if (v.length < 6) return "Ít nhất 6 ký tự";
                              return null;
                            },
                          ),

                          const SizedBox(height: 28),

                          // Login button
                          state is AuthLoading
                              ? const Center(
                            child: CircularProgressIndicator(color: Color(0xFFEAA71B)),
                          )
                              : SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFEAA71B), Color(0xFFF5C518)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ElevatedButton(
                                onPressed: _login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  "ĐĂNG NHẬP",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF0D0D0D),
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          Align(
                            alignment: Alignment.center,
                            child: TextButton(
                              onPressed: _forgotPassword,
                              child: const Text(
                                "Quên mật khẩu?",
                                style: TextStyle(
                                  color: Color(0xFFEAA71B),
                                  fontSize: 13,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Color(0x66EAA71B),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 9,
        letterSpacing: 1.5,
        color: Color(0xFFEAA71B),
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Color(0xFFF5F5F0), fontSize: 14),
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF444444), fontSize: 13),
        prefixIcon: Icon(icon, color: const Color(0xFF555555), size: 18),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: const Color(0xFF161616),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF252525)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF252525)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFEAA71B), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFF07A7A)),
        ),
      ),
    );
  }
}