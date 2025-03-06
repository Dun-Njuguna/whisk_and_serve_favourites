part of 'favourites_bloc.dart';

@immutable
sealed class FavouritesEvent {}

class FetchFavourites extends FavouritesEvent {}
