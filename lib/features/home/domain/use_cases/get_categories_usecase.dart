import 'package:laza/features/home/domain/entities/category_entity.dart';
import 'package:laza/features/home/domain/repositories/product_repository.dart';

class GetCategoriesUseCase {
  final ProductRepository repository;

  GetCategoriesUseCase(this.repository);

  Future<List<CategoryEntity>> call() async {
    return await repository.getCategories();
  }
}
