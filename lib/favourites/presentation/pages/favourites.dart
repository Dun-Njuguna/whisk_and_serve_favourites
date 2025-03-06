import 'package:flutter/material.dart';
import 'package:whisk_and_serve_core/bloc/bloc_helpers.dart';
import 'package:whisk_and_serve_core/entities/explore/meal_details.dart';
import 'package:whisk_and_serve_core/router/app_routes.dart';
import 'package:whisk_and_serve_core/router/router.dart';
import 'package:whisk_and_serve_core/widgets/base_scaffold.dart';
import 'package:whisk_and_serve_favourites/favourites/presentation/bloc/favourites_bloc.dart';

class Favourites extends StatefulWidget {
  const Favourites({super.key});

  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  @override
  void initState() {
    super.initState();
    addBlocEvent<FavouritesBloc>(
      context,
      FetchFavourites(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      child: createBlocBuilder<FavouritesBloc, FavouritesState>(
        builder: (context, state) {
          if (state is FavouritesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FavouritesLoaded) {
            final favourites = state.favourites;
            if (favourites.isEmpty) {
              return Center(
                child: Text("No favourites added yet!",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        )),
              );
            }
            return Padding(
              padding: const EdgeInsets.only(
                bottom: 50,
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: favourites.length,
                itemBuilder: (context, index) {
                  final meal = favourites[index];
                  return FavouriteMealCard(meal: meal);
                },
              ),
            );
          } else if (state is FavouritesError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
    );
  }
}

class FavouriteMealCard extends StatelessWidget {
  final MealDetails meal;

  const FavouriteMealCard({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(
        bottom: 8,
        left: 8,
        right: 8,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            meal.thumbnail,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          meal.name,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        subtitle: Text(
          "${meal.category} | ${meal.area}",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        trailing: IconButton(
          icon: const Icon(Icons.favorite, color: Colors.red),
          onPressed: () {
            // Trigger remove favourite event here
            // BlocProvider.of<FavouritesBloc>(context)
            //     .add(RemoveFromFavouritesEvent(meal));
          },
        ),
        onTap: () {
          // Navigate to meal details (Explore module)
          NavigationHelper.navigateTo(
              context, '/${AppRoutes.meals}/${meal.category}/${meal.id}');
        },
      ),
    );
  }
}
