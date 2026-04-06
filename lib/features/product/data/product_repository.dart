import 'package:admin_product_app/core/services/products_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductRepository {
  final ProductsService productsService;

  ProductRepository(this.productsService);

  Future<void> addProduct(Map<String, dynamic> data) async {
    await productsService.addProduct(data);
  }

  Future<void> updateProduct(String id, Map<String, dynamic> data) async {
    await productsService.updateProduct(id, data);
  }

  Future<void> deleteProduct(String id) async {
    await productsService.deleteProduct(id);
  }

  Stream<QuerySnapshot> getProducts() {
    return productsService.getProducts();
  }
}
