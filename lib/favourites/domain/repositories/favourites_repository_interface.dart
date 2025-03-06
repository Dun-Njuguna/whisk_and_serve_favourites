import 'package:whisk_and_serve_core/entities/explore/meal_details.dart';

abstract class FavouritesRepositoryInterface {
  Future<bool> addToFavourites(MealDetails meal);
  Future<bool> removeFromFavourites(MealDetails meal);
  Future<bool> isFavourite(String mealId);
  Future<List<MealDetails>> getFavourites();
}
