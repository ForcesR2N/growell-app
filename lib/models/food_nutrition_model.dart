class FoodNutrition {
  final String name;
  final double portion;  // dalam gram atau ml
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final DateTime? consumedAt;
  
  // Added micronutrients
  final double? iron;      // in mg
  final double? calcium;   // in mg
  final double? vitaminD;  // in mcg
  final double? zinc;      // in mg
  final double? fiber;     // in g
  final String? foodGroup; // category of food

  FoodNutrition({
    required this.name,
    required this.portion,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.consumedAt,
    this.iron = 0,
    this.calcium = 0,
    this.vitaminD = 0, 
    this.zinc = 0,
    this.fiber = 0,
    this.foodGroup,
  });

  // Method to adjust nutrition based on consumed portion
  FoodNutrition adjustPortion(double consumedPortion) {
    double factor = consumedPortion / portion;
    return FoodNutrition(
      name: name,
      portion: consumedPortion,
      calories: calories * factor,
      protein: protein * factor,
      carbs: carbs * factor,
      fat: fat * factor,
      consumedAt: DateTime.now(),
      iron: iron != null ? iron! * factor : 0,
      calcium: calcium != null ? calcium! * factor : 0,
      vitaminD: vitaminD != null ? vitaminD! * factor : 0,
      zinc: zinc != null ? zinc! * factor : 0,
      fiber: fiber != null ? fiber! * factor : 0,
      foodGroup: foodGroup,
    );
  }
  
  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'portion': portion,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'consumedAt': consumedAt?.toIso8601String(),
      'iron': iron,
      'calcium': calcium,
      'vitaminD': vitaminD,
      'zinc': zinc,
      'fiber': fiber,
      'foodGroup': foodGroup,
    };
  }
  
  // Create from JSON
  factory FoodNutrition.fromJson(Map<String, dynamic> json) {
    return FoodNutrition(
      name: json['name'],
      portion: json['portion'],
      calories: json['calories'],
      protein: json['protein'],
      carbs: json['carbs'],
      fat: json['fat'],
      consumedAt: json['consumedAt'] != null 
          ? DateTime.parse(json['consumedAt']) 
          : null,
      iron: json['iron'],
      calcium: json['calcium'],
      vitaminD: json['vitaminD'],
      zinc: json['zinc'],
      fiber: json['fiber'],
      foodGroup: json['foodGroup'],
    );
  }
}

// Enhanced basic foods database with micronutrients data
class CommonBabyFood {
  static final List<FoodNutrition> basicFoods = [
    // ASI/Susu Formula (per 100ml)
    FoodNutrition(
      name: 'ASI/Susu Formula',
      portion: 100,
      calories: 65,
      protein: 1.5,
      carbs: 7.0,
      fat: 3.5,
      iron: 0.3,
      calcium: 30,
      vitaminD: 1.5,
      zinc: 1.2,
      foodGroup: 'Dairy',
    ),
    
    // Bubur beras (per 100g)
    FoodNutrition(
      name: 'Bubur Beras',
      portion: 100,
      calories: 120,
      protein: 2.5,
      carbs: 25.0,
      fat: 0.5,
      iron: 0.5,
      calcium: 10,
      vitaminD: 0,
      zinc: 0.6,
      fiber: 1.0,
      foodGroup: 'Grain',
    ),
    
    // Kentang (per 100g)
    FoodNutrition(
      name: 'Kentang',
      portion: 100,
      calories: 77,
      protein: 2.0,
      carbs: 17.0,
      fat: 0.1,
      iron: 0.8,
      calcium: 12,
      vitaminD: 0,
      zinc: 0.3,
      fiber: 2.2,
      foodGroup: 'Vegetable',
    ),
    
    // Pisang (per 100g)
    FoodNutrition(
      name: 'Pisang',
      portion: 100,
      calories: 89,
      protein: 1.1,
      carbs: 22.8,
      fat: 0.3,
      iron: 0.3,
      calcium: 5,
      vitaminD: 0,
      zinc: 0.1,
      fiber: 2.6,
      foodGroup: 'Fruit',
    ),
    
    // Wortel (per 100g)
    FoodNutrition(
      name: 'Wortel',
      portion: 100,
      calories: 41,
      protein: 0.9,
      carbs: 9.6,
      fat: 0.2,
      iron: 0.3,
      calcium: 33,
      vitaminD: 0,
      zinc: 0.2,
      fiber: 2.8,
      foodGroup: 'Vegetable',
    ),
    
    // Ayam (per 100g)
    FoodNutrition(
      name: 'Ayam',
      portion: 100,
      calories: 165,
      protein: 31.0,
      carbs: 0.0,
      fat: 3.6,
      iron: 1.3,
      calcium: 12,
      vitaminD: 0.4,
      zinc: 1.0,
      fiber: 0,
      foodGroup: 'Protein',
    ),
    
    // Ikan (per 100g)
    FoodNutrition(
      name: 'Ikan',
      portion: 100,
      calories: 142,
      protein: 24.0,
      carbs: 0.0,
      fat: 4.5,
      iron: 1.0,
      calcium: 15,
      vitaminD: 7.2,
      zinc: 0.8,
      fiber: 0,
      foodGroup: 'Protein',
    ),
    
    // Tahu (per 100g)
    FoodNutrition(
      name: 'Tahu',
      portion: 100,
      calories: 76,
      protein: 8.0,
      carbs: 1.9,
      fat: 4.8,
      iron: 2.0,
      calcium: 350,
      vitaminD: 0,
      zinc: 0.7,
      fiber: 0.3,
      foodGroup: 'Protein',
    ),

    // Telur (per butir ±50g)
    FoodNutrition(
      name: 'Telur',
      portion: 50,
      calories: 72,
      protein: 6.3,
      carbs: 0.6,
      fat: 4.8,
      iron: 0.9,
      calcium: 25,
      vitaminD: 1.1,
      zinc: 0.6,
      fiber: 0,
      foodGroup: 'Protein',
    ),
    
    // Alpukat (per 100g)
    FoodNutrition(
      name: 'Alpukat',
      portion: 100,
      calories: 160,
      protein: 2.0,
      carbs: 8.5,
      fat: 14.7,
      iron: 0.6,
      calcium: 12,
      vitaminD: 0,
      zinc: 0.6,
      fiber: 6.7,
      foodGroup: 'Fruit',
    ),
    
    // Tempe (per 100g)
    FoodNutrition(
      name: 'Tempe',
      portion: 100,
      calories: 193,
      protein: 18.5,
      carbs: 9.4,
      fat: 10.8,
      iron: 2.7,
      calcium: 111,
      vitaminD: 0,
      zinc: 1.7,
      fiber: 1.4,
      foodGroup: 'Protein',
    ),
    
    // Ubi (per 100g)
    FoodNutrition(
      name: 'Ubi',
      portion: 100,
      calories: 86,
      protein: 1.6,
      carbs: 20.1,
      fat: 0.1,
      iron: 0.6,
      calcium: 30,
      vitaminD: 0,
      zinc: 0.3,
      fiber: 3.0,
      foodGroup: 'Vegetable',
    ),
    
    // Labu kuning (per 100g)
    FoodNutrition(
      name: 'Labu Kuning',
      portion: 100,
      calories: 26,
      protein: 1.0,
      carbs: 6.5,
      fat: 0.1,
      iron: 0.8,
      calcium: 21,
      vitaminD: 0,
      zinc: 0.2,
      fiber: 0.5,
      foodGroup: 'Vegetable',
    ),
    
    // Bayam (per 100g)
    FoodNutrition(
      name: 'Bayam',
      portion: 100,
      calories: 23,
      protein: 2.9,
      carbs: 3.6,
      fat: 0.4,
      iron: 2.7,
      calcium: 99,
      vitaminD: 0,
      zinc: 0.5,
      fiber: 2.2,
      foodGroup: 'Vegetable',
    ),
    
    // Brokoli (per 100g)
    FoodNutrition(
      name: 'Brokoli',
      portion: 100,
      calories: 34,
      protein: 2.8,
      carbs: 6.6,
      fat: 0.4,
      iron: 0.7,
      calcium: 47,
      vitaminD: 0,
      zinc: 0.4,
      fiber: 2.6,
      foodGroup: 'Vegetable',
    ),
    
    // Additional Foods
    
    // Hati Ayam (per 100g)
    FoodNutrition(
      name: 'Hati Ayam',
      portion: 100,
      calories: 172,
      protein: 26.5,
      carbs: 0.7,
      fat: 6.2,
      iron: 9.0,
      calcium: 11,
      vitaminD: 0.2,
      zinc: 2.7,
      fiber: 0,
      foodGroup: 'Protein',
    ),
    
    // Daging Sapi (per 100g)
    FoodNutrition(
      name: 'Daging Sapi',
      portion: 100,
      calories: 250,
      protein: 26.0,
      carbs: 0.0,
      fat: 17.0,
      iron: 2.6,
      calcium: 18,
      vitaminD: 0.1,
      zinc: 6.0,
      fiber: 0,
      foodGroup: 'Protein',
    ),
    
    // Apel (per 100g)
    FoodNutrition(
      name: 'Apel',
      portion: 100,
      calories: 52,
      protein: 0.3,
      carbs: 14.0,
      fat: 0.2,
      iron: 0.1,
      calcium: 6,
      vitaminD: 0,
      zinc: 0.0,
      fiber: 2.4,
      foodGroup: 'Fruit',
    ),
    
    // Jeruk (per 100g)
    FoodNutrition(
      name: 'Jeruk',
      portion: 100,
      calories: 47,
      protein: 0.9,
      carbs: 11.8,
      fat: 0.1,
      iron: 0.1,
      calcium: 40,
      vitaminD: 0,
      zinc: 0.1,
      fiber: 2.4,
      foodGroup: 'Fruit',
    ),
    
    // Susu UHT (per 100ml)
    FoodNutrition(
      name: 'Susu UHT',
      portion: 100,
      calories: 65,
      protein: 3.4,
      carbs: 4.8,
      fat: 3.6,
      iron: 0.1,
      calcium: 120,
      vitaminD: 1.2,
      zinc: 0.4,
      fiber: 0,
      foodGroup: 'Dairy',
    ),
    
    // Yogurt (per 100g)
    FoodNutrition(
      name: 'Yogurt',
      portion: 100,
      calories: 59,
      protein: 3.5,
      carbs: 4.7,
      fat: 3.3,
      iron: 0.1,
      calcium: 110,
      vitaminD: 0.1,
      zinc: 0.6,
      fiber: 0,
      foodGroup: 'Dairy',
    ),
  ];
  
  // Get food by food group
  static List<FoodNutrition> getFoodsByGroup(String group) {
    return basicFoods.where((food) => food.foodGroup == group).toList();
  }
  
  // Get foods high in specific nutrients (useful for recommendations)
  static List<FoodNutrition> getFoodsHighIn(String nutrient) {
    switch (nutrient.toLowerCase()) {
      case 'iron':
        return basicFoods.where((food) => (food.iron ?? 0) > 1.0).toList()
          ..sort((a, b) => (b.iron ?? 0).compareTo(a.iron ?? 0));
      case 'calcium':
        return basicFoods.where((food) => (food.calcium ?? 0) > 50).toList()
          ..sort((a, b) => (b.calcium ?? 0).compareTo(a.calcium ?? 0));
      case 'protein':
        return basicFoods.where((food) => food.protein > 5.0).toList()
          ..sort((a, b) => b.protein.compareTo(a.protein));
      case 'fiber':
        return basicFoods.where((food) => (food.fiber ?? 0) > 2.0).toList()
          ..sort((a, b) => (b.fiber ?? 0).compareTo(a.fiber ?? 0));
      case 'vitamin d':
      case 'vitamind':
        return basicFoods.where((food) => (food.vitaminD ?? 0) > 0.5).toList()
          ..sort((a, b) => (b.vitaminD ?? 0).compareTo(a.vitaminD ?? 0));
      case 'zinc':
        return basicFoods.where((food) => (food.zinc ?? 0) > 0.5).toList()
          ..sort((a, b) => (b.zinc ?? 0).compareTo(a.zinc ?? 0));
      default:
        return [];
    }
  }
}