abstract class ProductEvent {}

class LoadProductsEvent extends ProductEvent {}

class AddProductEvent extends ProductEvent {
  final Map<String, dynamic> data;
  AddProductEvent(this.data);
}

class UpdateProductEvent extends ProductEvent {
  final String id;
  final Map<String, dynamic> data;
  UpdateProductEvent(this.id, this.data);
}

class DeleteProductEvent extends ProductEvent {
  final String id;
  DeleteProductEvent(this.id);
}