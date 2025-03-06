import 'package:whisk_and_serve_core/entities/explore/meal_details.dart';
import 'package:whisk_and_serve_favourites/favourites/data/data_sources/favourites_local_data_source.dart';
import 'package:whisk_and_serve_favourites/favourites/domain/repositories/favourites_repository_interface.dart';

class FavouritesRepositoryImpl implements FavouritesRepositoryInterface {
  final FavouritesLocalDataSource localDataSource;

  FavouritesRepositoryImpl({required this.localDataSource});

  @override
  Future<bool> addToFavourites(MealDetails meal) {
    return localDataSource.saveRecipe(meal);
  }

  @override
  Future<bool> removeFromFavourites(MealDetails meal) {
    return localDataSource.deleteRecipe(meal);
  }

  @override
  Future<bool> isFavourite(String mealId) {
    return localDataSource.checkIfFavourite(mealId);
  }

  @override
  Future<List<MealDetails>> getFavourites() {
    return localDataSource.getAllFavourites();
  }
}
