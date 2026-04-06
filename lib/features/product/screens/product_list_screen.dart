import 'package:admin_product_app/features/auth/blocs/auth_bloc.dart';
import 'package:admin_product_app/features/auth/blocs/auth_event.dart';
import 'package:admin_product_app/features/auth/blocs/auth_state.dart';
import 'package:admin_product_app/features/product/blocs/product_bloc.dart';
import 'package:admin_product_app/features/product/blocs/product_event.dart';
import 'package:admin_product_app/features/product/blocs/product_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(LoadProductsEvent());
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Text(
          "Đăng xuất?",
          style: TextStyle(color: Color(0xFFF5F5F0)),
        ),
        content: const Text(
          "Bạn sẽ được chuyển về màn hình đăng nhập.",
          style: TextStyle(color: Color(0xFF888888)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Hủy",
              style: TextStyle(color: Color(0xFF666666)),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(LogoutEvent());
            },
            child: const Text(
              "Đăng xuất",
              style: TextStyle(color: Color(0xFFEAA71B)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
          context.go('/');
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0D0D0D),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0D0D0D),
          elevation: 0,
          centerTitle: false,
          title: const Text(
            "Danh sách sản phẩm",
            style: TextStyle(
              fontFamily: 'Georgia',
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Color(0xFFF5F5F0),
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(height: 1, color: const Color(0xFF1E1E1E)),
          ),
          actions: [
            BlocBuilder<ProductBloc, ProductState>(
              builder: (_, state) {
                if (state is ProductLoaded) {
                  return Container(
                    margin: const EdgeInsets.only(right: 16),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAA71B),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "${state.products.length} sản phẩm",
                      style: const TextStyle(
                        color: Color(0xFF0D0D0D),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
            GestureDetector(
              onTap: _logout,
              child: Container(
                margin: const EdgeInsets.only(right: 16),
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFF2A1818),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: Color(0xFFF07A7A),
                  size: 16,
                ),
              ),
            ),
          ],
        ),
        body: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFFEAA71B)),
              );
            }

            if (state is ProductLoaded) {
              final products = state.products;

              if (products.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inbox_outlined,
                        size: 52,
                        color: Colors.grey[700],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "No products yet",
                        style: TextStyle(color: Colors.grey[600], fontSize: 15),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final p = products[index];
                  return _ProductCard(
                    product: p,
                    onTap: () => context.push('/edit-product', extra: p),
                    onDelete: () => context.read<ProductBloc>().add(
                      DeleteProductEvent(p['id']),
                    ),
                  );
                },
              );
            }

            if (state is ProductError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Color(0xFFF07A7A)),
                ),
              );
            }

            return const SizedBox();
          },
        ),
        floatingActionButton: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFEAA71B), Color(0xFFF5C518)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFEAA71B).withOpacity(0.35),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: FloatingActionButton(
            onPressed: () => context.push('/add-product'),
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: const Icon(
              Icons.add_rounded,
              color: Color(0xFF0D0D0D),
              size: 26,
            ),
          ),
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _ProductCard({
    required this.product,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final p = product;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF161616),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF242424)),
        ),
        child: Row(
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: p['image'] != null
                  ? Image.network(
                      p['image'],
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _placeholder(),
                    )
                  : _placeholder(),
            ),

            const SizedBox(width: 14),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p['name'] ?? "",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFF5F5F0),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    p['category'] ?? "Uncategorized",
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF666666),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "${p['price']}VND",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFEAA71B),
                    ),
                  ),
                ],
              ),
            ),

            // Actions
            Column(
              children: [
                _ActionBtn(
                  icon: Icons.edit_outlined,
                  color: const Color(0xFF7AB3F0),
                  bg: const Color(0xFF1E2230),
                  onTap: onTap,
                ),
                const SizedBox(height: 6),
                _ActionBtn(
                  icon: Icons.delete_outline_rounded,
                  color: const Color(0xFFF07A7A),
                  bg: const Color(0xFF2A1818),
                  onTap: () => _confirmDelete(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 60,
      height: 60,
      color: const Color(0xFF1E1E1E),
      child: const Icon(
        Icons.image_outlined,
        color: Color(0xFF444444),
        size: 24,
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Text(
          "Xóa sản phẩm?",
          style: TextStyle(color: Color(0xFFF5F5F0)),
        ),
        content: const Text(
          "Hành động này không thể hoàn tác.",
          style: TextStyle(color: Color(0xFF888888)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Hủy",
              style: TextStyle(color: Color(0xFF666666)),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onDelete();
            },
            child: const Text(
              "Xóa",
              style: TextStyle(color: Color(0xFFF07A7A)),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color bg;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.icon,
    required this.color,
    required this.bg,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 15),
      ),
    );
  }
}
