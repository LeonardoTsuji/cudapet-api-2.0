import 'package:cuidapet_api_2/entities/category.dart';

abstract class ICategoriesRepository {
  Future<List<Category>> findAll();
}
