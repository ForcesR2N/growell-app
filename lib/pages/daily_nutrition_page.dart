import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:growell_app/models/food_nutrition_model.dart';
import '../controllers/daily_nutrition_controller.dart';
import 'package:fl_chart/fl_chart.dart';

class DailyNutritionPage extends GetView<DailyNutritionController> {
  DailyNutritionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Expanded(
              child: const Text(
                'Daily',
                style: TextStyle(
                  color: Color(0xFF91C788),
                  fontSize: 25,
                  fontFamily: 'Signika',
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.24,
                ),
              ),
            ),
            Container(
              width: 30,
              height: 54,
              margin: const EdgeInsets.only(left: 16),
              child: Image.asset(
                'assets/images/logo_app.png',
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 8),
              child: Text(
                'Progress Nutrisi Harian',
                style: TextStyle(
                  color: Color(0xFF7B7B7B),
                  fontSize: 18,
                  fontFamily: 'Signika',
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.24,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildNutritionSummaryCard(),
              const SizedBox(height: 24),

              // Input Data Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 4,
                      offset: const Offset(2, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Input Data Bayi',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controller.ageController,
                            decoration: const InputDecoration(
                              labelText: 'Usia (bulan)',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: controller.weightController,
                            decoration: const InputDecoration(
                              labelText: 'Berat (kg)',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Container(
                        width: 132,
                        height: 33,
                        child: ElevatedButton(
                          onPressed: () {
                            controller.calculateRequirements(
                              controller.ageController.text,
                              controller.weightController.text,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0F663E),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 4,
                          ),
                          child: const Text(
                            'Hitung',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Add Food Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 4,
                      offset: const Offset(2, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tambah Makanan',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Container(
                        width: 132,
                        height: 33,
                        child: ElevatedButton(
                          onPressed: () => _showFoodSelectionDialog(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0F663E),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 4,
                          ),
                          child: const Text(
                            'Tambah',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Food List Section (Moved here)
              if (controller.consumedFoods.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.only(left: 4, bottom: 8),
                  child: Text(
                    'Makanan Hari Ini',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  height: 94,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      for (var food in controller.consumedFoods)
                        Container(
                          width: 175.70,
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 10),
                          decoration: ShapeDecoration(
                            color: const Color(0xFFFBF6F2),
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  width: 1, color: Color(0xFFCA4B00)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            shadows: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFCA4B00),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.restaurant,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Container(
                                  height: 44,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFCA4B00),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      food.name,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily: 'Nunito',
                                        fontWeight: FontWeight.w700,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ],
          ),
        );
      }),
    );
  }

  Widget _buildNutritionSummaryCard() {
    final percentages = controller.getNutritionPercentages();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.black.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Nutrisi harian',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: () => controller.resetDaily(),
                    icon: const Icon(
                      Icons.refresh,
                      color: Color(0xFFF44336),
                      size: 18,
                    ),
                    label: const Text(
                      'Reset',
                      style: TextStyle(
                        color: Color(0xFFF44336),
                        fontSize: 12,
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                  ),
                  TextButton(
                    onPressed: () => _showNutritionDetails(),
                    child: const Text(
                      'Details >>',
                      style: TextStyle(
                        color: Color(0xFF2AC27A),
                        fontSize: 12,
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 100,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: Colors.white,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      String nutrientName;
                      String value;
                      switch (group.x) {
                        case 0:
                          nutrientName = 'Kalori';
                          value =
                              '${controller.consumedCalories.value.toStringAsFixed(0)}/${controller.targetCalories.value.toStringAsFixed(0)} kcal';
                          break;
                        case 1:
                          nutrientName = 'Protein';
                          value =
                              '${controller.consumedProtein.value.toStringAsFixed(1)}/${controller.targetProtein.value.toStringAsFixed(1)} g';
                          break;
                        case 2:
                          nutrientName = 'Karbo';
                          value =
                              '${controller.consumedCarbs.value.toStringAsFixed(1)}/${controller.targetCarbs.value.toStringAsFixed(1)} g';
                          break;
                        default:
                          nutrientName = 'Lemak';
                          value =
                              '${controller.consumedFat.value.toStringAsFixed(1)}/${controller.targetFat.value.toStringAsFixed(1)} g';
                      }
                      return BarTooltipItem(
                        '$nutrientName\n$value',
                        const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        String text;
                        switch (value.toInt()) {
                          case 0:
                            text = 'Kalori';
                            break;
                          case 1:
                            text = 'Protein';
                            break;
                          case 2:
                            text = 'Karbo';
                            break;
                          default:
                            text = 'Lemak';
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            text,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontFamily: 'Open Sans',
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}%',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                          ),
                        );
                      },
                      reservedSize: 30,
                    ),
                  ),
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(show: false),
                barGroups: [
                  _createBarGroup(
                      0, percentages['calories']!, const Color(0xFFFF9800)),
                  _createBarGroup(
                      1, percentages['protein']!, const Color(0xFFF44336)),
                  _createBarGroup(
                      2, percentages['carbs']!, const Color(0xFF4CAF50)),
                  _createBarGroup(
                      3, percentages['fat']!, const Color(0xFF2196F3)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _createBarGroup(int x, double value, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: value,
          color: color,
          width: 15,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 100,
            color: color.withOpacity(0.1),
          ),
        ),
      ],
    );
  }

  void _showNutritionDetails() {
    final percentages = controller.getNutritionPercentages();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Detail Nutrisi Harian',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Signika',
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF91C788),
                ),
              ),
              const SizedBox(height: 24),
              _buildDetailRow(
                'Kalori',
                '${controller.consumedCalories.value.toStringAsFixed(0)}/${controller.targetCalories.value.toStringAsFixed(0)} kcal',
                percentages['calories']!,
                const Color(0xFFFF9800),
              ),
              const SizedBox(height: 16),
              _buildDetailRow(
                'Protein',
                '${controller.consumedProtein.value.toStringAsFixed(1)}/${controller.targetProtein.value.toStringAsFixed(1)} g',
                percentages['protein']!,
                const Color(0xFFF44336),
              ),
              const SizedBox(height: 16),
              _buildDetailRow(
                'Karbohidrat',
                '${controller.consumedCarbs.value.toStringAsFixed(1)}/${controller.targetCarbs.value.toStringAsFixed(1)} g',
                percentages['carbs']!,
                const Color(0xFF4CAF50),
              ),
              const SizedBox(height: 16),
              _buildDetailRow(
                'Lemak',
                '${controller.consumedFat.value.toStringAsFixed(1)}/${controller.targetFat.value.toStringAsFixed(1)} g',
                percentages['fat']!,
                const Color(0xFF2196F3),
              ),
              const SizedBox(height: 24),
              Center(
                child: TextButton(
                  onPressed: () => Get.back(),
                  child: const Text('Tutup'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
      String label, String value, double percentage, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'Signika',
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'Signika',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            Container(
              height: 8,
              width: double.infinity,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Container(
              height: 8,
              width: (Get.width - 48) * (percentage / 100),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '${percentage.toStringAsFixed(1)}%',
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  void _showFoodSelectionDialog() {
    final size = MediaQuery.of(Get.context!).size;
    final isSmallScreen = size.width < 360;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: size.width * 0.9,
          constraints: BoxConstraints(
            maxHeight: size.height * 0.8,
            maxWidth: 400,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                decoration: const BoxDecoration(
                  color: Color(0xFF91C788),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.restaurant, color: Colors.white),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Pilih Makanan',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Signika',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Get.back(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: CommonBabyFood.basicFoods.length,
                  itemBuilder: (context, index) {
                    final food = CommonBabyFood.basicFoods[index];
                    return Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: isSmallScreen ? 12 : 16,
                          vertical: isSmallScreen ? 4 : 8,
                        ),
                        title: Text(
                          food.name,
                          style: const TextStyle(
                            fontFamily: 'Signika',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          'Per ${food.portion}g: ${food.calories.toStringAsFixed(1)} kcal',
                          style: TextStyle(
                            fontFamily: 'Signika',
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        trailing: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: const Color(0xFF91C788).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Color(0xFF91C788),
                            size: 20,
                          ),
                        ),
                        onTap: () {
                          Get.back();
                          _showPortionDialog(food);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPortionDialog(FoodNutrition food) {
    final TextEditingController portionController = TextEditingController();
    portionController.text = food.portion.toString();
    final size = MediaQuery.of(Get.context!).size;
    final isSmallScreen = size.width < 360;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: size.width * 0.9,
          constraints: BoxConstraints(
            maxWidth: 400,
          ),
          padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          food.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontFamily: 'Signika',
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF91C788),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Porsi Standar: ${food.portion}g',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Signika',
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Get.back(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                controller: portionController,
                decoration: InputDecoration(
                  labelText: 'Porsi (gram)',
                  labelStyle: const TextStyle(
                    color: Color(0xFF91C788),
                    fontFamily: 'Signika',
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF91C788)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildPortionButton(
                      '½ porsi',
                      '${(food.portion / 2).toStringAsFixed(0)}g',
                      () => portionController.text =
                          (food.portion / 2).toString(),
                    ),
                    const SizedBox(width: 8),
                    _buildPortionButton(
                      '1 porsi',
                      '${food.portion.toStringAsFixed(0)}g',
                      () => portionController.text = food.portion.toString(),
                    ),
                    const SizedBox(width: 8),
                    _buildPortionButton(
                      '1½ porsi',
                      '${(food.portion * 1.5).toStringAsFixed(0)}g',
                      () => portionController.text =
                          (food.portion * 1.5).toString(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF91C788)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Batal',
                          style: TextStyle(
                            color: Color(0xFF91C788),
                            fontSize: 16,
                            fontFamily: 'Signika',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          if (portionController.text.isNotEmpty) {
                            final portion =
                                double.tryParse(portionController.text);
                            if (portion != null && portion > 0) {
                              controller.addFood(food, portion);
                              Get.back();
                              Get.back(); // Tutup dialog pemilihan makanan juga
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF91C788),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Tambah',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Signika',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPortionButton(
      String title, String subtitle, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF91C788).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF91C788),
                fontSize: 14,
                fontFamily: 'Signika',
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
                fontFamily: 'Signika',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
