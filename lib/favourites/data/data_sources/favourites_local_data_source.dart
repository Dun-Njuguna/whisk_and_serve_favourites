import 'package:whisk_and_serve_core/api/network_client.dart';
import 'package:whisk_and_serve_core/entities/explore/meal_details.dart';

abstract class FavouritesLocalDataSource {
  Future<bool> saveRecipe(MealDetails meal);
  Future<bool> deleteRecipe(MealDetails meal);
  Future<bool> checkIfFavourite(String mealId);
  Future<List<MealDetails>> getAllFavourites();
}

class FavouritesLocalDataSourceImpl implements FavouritesLocalDataSource {
  NetworkClient client;

  FavouritesLocalDataSourceImpl({required this.client});

  final Set<MealDetails> _favouriteRecipes = {};

  @override
  Future<bool> saveRecipe(MealDetails meal) async {
    return _favouriteRecipes.add(meal);
  }

  @override
  Future<bool> deleteRecipe(MealDetails meal) async {
    return _favouriteRecipes.remove(meal);
  }

  @override
  Future<bool> checkIfFavourite(String mealId) async {
    return _favouriteRecipes.any((meal) => meal.id == mealId);
  }

  @override
  Future<List<MealDetails>> getAllFavourites() async {
    return _favouriteRecipes.toList();
  }
}
