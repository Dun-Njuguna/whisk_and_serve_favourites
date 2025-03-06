import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:whisk_and_serve_core/bloc/bloc_helpers.dart';
import 'package:whisk_and_serve_core/entities/explore/meal_details.dart';
import 'package:whisk_and_serve_core/event_bus/events/favourites_bus_events.dart';
import 'package:whisk_and_serve_core/event_bus/global_event_bus.dart';
import 'package:whisk_and_serve_favourites/favourites/domain/usecases/add_to_favourites.dart';
import 'package:whisk_and_serve_favourites/favourites/domain/usecases/get_favourites.dart';
import 'package:whisk_and_serve_favourites/favourites/domain/usecases/is_favourite.dart';
import 'package:whisk_and_serve_favourites/favourites/domain/usecases/remove_from_favourites.dart';

part 'favourites_event.dart';
part 'favourites_state.dart';

class FavouritesBloc extends BaseBloc<FavouritesEvent, FavouritesState> {
  final AddToFavourites addToFavourites;
  final GetFavourites getFavourites;
  final IsFavourite isFavourite;
  final RemoveFromFavourites removeFromFavourites;

  late final StreamSubscription<FavouritesBusEvent> _favouritesEventSub;
  late final StreamSubscription<FavouritesBusQueryEvent> _queryEventSub;

  FavouritesBloc({
    required this.addToFavourites,
    required this.getFavourites,
    required this.isFavourite,
    required this.removeFromFavourites,
  }) : super(FavouritesInitial()) {
    _listenBusToEvents();
    onWithStateEmitter<FetchFavourites>(_fetchFavourites);
  }

  void _listenBusToEvents() {
    _favouritesEventSub =
        GlobalEventBus.on<FavouritesBusEvent>().listen((event) async {
      switch (event.action) {
        case FavouritesAction.add:
          await _addToFavourites(event.meal);
          break;
        case FavouritesAction.remove:
          await _removeFromFavourites(event.meal);
          break;
        case FavouritesAction.query:
          break;
        case FavouritesAction.failed:
          break;
      }
    });

    _queryEventSub =
        GlobalEventBus.on<FavouritesBusQueryEvent>().listen((event) async {
      if (event.action == FavouritesAction.query) {
        _handleIsFavouriteQuery(event.mealId);
      }
    });
  }

  Future<void> _fetchFavourites(
    FetchFavourites event,
    StateEmitter<FavouritesState> emitter,
  ) async {
    await emitter.emit(FavouritesLoading());
    try {
      final favourites = await getFavourites.call();
      await emitter.emit(FavouritesLoaded(favourites: favourites));
    } catch (e) {
      await emitter.emit(FavouritesError(message: e.toString()));
    }
  }

  Future<void> _addToFavourites(MealDetails meal) async {
    final success = await addToFavourites.call(meal);

    GlobalEventBus.trigger(FavouritesBusResponse(
      mealId: meal.id,
      isFavourite: success,
      action: FavouritesAction.add,
      message: success
          ? "Successfully added to favourites"
          : "Failed to add to favourites",
    ));
  }

  Future<void> _removeFromFavourites(MealDetails meal) async {
    final success = await removeFromFavourites.call(meal);
    GlobalEventBus.trigger(FavouritesBusResponse(
      mealId: meal.id,
      isFavourite: !success,
      action: FavouritesAction.remove,
      message:
          success ? "Removed successfully" : "Failed to remove from favourites",
    ));
    if (success) {
      add(FetchFavourites());
    }
  }

  void _handleIsFavouriteQuery(String mealId) async {
    final isMealFavourite = await isFavourite.call(mealId);

    GlobalEventBus.trigger(FavouritesBusResponse(
      mealId: mealId,
      isFavourite: isMealFavourite,
      action: FavouritesAction.query,
      message: isMealFavourite ? "Favourited" : "Not part of your favourites",
    ));
  }

  @override
  Future<void> close() {
    _favouritesEventSub.cancel();
    _queryEventSub.cancel();
    return super.close();
  }
}
