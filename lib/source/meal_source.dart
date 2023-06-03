import 'package:responsi_123190162_mealdb/base_network/mealdb_api.dart';

class MealSource {
  static MealSource instance = MealSource();

  Future<Map<String, dynamic>> loadCategories(){
    return BaseNetwork.get("categories.php");
  }

  Future<Map<String, dynamic>> loadByCategory({required String category}){
    return BaseNetwork.get("filter.php?c=$category");
  }

  Future<Map<String, dynamic>> loadDetail({required String idMeal}){
    return BaseNetwork.get("lookup.php?i=$idMeal");
  }
}