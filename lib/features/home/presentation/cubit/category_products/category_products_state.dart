part of 'category_products_cubit.dart';

sealed class CategoryProductsState extends Equatable {
  const CategoryProductsState();

  @override
  List<Object?> get props => [];
}

class CategoryProductsInitial extends CategoryProductsState {
  const CategoryProductsInitial();
}

class CategoryProductsLoading extends CategoryProductsState {
  const CategoryProductsLoading();
}

class CategoryProductsLoaded extends CategoryProductsState {
  final List<ProductEntity> products;
  final String categoryId;

  const CategoryProductsLoaded({
    required this.products,
    required this.categoryId,
  });

  @override
  List<Object?> get props => [products, categoryId];
}

class CategoryProductsError extends CategoryProductsState {
  final String message;
  const CategoryProductsError(this.message);

  @override
  List<Object?> get props => [message];
}
