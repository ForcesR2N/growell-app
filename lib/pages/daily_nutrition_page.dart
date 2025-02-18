import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:growell_app/models/food_nutrition_model.dart';
import '../controllers/daily_nutrition_controller.dart';

class DailyNutritionPage extends GetView<DailyNutritionController> {
  DailyNutritionPage({Key? key}) : super(key: key);

  final TextEditingController ageController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController portionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrisi Harian'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              controller.resetDaily();
              portionController.clear();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInitialInputSection(),
            const SizedBox(height: 24),
            _buildNutritionProgressSection(),
            const SizedBox(height: 24),
            _buildFoodInputSection(),
            const SizedBox(height: 24),
            _buildConsumedFoodsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialInputSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Input Data Bayi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Obx(() => TextField(
                        controller: ageController,
                        decoration: InputDecoration(
                          labelText: 'Usia (bulan)',
                          errorText: controller.ageError.value.isEmpty
                              ? null
                              : controller.ageError.value,
                          border: const OutlineInputBorder(),
                          hintText: '1-24',
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(2),
                        ],
                      )),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Obx(() => TextField(
                        controller: weightController,
                        decoration: InputDecoration(
                          labelText: 'Berat (kg)',
                          errorText: controller.weightError.value.isEmpty
                              ? null
                              : controller.weightError.value,
                          border: const OutlineInputBorder(),
                          hintText: 'Contoh: 7.5',
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                      )),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  controller.calculateRequirements(
                    ageController.text,
                    weightController.text,
                  );
                },
                child: const Text('Hitung Kebutuhan Nutrisi'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionProgressSection() {
    return Obx(() {
      final percentages = controller.getNutritionPercentages();
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Progress Nutrisi Harian',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildNutritionProgress(
                'Kalori',
                percentages['calories']!,
                '${controller.consumedCalories.value.toStringAsFixed(1)} / ${controller.targetCalories.value.toStringAsFixed(1)} kcal',
                Colors.orange,
              ),
              const SizedBox(height: 8),
              _buildNutritionProgress(
                'Protein',
                percentages['protein']!,
                '${controller.consumedProtein.value.toStringAsFixed(1)} / ${controller.targetProtein.value.toStringAsFixed(1)} g',
                Colors.red,
              ),
              const SizedBox(height: 8),
              _buildNutritionProgress(
                'Karbohidrat',
                percentages['carbs']!,
                '${controller.consumedCarbs.value.toStringAsFixed(1)} / ${controller.targetCarbs.value.toStringAsFixed(1)} g',
                Colors.green,
              ),
              const SizedBox(height: 8),
              _buildNutritionProgress(
                'Lemak',
                percentages['fat']!,
                '${controller.consumedFat.value.toStringAsFixed(1)} / ${controller.targetFat.value.toStringAsFixed(1)} g',
                Colors.blue,
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildNutritionProgress(
    String label,
    double percentage,
    String value,
    MaterialColor color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text(value),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: color[100],
            color: color,
            minHeight: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildFoodInputSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tambah Makanan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildFoodSelectionButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodSelectionButton() {
    return ElevatedButton(
      onPressed: () => _showFoodSelectionDialog(),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add),
          SizedBox(width: 8),
          Text('Pilih Makanan'),
        ],
      ),
    );
  }

  void _showFoodSelectionDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Pilih Makanan'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: CommonBabyFood.basicFoods.length,
            itemBuilder: (context, index) {
              final food = CommonBabyFood.basicFoods[index];
              return ListTile(
                title: Text(food.name),
                subtitle: Text(
                  'Per ${food.portion}g: ${food.calories.toStringAsFixed(1)} kcal',
                ),
                onTap: () {
                  Get.back();
                  _showPortionDialog(food);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showPortionDialog(FoodNutrition food) {
    portionController.clear();
    Get.dialog(
      AlertDialog(
        title: Text('Porsi ${food.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: portionController,
              decoration: InputDecoration(
                labelText: 'Porsi (gram)',
                hintText: 'Standar: ${food.portion}g',
                border: const OutlineInputBorder(),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (portionController.text.isNotEmpty) {
                final portion = double.tryParse(portionController.text);
                if (portion != null && portion > 0) {
                  controller.addFood(food, portion);
                  Get.back();
                }
              }
            },
            child: const Text('Tambah'),
          ),
        ],
      ),
    );
  }

  Widget _buildConsumedFoodsList() {
    return Obx(() => controller.consumedFoods.isEmpty
        ? const SizedBox()
        : Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Makanan Hari Ini',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.consumedFoods.length,
                    itemBuilder: (context, index) {
                      final food = controller.consumedFoods[index];
                      return Card(
                        child: ListTile(
                          title: Text(food.name),
                          subtitle: Text(
                            '${food.portion}g, ${food.calories.toStringAsFixed(1)} kcal\n'
                            'P: ${food.protein.toStringAsFixed(1)}g, '
                            'K: ${food.carbs.toStringAsFixed(1)}g, '
                            'L: ${food.fat.toStringAsFixed(1)}g',
                          ),
                          isThreeLine: true,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ));
  }
}
