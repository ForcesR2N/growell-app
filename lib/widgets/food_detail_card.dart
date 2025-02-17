import 'package:flutter/material.dart';
import '../models/food_recommendation_model.dart';

class MainInfoSection extends StatelessWidget {
  final FoodRecommendation data;

  const MainInfoSection({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data.description,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Makanan Utama: ${data.mainFeeding}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FeedingScheduleSection extends StatelessWidget {
  final FeedingSchedule schedule;

  const FeedingScheduleSection({Key? key, required this.schedule}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Jadwal Pemberian',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (schedule.amount != null)
              _buildInfoItem('Jumlah', schedule.amount!),
            if (schedule.frequency != null)
              _buildInfoItem('Frekuensi', schedule.frequency!),
            if (schedule.interval != null)
              _buildInfoItem('Interval', schedule.interval!),
            if (schedule.breastfeeding != null)
              _buildInfoItem('ASI', schedule.breastfeeding!),
            if (schedule.mainMeals != null) ...[
              const SizedBox(height: 8),
              const Text(
                'Jadwal Makan Utama:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...schedule.mainMeals!.map((meal) => _buildMealSchedule(meal)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMealSchedule(MainMeal meal) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.schedule, size: 16),
          const SizedBox(width: 8),
          Text('${meal.time} - ${meal.type} (${meal.portion})'),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 8),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: value),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NutritionSection extends StatelessWidget {
  final NutritionNeeds nutrition;
  final List<ImportantNutrient>? importantNutrients;

  const NutritionSection({
    Key? key,
    required this.nutrition,
    this.importantNutrients,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Kebutuhan Nutrisi',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoItem('Kalori', nutrition.calories),
            _buildInfoItem('Protein', nutrition.protein),
            _buildInfoItem('Karbohidrat', nutrition.carbs),
            _buildInfoItem('Lemak', nutrition.fat),
            if (importantNutrients != null && importantNutrients!.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'Nutrisi Penting:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...importantNutrients!.map((nutrient) => _buildImportantNutrient(nutrient)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildImportantNutrient(ImportantNutrient nutrient) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${nutrient.name} (${nutrient.amount})',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(nutrient.importance),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 8),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: value),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RecommendedFoodsSection extends StatelessWidget {
  final List<RecommendedFood> foods;

  const RecommendedFoodsSection({Key? key, required this.foods}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Rekomendasi Makanan',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...foods.map((food) => _buildFoodItem(food)),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodItem(RecommendedFood food) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(food.name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (food.texture != null) ...[
          const SizedBox(height: 4),
          Text('Tekstur: ${food.texture}'),
        ],
        if (food.ingredients != null) ...[
          const SizedBox(height: 8),
          Text(
            'Bahan-bahan:',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          ...food.ingredients!.map((ingredient) => Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 4),
            child: Row(
              children: [
                const Icon(Icons.fiber_manual_record, size: 8),
                const SizedBox(width: 8),
                Text(ingredient),
              ],
            ),
          )),
        ],
        const SizedBox(height: 8),
        Text(
          'Cara Penyajian:',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        ...food.preparation.map((step) => Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 4),
          child: Text(step),
        )),
        if (food.nutritionalValue != null) ...[
          const SizedBox(height: 8),
          Text(
            'Nilai Gizi:',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Kalori: ${food.nutritionalValue!.calories}'),
                Text('Lemak: ${food.nutritionalValue!.fat}'),
              ],
            ),
          ),
        ],
      ],
    ),
  );
}
}

class TipsSection extends StatelessWidget {
  final List<String> tips;

  const TipsSection({Key? key, required this.tips}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tips dan Panduan',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...tips.map((tip) => _buildTipItem(tip)),
          ],
        ),
      ),
    );
  }

  Widget _buildTipItem(String tip) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Icon(Icons.check_circle_outline, size: 16),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(tip),
          ),
        ],
      ),
    );
  }
}