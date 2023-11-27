import 'package:flutter/material.dart';
import 'package:flutter_app/models/recipe.dart';
import 'package:flutter_app/repository/repository.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class RecipeAddScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ingredientsController = TextEditingController();
  final TextEditingController _directionsController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _servingsController = TextEditingController();

  RecipeAddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Recipe'),
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
                TextFormField(
                  controller: _directionsController,
                  decoration: const InputDecoration(labelText: 'Directions'),
                ),
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
                        int.tryParse(value) != null && int.parse(value) > 0;

                    if (!isPositiveInteger) {
                      return 'Please enter a valid positive integer for preparation time';
                    }

                    return null;
                  },
                ),
                TextFormField(
                  controller: _servingsController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Servings'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return null;
                    }
                    final isPositiveInteger =
                        int.tryParse(value) != null && int.parse(value) > 0;

                    if (!isPositiveInteger) {
                      return 'Please enter a valid positive integer for servings';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => _submitForm(context),
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text(
                    'Add Recipe',
                    style: TextStyle(color: Colors.white),
                  ),
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

      final Recipe newRecipe = Recipe(
        id: DateTime.now().millisecondsSinceEpoch,
        name: _nameController.text,
        ingredients: _ingredientsController.text,
        directions: _directionsController.text,
        time: time,
        servings: servings,
      );

      try {
        Provider.of<Repository>(context, listen: false).addRecipe(newRecipe);
      } catch (error) {
        final logger = Logger();
        logger.e('Exception: $error');

        _showSnackBar(context, 'Error adding recipe: $error');
      }

      // Navigate back to the recipe list screen
      Navigator.pop(context);
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
