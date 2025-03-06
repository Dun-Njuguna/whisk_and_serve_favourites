import 'package:whisk_and_serve_favourites/favourites/domain/repositories/favourites_repository_interface.dart';

class IsFavourite {
  final FavouritesRepositoryInterface repository;

  IsFavourite({required this.repository});

  Future<bool> call(String mealId) async {
    return await repository.isFavourite(mealId);
  }
}
