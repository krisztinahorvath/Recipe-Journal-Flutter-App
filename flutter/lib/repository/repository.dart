import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_app/database_helper.dart';
import 'package:flutter_app/models/recipe.dart';

class Repository extends ChangeNotifier {
  final List<Recipe> _recipes = [];
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  UnmodifiableListView<Recipe> get getRecipes => UnmodifiableListView(_recipes);

  Repository() {
    _initializeRecipes();
  }

  Future<void> _initializeRecipes() async {
    await _databaseHelper.initializeDatabase();
    final List<Recipe> recipes = await _databaseHelper.getRecipes();
    _recipes.addAll(recipes);
    notifyListeners();
  }

  Future<void> addRecipe(Recipe recipe) async {
    final int id = await _databaseHelper.insertRecipe(recipe);
    final Recipe newRecipe = recipe.copyWith(id: id);
    _recipes.add(newRecipe);
    notifyListeners();
  }

  Future<void> updateRecipe(Recipe updatedRecipe) async {
    await _databaseHelper.updateRecipe(updatedRecipe);
    final index =
        _recipes.indexWhere((recipe) => recipe.id == updatedRecipe.id);
    if (index != -1) {
      _recipes[index] = updatedRecipe;
      notifyListeners();
    }
  }

  Future<void> deleteRecipe(int recipeId) async {
    await _databaseHelper.deleteRecipe(recipeId);
    _recipes.removeWhere((recipe) => recipe.id == recipeId);
    notifyListeners();
  }

  Recipe getRecipeById(int recipeId) {
    final index = _recipes.indexWhere((recipe) => recipe.id == recipeId);
    return _recipes[index];
  }
}
