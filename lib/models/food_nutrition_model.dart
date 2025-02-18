class FoodNutrition {
  final String name;
  final double portion;  // dalam gram atau ml
  final double calories;
  final double protein;
  final double carbs;
  final double fat;

  FoodNutrition({
    required this.name,
    required this.portion,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  // Method untuk menyesuaikan nutrisi berdasarkan porsi yang dimakan
  FoodNutrition adjustPortion(double consumedPortion) {
    double factor = consumedPortion / portion;
    return FoodNutrition(
      name: name,
      portion: consumedPortion,
      calories: calories * factor,
      protein: protein * factor,
      carbs: carbs * factor,
      fat: fat * factor,
    );
  }
}

// Data makanan umum MPASI
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
    ),
    
    // Bubur beras (per 100g)
    FoodNutrition(
      name: 'Bubur Beras',
      portion: 100,
      calories: 120,
      protein: 2.5,
      carbs: 25.0,
      fat: 0.5,
    ),
    
    // Kentang (per 100g)
    FoodNutrition(
      name: 'Kentang',
      portion: 100,
      calories: 77,
      protein: 2.0,
      carbs: 17.0,
      fat: 0.1,
    ),
    
    // Pisang (per 100g)
    FoodNutrition(
      name: 'Pisang',
      portion: 100,
      calories: 89,
      protein: 1.1,
      carbs: 22.8,
      fat: 0.3,
    ),
    
    // Wortel (per 100g)
    FoodNutrition(
      name: 'Wortel',
      portion: 100,
      calories: 41,
      protein: 0.9,
      carbs: 9.6,
      fat: 0.2,
    ),
    
    // Ayam (per 100g)
    FoodNutrition(
      name: 'Ayam',
      portion: 100,
      calories: 165,
      protein: 31.0,
      carbs: 0.0,
      fat: 3.6,
    ),
    
    // Ikan (per 100g)
    FoodNutrition(
      name: 'Ikan',
      portion: 100,
      calories: 142,
      protein: 24.0,
      carbs: 0.0,
      fat: 4.5,
    ),
    
    // Tahu (per 100g)
    FoodNutrition(
      name: 'Tahu',
      portion: 100,
      calories: 76,
      protein: 8.0,
      carbs: 1.9,
      fat: 4.8,
    ),

    // Telur (per butir ±50g)
    FoodNutrition(
      name: 'Telur',
      portion: 50,
      calories: 72,
      protein: 6.3,
      carbs: 0.6,
      fat: 4.8,
    ),
  ];
}