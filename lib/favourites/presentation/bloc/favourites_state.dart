part of 'favourites_bloc.dart';

@immutable
sealed class FavouritesState {}

final class FavouritesInitial extends FavouritesState {}

final class FavouritesLoading extends FavouritesState {}

final class FavouritesLoaded extends FavouritesState {
  final List<MealDetails> favourites;

  FavouritesLoaded({required this.favourites});
}

final class FavouritesError extends FavouritesState {
  final String message;

  FavouritesError({required this.message});
}
