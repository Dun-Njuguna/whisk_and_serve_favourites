import 'package:whisk_and_serve_core/entities/explore/meal_details.dart';
import 'package:whisk_and_serve_favourites/favourites/domain/repositories/favourites_repository_interface.dart';

class GetFavourites {
  final FavouritesRepositoryInterface repository;

  GetFavourites({required this.repository});

  Future<List<MealDetails>> call() {
    return repository.getFavourites();
  }
}
