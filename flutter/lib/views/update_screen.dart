import 'package:flutter/material.dart';
import 'package:flutter_app/models/recipe.dart';
import 'package:flutter_app/repository/repository.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class RecipeUpdateScreen extends StatefulWidget {
  const RecipeUpdateScreen({Key? key}) : super(key: key);

  @override
  State<RecipeUpdateScreen> createState() => _RecipeUpdateScreenState();
}

class _RecipeUpdateScreenState extends State<RecipeUpdateScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _ingredientsController;
  late TextEditingController _directionsController;
  late TextEditingController _timeController;
  late TextEditingController _servingsController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Fetch the existing recipe using the provided recipeId
    final int recipeId = ModalRoute.of(context)!.settings.arguments as int;
    final existingRecipe =
        Provider.of<Repository>(context, listen: false).getRecipeById(recipeId);

    // Initialize the controllers with existing values
    _nameController = TextEditingController(text: existingRecipe.name);
    _ingredientsController =
        TextEditingController(text: existingRecipe.ingredients);
    _directionsController =
        TextEditingController(text: existingRecipe.directions);
    _timeController =
        TextEditingController(text: existingRecipe.time.toString());
    _servingsController =
        TextEditingController(text: existingRecipe.servings.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Recipe'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the recipe name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _ingredientsController,
                  decoration: const InputDecoration(labelText: 'Ingredients'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the ingredients';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _directionsController,
                  decoration: const InputDecoration(labelText: 'Directions'),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _timeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: 'Preparation Time (minutes)'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return null;
                    }

                    final isPositiveInteger =
                        int.tryParse(value) != null && int.parse(value) >= 0;

                    if (!isPositiveInteger) {
                      return 'Please enter a valid positive integer for preparation time';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _servingsController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Servings'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return null;
                    }
                    final isPositiveInteger =
                        int.tryParse(value) != null && int.parse(value) >= 0;

                    if (!isPositiveInteger) {
                      return 'Please enter a valid positive integer for servings';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _submitForm(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text('Update Recipe'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      final time =
          _timeController.text.isNotEmpty ? int.parse(_timeController.text) : 0;
      final servings = _servingsController.text.isNotEmpty
          ? int.parse(_servingsController.text)
          : 0;

      final updatedRecipe = Recipe(
        id: ModalRoute.of(context)!.settings.arguments as int,
        name: _nameController.text,
        ingredients: _ingredientsController.text,
        directions: _directionsController.text,
        time: time,
        servings: servings,
      );

      try {
        // Update the recipe in the repository
        Provider.of<Repository>(context, listen: false)
            .updateRecipe(updatedRecipe);
      } catch (error) {
        final logger = Logger();
        logger.e('Exception: $error');

        _showSnackBar(context, 'Error updating recipe: $error');
      }

      // Navigate back to the recipe list screen
      Navigator.pop(context, updatedRecipe);
    }
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
