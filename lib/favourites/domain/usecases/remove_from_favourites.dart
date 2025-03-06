import 'package:whisk_and_serve_core/entities/explore/meal_details.dart';
import 'package:whisk_and_serve_favourites/favourites/domain/repositories/favourites_repository_interface.dart';

class RemoveFromFavourites {
  final FavouritesRepositoryInterface repository;

  RemoveFromFavourites({required this.repository});

  Future<bool> call(MealDetails meal) async {
    return await repository.removeFromFavourites(meal);
  }
}
