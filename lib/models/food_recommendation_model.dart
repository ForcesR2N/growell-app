class FoodRecommendation {
  final String description;
  final FeedingSchedule feedingSchedule;
  final String mainFeeding;
  final int maxAge;
  final int minAge;
  final NutritionNeeds nutritionNeeds;
  final List<String> tips;
  final List<RecommendedFood>? recommendedFoods;
  final List<ImportantNutrient>? importantNutrients;
  final Meals? meals;

  FoodRecommendation({
    required this.description,
    required this.feedingSchedule,
    required this.mainFeeding,
    required this.maxAge,
    required this.minAge,
    required this.nutritionNeeds,
    required this.tips,
    this.recommendedFoods,
    this.importantNutrients,
    this.meals,
  });

  factory FoodRecommendation.fromJson(Map<String, dynamic> json) {
    return FoodRecommendation(
      description: json['description'] ?? '',
      feedingSchedule: FeedingSchedule.fromJson(json['feedingSchedule'] ?? {}),
      mainFeeding: json['mainFeeding'] ?? '',
      maxAge: json['maxAge'] ?? 0,
      minAge: json['minAge'] ?? 0,
      nutritionNeeds: NutritionNeeds.fromJson(json['nutritionNeeds'] ?? {}),
      tips: List<String>.from(json['tips'] ?? []),
      recommendedFoods: json['recommendedFoods'] != null
          ? List<RecommendedFood>.from(
              json['recommendedFoods'].map((x) => RecommendedFood.fromJson(x)))
          : null,
      importantNutrients: json['importantNutrients'] != null
          ? List<ImportantNutrient>.from(
              json['importantNutrients'].map((x) => ImportantNutrient.fromJson(x)))
          : null,
      meals: json['meals'] != null ? Meals.fromJson(json['meals']) : null,
    );
  }
}

class FeedingSchedule {
  final String? amount;
  final String? frequency;
  final String? interval;
  final String? breastfeeding;
  final List<MainMeal>? mainMeals;

  FeedingSchedule({
    this.amount,
    this.frequency,
    this.interval,
    this.breastfeeding,
    this.mainMeals,
  });

  factory FeedingSchedule.fromJson(Map<String, dynamic> json) {
    return FeedingSchedule(
      amount: json['amount'],
      frequency: json['frequency'],
      interval: json['interval'],
      breastfeeding: json['breastfeeding'],
      mainMeals: json['mainMeals'] != null
          ? List<MainMeal>.from(
              json['mainMeals'].map((x) => MainMeal.fromJson(x)))
          : null,
    );
  }
}

class MainMeal {
  final String portion;
  final String time;
  final String type;

  MainMeal({
    required this.portion,
    required this.time,
    required this.type,
  });

  factory MainMeal.fromJson(Map<String, dynamic> json) {
    return MainMeal(
      portion: json['portion'] ?? '',
      time: json['time'] ?? '',
      type: json['type'] ?? '',
    );
  }
}

class NutritionNeeds {
  final String calories;
  final String carbs;
  final String fat;
  final String protein;

  NutritionNeeds({
    required this.calories,
    required this.carbs,
    required this.fat,
    required this.protein,
  });

  factory NutritionNeeds.fromJson(Map<String, dynamic> json) {
    return NutritionNeeds(
      calories: json['calories'] ?? '',
      carbs: json['carbs'] ?? '',
      fat: json['fat'] ?? '',
      protein: json['protein'] ?? '',
    );
  }
}

class ImportantNutrient {
  final String amount;
  final String importance;
  final String name;

  ImportantNutrient({
    required this.amount,
    required this.importance,
    required this.name,
  });

  factory ImportantNutrient.fromJson(Map<String, dynamic> json) {
    return ImportantNutrient(
      amount: json['amount'] ?? '',
      importance: json['importance'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class RecommendedFood {
  final String name;
  final List<String> preparation;
  final List<String>? ingredients;
  final NutritionalValue? nutritionalValue;
  final String? texture;
  final String? type;

  RecommendedFood({
    required this.name,
    required this.preparation,
    this.ingredients,
    this.nutritionalValue,
    this.texture,
    this.type,
  });

  factory RecommendedFood.fromJson(Map<String, dynamic> json) {
    return RecommendedFood(
      name: json['name'] ?? '',
      preparation: List<String>.from(json['preparation'] ?? []),
      ingredients: json['ingredients'] != null
          ? List<String>.from(json['ingredients'])
          : null,
      nutritionalValue: json['nutritionalValue'] != null
          ? NutritionalValue.fromJson(json['nutritionalValue'])
          : null,
      texture: json['texture'],
      type: json['type'],
    );
  }
}

class NutritionalValue {
  final String calories;
  final String fat;

  NutritionalValue({
    required this.calories,
    required this.fat,
  });

  factory NutritionalValue.fromJson(Map<String, dynamic> json) {
    return NutritionalValue(
      calories: json['calories'] ?? '',
      fat: json['fat'] ?? '',
    );
  }
}

class Meals {
  final List<String> ingredients;
  final String name;
  final List<String> nutritionHighlights;
  final String portion;
  final String preparation;
  final String texture;

  Meals({
    required this.ingredients,
    required this.name,
    required this.nutritionHighlights,
    required this.portion,
    required this.preparation,
    required this.texture,
  });

  factory Meals.fromJson(Map<String, dynamic> json) {
    return Meals(
      ingredients: List<String>.from(json['ingredients'] ?? []),
      name: json['name'] ?? '',
      nutritionHighlights: List<String>.from(json['nutritionHighlights'] ?? []),
      portion: json['portion'] ?? '',
      preparation: json['preparation'] ?? '',
      texture: json['texture'] ?? '',
    );
  }
}