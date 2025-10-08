import 'package:laza/features/home/domain/entities/product_entity.dart';
import 'package:laza/features/home/domain/repositories/product_repository.dart';

class GetProductsByCategoryUseCase {
  final ProductRepository repository;

  GetProductsByCategoryUseCase(this.repository);

  Future<List<ProductEntity>> call(String categoryId) async {
    return await repository.getProductsByCategory(categoryId);
  }
}
