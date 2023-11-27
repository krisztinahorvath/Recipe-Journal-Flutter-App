class Recipe {
  int id = 0;
  String name = "";
  String ingredients = "";
  String directions = "";
  int time = 0;
  int servings = 0;

  Recipe(
      {required this.id,
      required this.name,
      required this.ingredients,
      required this.directions,
      required this.time,
      required this.servings});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'ingredients': ingredients,
      'directions': directions,
      'time': time,
      'servings': servings,
    };
  }

  Recipe copyWith({
    int? id,
    String? name,
    String? ingredients,
    String? directions,
    int? time,
    int? servings,
  }) {
    return Recipe(
      id: id ?? this.id,
      name: name ?? this.name,
      ingredients: ingredients ?? this.ingredients,
      directions: directions ?? this.directions,
      time: time ?? this.time,
      servings: servings ?? this.servings,
    );
  }
}
