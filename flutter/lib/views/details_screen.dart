import 'package:flutter/material.dart';
import 'package:flutter_app/models/recipe.dart';
import 'package:flutter_app/repository/repository.dart';
import 'package:provider/provider.dart';

class RecipeDetailsScreen extends StatelessWidget {
  const RecipeDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int recipeId = ModalRoute.of(context)!.settings.arguments as int;
    final Recipe recipe =
        Provider.of<Repository>(context).getRecipeById(recipeId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Details'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/update', arguments: recipe.id);
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Recipe name
              Text(
                recipe.name,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Card containing preparation time and servings
              SizedBox(
                width: double.infinity,
                child: Card(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Preparation Time: ${recipe.time} minutes'),
                        const SizedBox(height: 10),
                        Text('Servings: ${recipe.servings}'),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // List of ingredients as bullet points
              const Text(
                'Ingredients:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // Use ListView.builder for dynamic sizing
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: recipe.ingredients.split(',').length,
                itemBuilder: (context, index) {
                  final ingredient =
                      recipe.ingredients.split(',')[index].trim();
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        const Text('•',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                          ingredient.isNotEmpty
                              ? ingredient
                              : 'Ingredients not available',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // Directions
              const Text(
                'Directions:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                recipe.directions.isNotEmpty
                    ? recipe.directions
                    : 'Directions not available',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
