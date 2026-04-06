// import 'dart:io';
// import 'package:admin_product_app/core/services/cloudinary_service.dart';
// import 'package:admin_product_app/features/product/blocs/product_bloc.dart';
// import 'package:admin_product_app/features/product/blocs/product_event.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:image_picker/image_picker.dart';
//
// class AddEditProductScreen extends StatefulWidget {
//   final Map<String, dynamic>? product;
//   const AddEditProductScreen({super.key, this.product});
//
//   @override
//   State<AddEditProductScreen> createState() => _AddEditProductScreenState();
// }
//
// class _AddEditProductScreenState extends State<AddEditProductScreen> {
//   final nameController = TextEditingController();
//   final priceController = TextEditingController();
//   final categoryController = TextEditingController();
//
//   File? selectedImage;
//   bool isUploading = false;
//
//   bool get isEdit => widget.product != null;
//
//   @override
//   void initState() {
//     super.initState();
//     if (isEdit) {
//       nameController.text = widget.product!['name'];
//       priceController.text = widget.product!['price'].toString();
//       categoryController.text = widget.product!['category'] ?? "";
//     }
//   }
//
//   Future<void> pickImage() async {
//     final picker = ImagePicker();
//     final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
//     if (picked != null) setState(() => selectedImage = File(picked.path));
//   }
//
//   Future<void> _save() async {
//     final name = nameController.text.trim();
//     final price = double.tryParse(priceController.text.trim());
//     final category = categoryController.text.trim();
//
//     if (name.isEmpty || price == null || category.isEmpty) {
//       _showSnack("Vui lòng điền đầy đủ thông tin");
//       return;
//     }
//
//     setState(() => isUploading = true);
//
//     String? imageUrl;
//     if (selectedImage != null) {
//       imageUrl = await CloudinaryService().uploadImage(selectedImage!);
//     } else if (isEdit) {
//       imageUrl = widget.product!['image'];
//     }
//
//     final data = {"name": name, "price": price, "category": category, "image": imageUrl};
//     final bloc = context.read<ProductBloc>();
//
//     if (isEdit) {
//       bloc.add(UpdateProductEvent(widget.product!['id'], data));
//     } else {
//       bloc.add(AddProductEvent(data));
//     }
//
//     setState(() => isUploading = false);
//     context.pop();
//   }
//
//   void _showSnack(String msg) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(msg, style: const TextStyle(color: Color(0xFFF5F5F0))),
//         backgroundColor: const Color(0xFF1A1A1A),
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         margin: const EdgeInsets.all(16),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0D0D0D),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF0D0D0D),
//         elevation: 0,
//         leading: GestureDetector(
//           onTap: () => context.pop(),
//           child: Container(
//             margin: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               color: const Color(0xFF1A1A1A),
//               borderRadius: BorderRadius.circular(8),
//               border: Border.all(color: const Color(0xFF2A2A2A)),
//             ),
//             child: const Icon(Icons.arrow_back_ios_new_rounded, size: 14, color: Color(0xFF888888)),
//           ),
//         ),
//         title: Text(
//           isEdit ? "Sửa sản phẩm" : "Thêm sản phẩm",
//           style: const TextStyle(
//             fontFamily: 'Georgia',
//             fontSize: 20,
//             fontWeight: FontWeight.w600,
//             color: Color(0xFFF5F5F0),
//           ),
//         ),
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(1),
//           child: Container(height: 1, color: const Color(0xFF1E1E1E)),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Image picker
//             GestureDetector(
//               onTap: pickImage,
//               child: Container(
//                 width: double.infinity,
//                 height: 180,
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF161616),
//                   borderRadius: BorderRadius.circular(14),
//                   border: Border.all(
//                     color: selectedImage != null
//                         ? const Color(0xFFEAA71B)
//                         : const Color(0xFF2A2A2A),
//                     width: 1.5,
//                     style: BorderStyle.solid,
//                   ),
//                 ),
//                 child: _buildImageContent(),
//               ),
//             ),
//
//             const SizedBox(height: 24),
//
//             _buildLabel("TÊN SẢN PHẨM"),
//             const SizedBox(height: 6),
//             _buildTextField(
//               controller: nameController,
//               hint: "e.g. Organic Face Serum",
//               icon: Icons.label_outline_rounded,
//             ),
//
//             const SizedBox(height: 16),
//
//             _buildLabel("LOẠI SẢN PHẨM"),
//             const SizedBox(height: 6),
//             _buildTextField(
//               controller: categoryController,
//               hint: "e.g. Skincare",
//               icon: Icons.category_outlined,
//             ),
//
//             const SizedBox(height: 16),
//
//             _buildLabel("GIÁ (VND)"),
//             const SizedBox(height: 6),
//             _buildTextField(
//               controller: priceController,
//               hint: "0.00",
//               icon: Icons.attach_money_rounded,
//               keyboardType: TextInputType.number,
//             ),
//
//             const SizedBox(height: 32),
//
//             // Save button
//             SizedBox(
//               width: double.infinity,
//               height: 52,
//               child: DecoratedBox(
//                 decoration: BoxDecoration(
//                   gradient: isUploading
//                       ? null
//                       : const LinearGradient(
//                     colors: [Color(0xFFEAA71B), Color(0xFFF5C518)],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   color: isUploading ? const Color(0xFF2A2A2A) : null,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: ElevatedButton(
//                   onPressed: isUploading ? null : _save,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.transparent,
//                     shadowColor: Colors.transparent,
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                   ),
//                   child: isUploading
//                       ? const SizedBox(
//                     width: 20,
//                     height: 20,
//                     child: CircularProgressIndicator(
//                       color: Color(0xFF888888),
//                       strokeWidth: 2,
//                     ),
//                   )
//                       : Text(
//                     isEdit ? "CẬP NHẬT SẢN PHẨM" : "LƯU SẢN PHẨM",
//                     style: const TextStyle(
//                       fontSize: 13,
//                       fontWeight: FontWeight.w700,
//                       color: Color(0xFF0D0D0D),
//                       letterSpacing: 1.5,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildImageContent() {
//     if (selectedImage != null) {
//       return ClipRRect(
//         borderRadius: BorderRadius.circular(14),
//         child: Image.file(selectedImage!, fit: BoxFit.cover),
//       );
//     }
//     if (isEdit && widget.product?['image'] != null) {
//       return ClipRRect(
//         borderRadius: BorderRadius.circular(14),
//         child: Image.network(widget.product!['image'], fit: BoxFit.cover),
//       );
//     }
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         const Icon(Icons.add_photo_alternate_outlined, color: Color(0xFF444444), size: 36),
//         const SizedBox(height: 8),
//         const Text(
//           "Tap to upload photo",
//           style: TextStyle(color: Color(0xFF555555), fontSize: 12),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           "JPG, PNG up to 5MB",
//           style: TextStyle(color: Colors.grey[800], fontSize: 10),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildLabel(String text) {
//     return Text(
//       text,
//       style: const TextStyle(
//         fontSize: 9,
//         letterSpacing: 1.5,
//         color: Color(0xFFEAA71B),
//         fontWeight: FontWeight.w600,
//       ),
//     );
//   }
//
//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String hint,
//     required IconData icon,
//     TextInputType keyboardType = TextInputType.text,
//   }) {
//     return TextField(
//       controller: controller,
//       keyboardType: keyboardType,
//       style: const TextStyle(color: Color(0xFFF5F5F0), fontSize: 14),
//       decoration: InputDecoration(
//         hintText: hint,
//         hintStyle: const TextStyle(color: Color(0xFF444444), fontSize: 13),
//         prefixIcon: Icon(icon, color: const Color(0xFF555555), size: 18),
//         filled: true,
//         fillColor: const Color(0xFF161616),
//         contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: const BorderSide(color: Color(0xFF252525)),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: const BorderSide(color: Color(0xFF252525)),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: const BorderSide(color: Color(0xFFEAA71B), width: 1.5),
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:admin_product_app/core/services/openrouter_service.dart';
import 'package:admin_product_app/core/services/cloudinary_service.dart';
import 'package:admin_product_app/features/product/blocs/product_bloc.dart';
import 'package:admin_product_app/features/product/blocs/product_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class AddEditProductScreen extends StatefulWidget {
  final Map<String, dynamic>? product;
  const AddEditProductScreen({super.key, this.product});

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final categoryController = TextEditingController();

  File? selectedImage;
  bool isUploading = false;
  bool isAnalyzing = false;

  bool get isEdit => widget.product != null;

  @override
  void initState() {
    super.initState();
    if (isEdit) {
      nameController.text = widget.product!['name'];
      priceController.text = widget.product!['price'].toString();
      categoryController.text = widget.product!['category'] ?? "";
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) setState(() => selectedImage = File(picked.path));
  }

  // ← NEW: gọi AI phân tích ảnh
  Future<void> _analyzeWithAI() async {
    if (selectedImage == null) {
      _showSnack("Vui lòng chọn ảnh trước");
      return;
    }
    setState(() => isAnalyzing = true);
    try {
      final suggestion = await OpenRouterService().suggestFromImage(selectedImage!);
      if (suggestion != null) {
        nameController.text = suggestion.name;
        categoryController.text = suggestion.category;
        priceController.text = suggestion.price.toStringAsFixed(0);
        _showSnack("✨ AI đã gợi ý thông tin sản phẩm");
      } else {
        _showSnack("Không thể phân tích ảnh, thử lại");
      }
    } catch (e) {
      _showSnack("Lỗi kết nối AI: $e");
    } finally {
      setState(() => isAnalyzing = false);
    }
  }

  Future<void> _save() async {
    final name = nameController.text.trim();
    final price = double.tryParse(priceController.text.trim());
    final category = categoryController.text.trim();

    if (name.isEmpty || price == null || category.isEmpty) {
      _showSnack("Vui lòng điền đầy đủ thông tin");
      return;
    }

    setState(() => isUploading = true);

    String? imageUrl;
    if (selectedImage != null) {
      imageUrl = await CloudinaryService().uploadImage(selectedImage!);
    } else if (isEdit) {
      imageUrl = widget.product!['image'];
    }

    final data = {"name": name, "price": price, "category": category, "image": imageUrl};
    final bloc = context.read<ProductBloc>();

    if (isEdit) {
      bloc.add(UpdateProductEvent(widget.product!['id'], data));
    } else {
      bloc.add(AddProductEvent(data));
    }

    setState(() => isUploading = false);
    context.pop();
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
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D0D),
        elevation: 0,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF2A2A2A)),
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded, size: 14, color: Color(0xFF888888)),
          ),
        ),
        title: Text(
          isEdit ? "Sửa sản phẩm" : "Thêm sản phẩm",
          style: const TextStyle(
            fontFamily: 'Georgia',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFFF5F5F0),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(0xFF1E1E1E)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image picker
            GestureDetector(
              onTap: pickImage,
              child: Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  color: const Color(0xFF161616),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: selectedImage != null
                        ? const Color(0xFFEAA71B)
                        : const Color(0xFF2A2A2A),
                    width: 1.5,
                  ),
                ),
                child: _buildImageContent(),
              ),
            ),

            // ← NEW: Nút AI gợi ý (chỉ hiện khi có ảnh)
            if (selectedImage != null) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: OutlinedButton.icon(
                  onPressed: isAnalyzing ? null : _analyzeWithAI,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF3A3A3A)),
                    backgroundColor: const Color(0xFF161616),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  icon: isAnalyzing
                      ? const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      color: Color(0xFFEAA71B),
                      strokeWidth: 1.5,
                    ),
                  )
                      : const Icon(Icons.auto_awesome_rounded, size: 16, color: Color(0xFFEAA71B)),
                  label: Text(
                    isAnalyzing ? "Đang phân tích..." : "AI Gợi ý từ ảnh",
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFFEAA71B),
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 24),

            _buildLabel("TÊN SẢN PHẨM"),
            const SizedBox(height: 6),
            _buildTextField(
              controller: nameController,
              hint: "e.g. Organic Face Serum",
              icon: Icons.label_outline_rounded,
            ),

            const SizedBox(height: 16),

            _buildLabel("LOẠI SẢN PHẨM"),
            const SizedBox(height: 6),
            _buildTextField(
              controller: categoryController,
              hint: "e.g. Skincare",
              icon: Icons.category_outlined,
            ),

            const SizedBox(height: 16),

            _buildLabel("GIÁ (VND)"),
            const SizedBox(height: 6),
            _buildTextField(
              controller: priceController,
              hint: "0.00",
              icon: Icons.attach_money_rounded,
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: isUploading
                      ? null
                      : const LinearGradient(
                    colors: [Color(0xFFEAA71B), Color(0xFFF5C518)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  color: isUploading ? const Color(0xFF2A2A2A) : null,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ElevatedButton(
                  onPressed: isUploading ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: isUploading
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Color(0xFF888888),
                      strokeWidth: 2,
                    ),
                  )
                      : Text(
                    isEdit ? "CẬP NHẬT SẢN PHẨM" : "LƯU SẢN PHẨM",
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0D0D0D),
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageContent() {
    if (selectedImage != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Image.file(selectedImage!, fit: BoxFit.cover),
      );
    }
    if (isEdit && widget.product?['image'] != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Image.network(widget.product!['image'], fit: BoxFit.cover),
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.add_photo_alternate_outlined, color: Color(0xFF444444), size: 36),
        const SizedBox(height: 8),
        const Text("Tap to upload photo", style: TextStyle(color: Color(0xFF555555), fontSize: 12)),
        const SizedBox(height: 4),
        Text("JPG, PNG up to 5MB", style: TextStyle(color: Colors.grey[800], fontSize: 10)),
      ],
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Color(0xFFF5F5F0), fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF444444), fontSize: 13),
        prefixIcon: Icon(icon, color: const Color(0xFF555555), size: 18),
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
      ),
    );
  }
}