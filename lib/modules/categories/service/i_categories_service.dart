import 'package:cuidapet_api_2/entities/category.dart';

abstract class ICategoriesService {
  Future<List<Category>> findAll();
}
