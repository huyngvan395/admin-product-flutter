import 'package:admin_product_app/features/product/blocs/product_event.dart';
import 'package:admin_product_app/features/product/blocs/product_state.dart';
import 'package:admin_product_app/features/product/data/product_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repo;

  ProductBloc(this.repo) : super(ProductInitial()) {
    on<LoadProductsEvent>((event, emit) async {
      emit(ProductLoading());
      try {
        await emit.forEach(
          repo.getProducts(),
          onData: (snapshot) {
            final products = snapshot.docs.map((doc) {
              return {
                "id": doc.id,
                ...doc.data() as Map<String, dynamic>,
              };
            }).toList();
            return ProductLoaded(products);
          },
          onError: (e, _) => ProductError(e.toString()),
        );
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });

    on<AddProductEvent>((event, emit) async {
      await repo.addProduct(event.data);
      add(LoadProductsEvent());
    });

    on<UpdateProductEvent>((event, emit) async {
      await repo.updateProduct(event.id, event.data);
      add(LoadProductsEvent());
    });

    on<DeleteProductEvent>((event, emit) async {
      await repo.deleteProduct(event.id);
      add(LoadProductsEvent());
    });
  }
}