import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:growell_app/models/food_nutrition_model.dart';
import '../controllers/daily_nutrition_controller.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:intl/intl.dart';

class DailyNutritionPage extends GetView<DailyNutritionController> {
  DailyNutritionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrisi Harian'),
        elevation: 0,
        backgroundColor: Colors.blue,
        actions: [
          Obx(() => controller.consumedFoods.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () => controller.resetDaily(),
                  tooltip: 'Reset Data Hari Ini',
                )
              : const SizedBox.shrink()),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.loadSavedData();
        },
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDateHeader(),
                const SizedBox(height: 16),
                _buildInitialInputSection(),
                if (controller.weightStatus.value.isNotEmpty)
                  Column(
                    children: [
                      const SizedBox(height: 16),
                      _buildWeightStatusCard(),
                    ],
                  ),
                const SizedBox(height: 24),
                _buildNutritionSummaryCard(),
                const SizedBox(height: 16),
                _buildNutritionProgressSection(),
                const SizedBox(height: 24),
                _buildFoodInputSection(),
                const SizedBox(height: 16),
                _buildConsumedFoodsList(),
              ],
            ),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFoodSelectionDialog(),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
        tooltip: 'Tambah Makanan',
      ),
    );
  }

  Widget _buildDateHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          const Icon(Icons.calendar_today, color: Colors.blue),
          const SizedBox(width: 10),
          Text(
            controller.dateFormatted.value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialInputSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Data Bayi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Obx(() => TextField(
                        controller: controller.ageController,
                        decoration: InputDecoration(
                          labelText: 'Usia (bulan)',
                          errorText: controller.ageError.value.isEmpty
                              ? null
                              : controller.ageError.value,
                          border: const OutlineInputBorder(),
                          hintText: '1-24',
                          prefixIcon: const Icon(Icons.cake),
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
                        controller: controller.weightController,
                        decoration: InputDecoration(
                          labelText: 'Berat (kg)',
                          errorText: controller.weightError.value.isEmpty
                              ? null
                              : controller.weightError.value,
                          border: const OutlineInputBorder(),
                          hintText: 'Contoh: 7.5',
                          prefixIcon: const Icon(Icons.monitor_weight),
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
              child: ElevatedButton.icon(
                icon: const Icon(Icons.calculate),
                label: const Text('Hitung Kebutuhan Nutrisi'),
                onPressed: () {
                  controller.calculateRequirements(
                    controller.ageController.text,
                    controller.weightController.text,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeightStatusCard() {
    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (controller.weightStatus.value) {
      case 'underweight':
        statusColor = Colors.orange;
        statusIcon = Icons.arrow_downward;
        statusText = 'Berat Badan Kurang';
        break;
      case 'overweight':
        statusColor = Colors.orange;
        statusIcon = Icons.arrow_upward;
        statusText = 'Berat Badan Lebih';
        break;
      default:
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        statusText = 'Berat Badan Ideal';
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: statusColor.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(statusIcon, color: statusColor),
                const SizedBox(width: 8),
                Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Berat saat ini: ${controller.weightController.text} kg',
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              'Berat ideal untuk usia ${controller.ageController.text} bulan: ${controller.idealWeightLow.value.toStringAsFixed(1)}-${controller.idealWeightHigh.value.toStringAsFixed(1)} kg',
              style: const TextStyle(fontSize: 14),
            ),
            const Divider(height: 16),
            Text(
              controller.getWeightStatusAdvice(),
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionSummaryCard() {
    final percentages = controller.getNutritionPercentages();
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ringkasan Nutrisi Hari Ini',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNutrientCircle(
                  'Kalori', 
                  percentages['calories']!, 
                  '${controller.consumedCalories.value.toStringAsFixed(0)}/${controller.targetCalories.value.toStringAsFixed(0)} kcal',
                  Colors.orange
                ),
                _buildNutrientCircle(
                  'Protein', 
                  percentages['protein']!, 
                  '${controller.consumedProtein.value.toStringAsFixed(1)}/${controller.targetProtein.value.toStringAsFixed(1)} g',
                  Colors.red
                ),
                _buildNutrientCircle(
                  'Karbo', 
                  percentages['carbs']!, 
                  '${controller.consumedCarbs.value.toStringAsFixed(1)}/${controller.targetCarbs.value.toStringAsFixed(1)} g',
                  Colors.green
                ),
                _buildNutrientCircle(
                  'Lemak', 
                  percentages['fat']!, 
                  '${controller.consumedFat.value.toStringAsFixed(1)}/${controller.targetFat.value.toStringAsFixed(1)} g',
                  Colors.blue
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildNutrientCircle(String label, double percentage, String value, Color color) {
    // Batasi persen ke 100% untuk tampilan
    final displayPercentage = percentage > 100 ? 100 : percentage;
    
    return Column(
      children: [
        CircularPercentIndicator(
          radius: 35,
          lineWidth: 8,
          percent: displayPercentage / 100,
          center: Text(
            '${percentage.toStringAsFixed(0)}%',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          progressColor: color,
          backgroundColor: color.withOpacity(0.2),
          circularStrokeCap: CircularStrokeCap.round,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildNutritionProgressSection() {
    final percentages = controller.getNutritionPercentages();
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Detail Nutrisi Harian',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),
            _buildNutritionProgress(
              'Kalori',
              percentages['calories']!,
              '${controller.consumedCalories.value.toStringAsFixed(1)} / ${controller.targetCalories.value.toStringAsFixed(1)} kcal',
              Colors.orange,
            ),
            const SizedBox(height: 12),
            _buildNutritionProgress(
              'Protein',
              percentages['protein']!,
              '${controller.consumedProtein.value.toStringAsFixed(1)} / ${controller.targetProtein.value.toStringAsFixed(1)} g',
              Colors.red,
            ),
            const SizedBox(height: 12),
            _buildNutritionProgress(
              'Karbohidrat',
              percentages['carbs']!,
              '${controller.consumedCarbs.value.toStringAsFixed(1)} / ${controller.targetCarbs.value.toStringAsFixed(1)} g',
              Colors.green,
            ),
            const SizedBox(height: 12),
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
  }

  Widget _buildNutritionProgress(
    String label,
    double percentage,
    String value,
    MaterialColor color,
  ) {
    // Cap persentase ke 100% untuk tampilan (tapi tetap tampilkan nilai sebenarnya)
    final displayPercentage = percentage > 100 ? 100 : percentage;
    
    // Ubah warna berdasarkan persentase
    Color progressColor;
    if (percentage < 50) {
      progressColor = Colors.red;
    } else if (percentage < 80) {
      progressColor = Colors.orange;
    } else if (percentage <= 100) {
      progressColor = Colors.green;
    } else {
      progressColor = Colors.blue; // Lebih dari 100%
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
              value, 
              style: TextStyle(
                color: percentage > 100 ? Colors.blue : Colors.black87,
                fontWeight: FontWeight.bold
              )
            ),
          ],
        ),
        const SizedBox(height: 4),
        Stack(
          children: [
            // Background
            Container(
              height: 12,
              width: double.infinity,
              decoration: BoxDecoration(
                color: color.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            // Progress
            LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  height: 12,
                  width: constraints.maxWidth * (displayPercentage / 100),
                  decoration: BoxDecoration(
                    color: progressColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                );
              },
            ),
          ],
        ),
        if (percentage > 100)
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${percentage.toStringAsFixed(0)}% dari target harian',
              style: TextStyle(
                fontSize: 12,
                color: Colors.blue,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFoodInputSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tambah Makanan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: Colors.blue),
                  onPressed: () => _showFoodSelectionDialog(),
                  tooltip: 'Tambah Makanan',
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Klik tombol + untuk menambahkan makanan yang dikonsumsi hari ini.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConsumedFoodsList() {
    return Obx(() => controller.consumedFoods.isEmpty
        ? const Card(
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'Belum ada makanan yang dicatat hari ini.',
                  style: TextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
          )
        : Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                      color: Colors.blue,
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
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Dismissible(
                          key: UniqueKey(),
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) {
                            controller.removeFood(index);
                          },
                          child: ListTile(
                            title: Text(
                              food.name,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${food.portion}g, ${food.calories.toStringAsFixed(1)} kcal'),
                                Text(
                                  'P: ${food.protein.toStringAsFixed(1)}g, K: ${food.carbs.toStringAsFixed(1)}g, L: ${food.fat.toStringAsFixed(1)}g',
                                ),
                                if (food.consumedAt != null)
                                  Text(
                                    'Dicatat: ${DateFormat('HH:mm').format(food.consumedAt!)}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey,
                                    ),
                                  ),
                              ],
                            ),
                            trailing: const Icon(Icons.swipe_left, color: Colors.grey, size: 16),
                            isThreeLine: true,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  const Center(
                    child: Text(
                      'Geser ke kiri untuk menghapus',
                      style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ));
  }

  void _showFoodSelectionDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: const Row(
                children: [
                  Icon(Icons.restaurant, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Pilih Makanan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(Get.context!).size.height * 0.6,
              ),
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
                    trailing: const Icon(Icons.add_circle_outline, color: Colors.blue),
                    onTap: () {
                      Get.back();
                      _showPortionDialog(food);
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Batal'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPortionDialog(FoodNutrition food) {
    final TextEditingController portionController = TextEditingController();
    portionController.text = food.portion.toString();
    
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tambahkan ${food.name}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Porsi Standar: ${food.portion}g',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: portionController,
                decoration: const InputDecoration(
                  labelText: 'Porsi (gram/ml)',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Pilihan porsi cepat
                  ElevatedButton(
                    onPressed: () {
                      portionController.text = (food.portion / 2).toString();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade100,
                    ),
                    child: Text('½ (${(food.portion / 2).toStringAsFixed(0)}g)'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      portionController.text = food.portion.toString();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade100,
                    ),
                    child: Text('1x (${food.portion.toStringAsFixed(0)}g)'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      portionController.text = (food.portion * 1.5).toString();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade100,
                    ),
                    child: Text('1½ (${(food.portion * 1.5).toStringAsFixed(0)}g)'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text('Batal'),
                  ),
                  const SizedBox(width: 8),
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text('Tambah'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}