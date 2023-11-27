import 'package:flutter/material.dart';
import 'package:flutter_app/repository/repository.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';

class RecipeListScreen extends StatelessWidget {
  const RecipeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Journal'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add');
        },
        child: const Icon(Icons.add),
      ),
      body: Consumer<Repository>(
        builder: (context, repository, child) {
          final logger = Logger();

          try {
            final recipes = repository.getRecipes; // attempt to get recipes
            return ListView.builder(
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                final recipe = recipes[index];
                return GestureDetector(
                  key: ValueKey(recipe),
                  onTap: () {
                    Navigator.pushNamed(context, '/details',
                        arguments: recipe.id);
                  },
                  onLongPress: () {
                    _openDeleteRecipeDialog(context, recipe.id);
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 15,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recipe.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text("Preparation Time: ${recipe.time} minutes"),
                          Text("Servings: ${recipe.servings}"),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } catch (error) {
            logger.e('Exception: $error');

            _showSnackBar(context, 'Error retrieving recipes: $error');
            return const SizedBox();
          }
        },
      ),
    );
  }

  void _openDeleteRecipeDialog(BuildContext context, int recipeId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Recipe'),
          content: const Text('Are you sure you want to delete this recipe?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                try {
                  // Handle deleting the recipe from the repository
                  Provider.of<Repository>(context, listen: false)
                      .deleteRecipe(recipeId);
                } catch (error) {
                  final logger = Logger();
                  logger.e('Exception: $error');

                  _showSnackBar(context, 'Error deleting recipe: $error');
                }

                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
