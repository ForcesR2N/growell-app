import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:growell_app/models/food_nutrition_model.dart';
import '../controllers/daily_nutrition_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

// Simple styles class that would normally be in a separate file
class AppStyles {
  static const Color primaryColor = Color(0xFF91C788);
  static const Color secondaryColor = Color(0xFFEEF6ED);
  static const Color errorColor = Color(0xFFF44336);
  static const Color warningColor = Color(0xFFFF9800);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color infoColor = Color(0xFF2196F3);

  static BoxDecoration cardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.08),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );

  static BorderRadius defaultRadius = BorderRadius.circular(12);
}

class DailyNutritionPage extends GetView<DailyNutritionController> {
  const DailyNutritionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            const Expanded(
              child: Text(
                'Daily Nutrition',
                style: TextStyle(
                  color: AppStyles.primaryColor,
                  fontSize: 22,
                  fontFamily: 'Signika',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.calendar_today,
                  color: AppStyles.primaryColor),
              onPressed: () => _showDateSelectionDialog(),
            ),
            Container(
              width: 30,
              height: 54,
              margin: const EdgeInsets.only(left: 8),
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
            child: Obx(() => Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 8),
                  child: Text(
                    'Nutrisi Harian - ${controller.dateFormatted.value}',
                    style: const TextStyle(
                      color: Color(0xFF7B7B7B),
                      fontSize: 16,
                      fontFamily: 'Signika',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                )),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
              child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppStyles.primaryColor),
          ));
        }

        return RefreshIndicator(
          onRefresh: () async {
            await controller.loadSavedData();
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Baby Profile Summary Card
                if (controller.targetCalories.value > 0)
                  _buildProfileSummaryCard(),

                // Nutrition Summary Card
                _buildNutritionSummaryCard(),
                const SizedBox(height: 24),

                // Input Data Section
                _buildBabyDataInputSection(),
                const SizedBox(height: 24),

                // Add Food Section
                _buildFoodLogSection(),
                const SizedBox(height: 24),

                // Recommendations based on current nutrition status
                if (controller.targetCalories.value > 0)
                  _buildNutritionRecommendations(),
              ],
            ),
          ),
        );
      }),
      floatingActionButton: Obx(() => controller.consumedFoods.isNotEmpty
          ? FloatingActionButton(
              backgroundColor: AppStyles.primaryColor,
              child: const Icon(Icons.bar_chart),
              onPressed: () => _showNutritionDetails(),
              tooltip: 'Detail Nutrisi',
            )
          : const SizedBox.shrink()),
    );
  }

  Widget _buildProfileSummaryCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEEF6ED), Color(0xFFE1F1DE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.child_care,
                  color: AppStyles.primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Usia ${controller.ageController.text} bulan',
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'Signika',
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    'Berat ${controller.weightController.text} kg (${_getWeightStatusText(controller.weightStatus.value)})',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Signika',
                      color:
                          _getWeightStatusColor(controller.weightStatus.value),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNutrientSummaryBox(
                'Kalori',
                '${controller.targetCalories.value.toStringAsFixed(0)} kcal',
                Icons.local_fire_department,
                AppStyles.warningColor,
              ),
              _buildNutrientSummaryBox(
                'Protein',
                '${controller.targetProtein.value.toStringAsFixed(1)} g',
                Icons.fitness_center,
                AppStyles.errorColor,
              ),
              _buildNutrientSummaryBox(
                'Karbo',
                '${controller.targetCarbs.value.toStringAsFixed(1)} g',
                Icons.grain,
                AppStyles.successColor,
              ),
              _buildNutrientSummaryBox(
                'Lemak',
                '${controller.targetFat.value.toStringAsFixed(1)} g',
                Icons.opacity,
                AppStyles.infoColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNutrientSummaryBox(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'Signika',
              color: Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Signika',
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  String _getWeightStatusText(String status) {
    switch (status) {
      case 'underweight':
        return 'Berat Kurang';
      case 'overweight':
        return 'Berat Lebih';
      case 'normal':
        return 'Berat Normal';
      default:
        return 'Belum dihitung';
    }
  }

  Color _getWeightStatusColor(String status) {
    switch (status) {
      case 'underweight':
        return Colors.orange;
      case 'overweight':
        return Colors.orange;
      case 'normal':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Widget _buildNutritionSummaryCard() {
    final percentages = controller.getNutritionPercentages();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: AppStyles.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.pie_chart,
                    color: AppStyles.primaryColor,
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Progress Nutrisi',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Signika',
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: () => controller.resetDaily(),
                icon: const Icon(
                  Icons.refresh,
                  color: AppStyles.errorColor,
                  size: 18,
                ),
                label: const Text(
                  'Reset',
                  style: TextStyle(
                    color: AppStyles.errorColor,
                    fontSize: 12,
                    fontFamily: 'Signika',
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          controller.targetCalories.value == 0
              ? _buildEmptyState(
                  Icons.info_outline,
                  'Belum ada data nutrisi',
                  'Masukkan usia dan berat bayi terlebih dahulu',
                )
              : SizedBox(
                  height: 240,
                  child: BarChart(_createNutritionBarData(percentages)),
                ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 48,
            color: Colors.grey,
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
              fontFamily: 'Signika',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
              fontFamily: 'Signika',
            ),
          ),
        ],
      ),
    );
  }

  BarChartData _createNutritionBarData(Map<String, double> percentages) {
    return BarChartData(
      alignment: BarChartAlignment.spaceAround,
      maxY: 100,
      barTouchData: BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.white,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            String nutrientName;
            String value;
            Color color;

            switch (group.x) {
              case 0:
                nutrientName = 'Kalori';
                value =
                    '${controller.consumedCalories.value.toStringAsFixed(0)}/${controller.targetCalories.value.toStringAsFixed(0)} kcal';
                color = AppStyles.warningColor;
                break;
              case 1:
                nutrientName = 'Protein';
                value =
                    '${controller.consumedProtein.value.toStringAsFixed(1)}/${controller.targetProtein.value.toStringAsFixed(1)} g';
                color = AppStyles.errorColor;
                break;
              case 2:
                nutrientName = 'Karbo';
                value =
                    '${controller.consumedCarbs.value.toStringAsFixed(1)}/${controller.targetCarbs.value.toStringAsFixed(1)} g';
                color = AppStyles.successColor;
                break;
              default:
                nutrientName = 'Lemak';
                value =
                    '${controller.consumedFat.value.toStringAsFixed(1)}/${controller.targetFat.value.toStringAsFixed(1)} g';
                color = AppStyles.infoColor;
            }

            return BarTooltipItem(
              '$nutrientName\n$value\n${rod.toY.toStringAsFixed(0)}%',
              TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontFamily: 'Signika',
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
            reservedSize: 60,
            getTitlesWidget: (value, meta) {
              IconData icon;
              Color color;
              String text;

              switch (value.toInt()) {
                case 0:
                  icon = Icons.local_fire_department;
                  color = AppStyles.warningColor;
                  text = 'Kalori';
                  break;
                case 1:
                  icon = Icons.fitness_center;
                  color = AppStyles.errorColor;
                  text = 'Protein';
                  break;
                case 2:
                  icon = Icons.grain;
                  color = AppStyles.successColor;
                  text = 'Karbo';
                  break;
                default:
                  icon = Icons.opacity;
                  color = AppStyles.infoColor;
                  text = 'Lemak';
              }

              return Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Column(
                  children: [
                    Icon(icon, color: color, size: 20),
                    const SizedBox(height: 4),
                    Text(
                      text,
                      style: TextStyle(
                        color: color,
                        fontSize: 12,
                        fontFamily: 'Signika',
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  '${value.toInt()}%',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                    fontFamily: 'Signika',
                  ),
                ),
              );
            },
            reservedSize: 36,
          ),
        ),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: false),
      gridData: FlGridData(
        show: true,
        horizontalInterval: 20,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey.withOpacity(0.15),
            strokeWidth: 1,
            dashArray: [5, 5],
          );
        },
        drawVerticalLine: false,
      ),
      barGroups: [
        _createBarGroup(0, percentages['calories']!, AppStyles.warningColor),
        _createBarGroup(1, percentages['protein']!, AppStyles.errorColor),
        _createBarGroup(2, percentages['carbs']!, AppStyles.successColor),
        _createBarGroup(3, percentages['fat']!, AppStyles.infoColor),
      ],
    );
  }

  BarChartGroupData _createBarGroup(int x, double value, Color color) {
    // Cap the value at 100% for visual display
    final displayValue = (value > 100 ? 100 : value).toDouble();

    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: displayValue,
          color: color,
          width: 20,
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

  Widget _buildBabyDataInputSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: AppStyles.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.child_care,
                color: AppStyles.primaryColor,
                size: 22,
              ),
              const SizedBox(width: 8),
              const Text(
                'Data Bayi',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Signika',
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller.ageController,
                  decoration: InputDecoration(
                    labelText: 'Usia (bulan)',
                    labelStyle: const TextStyle(
                      color: AppStyles.primaryColor,
                      fontFamily: 'Signika',
                    ),
                    border: OutlineInputBorder(
                      borderRadius: AppStyles.defaultRadius,
                      borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: AppStyles.defaultRadius,
                      borderSide:
                          const BorderSide(color: AppStyles.primaryColor),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    errorText: controller.ageError.value.isEmpty
                        ? null
                        : controller.ageError.value,
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(2),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: controller.weightController,
                  decoration: InputDecoration(
                    labelText: 'Berat (kg)',
                    labelStyle: const TextStyle(
                      color: AppStyles.primaryColor,
                      fontFamily: 'Signika',
                    ),
                    border: OutlineInputBorder(
                      borderRadius: AppStyles.defaultRadius,
                      borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: AppStyles.defaultRadius,
                      borderSide:
                          const BorderSide(color: AppStyles.primaryColor),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    errorText: controller.weightError.value.isEmpty
                        ? null
                        : controller.weightError.value,
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*\.?\d{0,1}')),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.calculate),
              label: const Text(
                'Hitung Kebutuhan Nutrisi',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Signika',
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppStyles.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: AppStyles.defaultRadius,
                ),
              ),
              onPressed: () {
      // Validasi input terlebih dahulu
      bool isValid = true;
      
      // Validate age
      try {
        final ageNum = int.parse(controller.ageController.text);
        if (ageNum <= 0 || ageNum > 24) {
          controller.ageError.value = 'Usia harus antara 1-24 bulan';
          isValid = false;
        } else {
          controller.ageError.value = '';
        }
      } catch (e) {
        controller.ageError.value = 'Usia tidak valid';
        isValid = false;
      }

      // Validate weight
      try {
        final weightNum = double.parse(controller.weightController.text);
        if (weightNum <= 0 || weightNum > 30) {
          controller.weightError.value = 'Berat badan tidak valid';
          isValid = false;
        } else {
          controller.weightError.value = '';
        }
      } catch (e) {
        controller.weightError.value = 'Berat badan tidak valid';
        isValid = false;
      }
      
      if (!isValid) {
        // Jika validasi gagal, tampilkan snackbar
        Get.snackbar(
          'Validasi',
          'Mohon lengkapi data dengan benar',
          backgroundColor: Colors.red[100],
          colorText: Colors.red[900],
        );
        return;
      }
      
      // Tampilkan loading dialog
      _showLoadingDialog();
      
      // Tunggu 1 detik, lalu hitung kebutuhan nutrisi
      Future.delayed(const Duration(seconds: 1), () {
        // Tutup dialog loading
        Get.back();
        
        // Hitung kebutuhan nutrisi
        controller.calculateRequirements(
          controller.ageController.text,
          controller.weightController.text,
        );
        
        // Tampilkan dialog sukses
        _showSuccessDialog();
      });
    },
  ),
),
        ],
      ),
    );
  }

  void _showLoadingDialog() {
  Get.dialog(
    Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF91C788)),
              strokeWidth: 3,
            ),
            const SizedBox(height: 15),
            const Text(
              'Menghitung...',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Signika',
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    ),
    barrierDismissible: false, // Tidak bisa ditutup selama proses loading
  );
}

  void _showSuccessDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundColor: Color(0xFF91C788),
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Berhasil!',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Signika',
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Kebutuhan nutrisi telah dihitung',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Signika',
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );

    // Tutup dialog setelah 2 detik
    Future.delayed(const Duration(seconds: 2), () {
      Get.back();
    });
  }

  Widget _buildFoodLogSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: AppStyles.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.restaurant,
                    color: AppStyles.primaryColor,
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Catatan Makan',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Signika',
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.history, color: AppStyles.primaryColor),
                onPressed: () => _showFoodLogHistory(),
                tooltip: 'Riwayat Makan',
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Food Log Empty State or Food List
          controller.consumedFoods.isEmpty
              ? _buildEmptyState(
                  Icons.no_food,
                  'Belum ada makanan hari ini',
                  'Tap tombol + untuk menambah makanan',
                )
              : _buildFoodLogList(),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text(
                'Tambah Makanan',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Signika',
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppStyles.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: AppStyles.defaultRadius,
                ),
              ),
              onPressed: () => _showFoodSelectionDialog(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodLogList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.consumedFoods.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final food = controller.consumedFoods[index];
        return Dismissible(
          key: Key('food_${index}_${food.name}'),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              color: Colors.red[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.delete, color: Colors.red),
          ),
          onDismissed: (_) => controller.removeFood(index),
          child: _buildFoodItemCard(food, () => _showFoodDetails(food)),
        );
      },
    );
  }

  Widget _buildFoodItemCard(FoodNutrition food, VoidCallback onTap) {
    final foodGroup = food.foodGroup ?? 'Lainnya';
    final groupColor = _getFoodGroupColor(foodGroup);
    final timeString = food.consumedAt != null
        ? DateFormat('HH:mm').format(food.consumedAt!)
        : 'Hari ini';

    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.withOpacity(0.1)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: groupColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getFoodGroupIcon(foodGroup),
                  color: groupColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      food.name,
                      style: const TextStyle(
                        fontFamily: 'Signika',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '${food.portion.toInt()}g',
                          style: TextStyle(
                            fontFamily: 'Signika',
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                        _buildDot(),
                        Text(
                          '${food.calories.toStringAsFixed(0)} kcal',
                          style: TextStyle(
                            fontFamily: 'Signika',
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                        _buildDot(),
                        Text(
                          timeString,
                          style: TextStyle(
                            fontFamily: 'Signika',
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: groupColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _getFoodGroupTitle(foodGroup),
                  style: TextStyle(
                    fontFamily: 'Signika',
                    fontSize: 12,
                    color: groupColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDot() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: 4,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey[400],
        shape: BoxShape.circle,
      ),
    );
  }

  IconData _getFoodGroupIcon(String foodGroup) {
    switch (foodGroup) {
      case 'Fruit':
        return Icons.apple;
      case 'Vegetable':
        return Icons.spa;
      case 'Grain':
        return Icons.grain;
      case 'Protein':
        return Icons.egg_alt;
      case 'Dairy':
        return Icons.coffee;
      default:
        return Icons.restaurant;
    }
  }

  Color _getFoodGroupColor(String foodGroup) {
    switch (foodGroup) {
      case 'Fruit':
        return Colors.orange;
      case 'Vegetable':
        return Colors.green;
      case 'Grain':
        return Colors.brown;
      case 'Protein':
        return Colors.red;
      case 'Dairy':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _getFoodGroupTitle(String foodGroup) {
    switch (foodGroup) {
      case 'Fruit':
        return 'Buah';
      case 'Vegetable':
        return 'Sayuran';
      case 'Grain':
        return 'Biji-bijian';
      case 'Protein':
        return 'Protein';
      case 'Dairy':
        return 'Susu & Olahan';
      default:
        return 'Lainnya';
    }
  }

  Widget _buildNutritionRecommendations() {
    final percentages = controller.getNutritionPercentages();

    // Find the nutrient with the lowest percentage
    String lowestNutrient = 'protein';
    double lowestPercentage = percentages['protein']!;

    if (percentages['carbs']! < lowestPercentage) {
      lowestNutrient = 'carbs';
      lowestPercentage = percentages['carbs']!;
    }

    if (percentages['fat']! < lowestPercentage) {
      lowestNutrient = 'fat';
      lowestPercentage = percentages['fat']!;
    }

    // Skip recommendations if we have > 70% of everything
    if (lowestPercentage > 70) {
      return const SizedBox.shrink();
    }

    // Get food recommendations based on the nutrient that's lacking
    List<FoodNutrition> recommendedFoods = [];
    String nutrientName = '';

    switch (lowestNutrient) {
      case 'protein':
        recommendedFoods =
            CommonBabyFood.getFoodsHighIn('protein').take(3).toList();
        nutrientName = 'Protein';
        break;
      case 'carbs':
        recommendedFoods =
            CommonBabyFood.getFoodsByGroup('Grain').take(3).toList();
        nutrientName = 'Karbohidrat';
        break;
      case 'fat':
        // Foods high in healthy fats
        recommendedFoods = CommonBabyFood.basicFoods
            .where((food) => food.fat > 3.0)
            .take(3)
            .toList();
        nutrientName = 'Lemak';
        break;
    }

    if (recommendedFoods.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: AppStyles.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.lightbulb_outline,
                color: Colors.orange,
                size: 22,
              ),
              const SizedBox(width: 8),
              const Text(
                'Rekomendasi Makanan',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Signika',
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildRecommendationAlert(nutrientName),
          const SizedBox(height: 16),
          ...recommendedFoods
              .map((food) => _buildRecommendedFoodItem(food, lowestNutrient)),
        ],
      ),
    );
  }

  Widget _buildRecommendationAlert(String nutrientName) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline,
            color: Color(0xFFFF9800),
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Si kecil masih kurang asupan $nutrientName. Berikut beberapa makanan yang bisa ditambahkan:',
              style: const TextStyle(
                color: Color(0xFF6F6F6F),
                fontSize: 14,
                fontFamily: 'Signika',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedFoodItem(FoodNutrition food, String focusNutrient) {
    final foodGroup = food.foodGroup ?? 'Lainnya';
    final groupColor = _getFoodGroupColor(foodGroup);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: groupColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          _getFoodGroupIcon(foodGroup),
          color: groupColor,
          size: 24,
        ),
      ),
      title: Text(
        food.name,
        style: const TextStyle(
          fontFamily: 'Signika',
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: _buildFoodNutrientInfo(food, focusNutrient),
      trailing: IconButton(
        icon: const Icon(
          Icons.add_circle_outline,
          color: AppStyles.primaryColor,
        ),
        onPressed: () => _showPortionDialog(food),
      ),
      onTap: () => _showFoodDetails(food),
    );
  }

  Widget _buildFoodNutrientInfo(FoodNutrition food, String focusNutrient) {
    switch (focusNutrient) {
      case 'protein':
        return Text(
          'Protein: ${food.protein.toStringAsFixed(1)}g per ${food.portion.toInt()}g',
          style: TextStyle(
            fontFamily: 'Signika',
            fontSize: 13,
            color: Colors.grey[600],
          ),
        );
      case 'carbs':
        return Text(
          'Karbohidrat: ${food.carbs.toStringAsFixed(1)}g per ${food.portion.toInt()}g',
          style: TextStyle(
            fontFamily: 'Signika',
            fontSize: 13,
            color: Colors.grey[600],
          ),
        );
      case 'fat':
        return Text(
          'Lemak: ${food.fat.toStringAsFixed(1)}g per ${food.portion.toInt()}g',
          style: TextStyle(
            fontFamily: 'Signika',
            fontSize: 13,
            color: Colors.grey[600],
          ),
        );
      default:
        return Text(
          'Kalori: ${food.calories.toStringAsFixed(0)} kcal per ${food.portion.toInt()}g',
          style: TextStyle(
            fontFamily: 'Signika',
            fontSize: 13,
            color: Colors.grey[600],
          ),
        );
    }
  }

  void _showNutritionDetails() {
    final percentages = controller.getNutritionPercentages();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: double.infinity,
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
                  color: AppStyles.primaryColor,
                ),
              ),
              const SizedBox(height: 24),
              _buildNutrientProgressBar(
                'Kalori',
                '${controller.consumedCalories.value.toStringAsFixed(0)}/${controller.targetCalories.value.toStringAsFixed(0)} kcal',
                percentages['calories']!,
                AppStyles.warningColor,
                Icons.local_fire_department,
              ),
              const SizedBox(height: 16),
              _buildNutrientProgressBar(
                'Protein',
                '${controller.consumedProtein.value.toStringAsFixed(1)}/${controller.targetProtein.value.toStringAsFixed(1)} g',
                percentages['protein']!,
                AppStyles.errorColor,
                Icons.fitness_center,
              ),
              const SizedBox(height: 16),
              _buildNutrientProgressBar(
                'Karbohidrat',
                '${controller.consumedCarbs.value.toStringAsFixed(1)}/${controller.targetCarbs.value.toStringAsFixed(1)} g',
                percentages['carbs']!,
                AppStyles.successColor,
                Icons.grain,
              ),
              const SizedBox(height: 16),
              _buildNutrientProgressBar(
                'Lemak',
                '${controller.consumedFat.value.toStringAsFixed(1)}/${controller.targetFat.value.toStringAsFixed(1)} g',
                percentages['fat']!,
                AppStyles.infoColor,
                Icons.opacity,
              ),

              // Add other nutrients if available (micronutrients)
              if (controller.targetIron.value > 0) ...[
                const SizedBox(height: 16),
                _buildNutrientProgressBar(
                  'Zat Besi',
                  '${controller.consumedIron.value.toStringAsFixed(1)}/${controller.targetIron.value.toStringAsFixed(1)} mg',
                  percentages['iron']!,
                  Colors.brown,
                  Icons.bloodtype,
                ),
              ],

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      Get.back();
                      controller.resetDaily();
                    },
                    icon: const Icon(
                      Icons.refresh,
                      color: AppStyles.errorColor,
                      size: 18,
                    ),
                    label: const Text(
                      'Reset',
                      style: TextStyle(
                        color: AppStyles.errorColor,
                        fontFamily: 'Signika',
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppStyles.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Tutup'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNutrientProgressBar(String label, String value,
      double percentage, Color color, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Signika',
                  fontWeight: FontWeight.w500,
                ),
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
              width: (Get.width - 48) *
                  (percentage / 100 > 1 ? 1 : percentage / 100),
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
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: Get.width * 0.9,
          constraints: BoxConstraints(
            maxHeight: Get.height * 0.8,
            maxWidth: 400,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: AppStyles.primaryColor,
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
              Container(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Cari makanan...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onChanged: (value) {
                    // Filter foods (in a real implementation)
                  },
                ),
              ),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: CommonBabyFood.basicFoods.length,
                  itemBuilder: (context, index) {
                    final food = CommonBabyFood.basicFoods[index];
                    final foodGroup = food.foodGroup ?? 'Lainnya';
                    final groupColor = _getFoodGroupColor(foodGroup);

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
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: groupColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            _getFoodGroupIcon(foodGroup),
                            color: groupColor,
                            size: 20,
                          ),
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
                          'Per ${food.portion}g: ${food.calories.toStringAsFixed(0)} kcal, P:${food.protein.toStringAsFixed(1)}g',
                          style: TextStyle(
                            fontFamily: 'Signika',
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                        trailing: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppStyles.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: AppStyles.primaryColor,
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

  Widget _buildNutrientBubble(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'Signika',
              color: color,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'Signika',
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
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
          color: AppStyles.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: AppStyles.primaryColor,
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

  void _showPortionDialog(FoodNutrition food) {
    final TextEditingController portionController = TextEditingController();
    portionController.text = food.portion.toString();
    final foodGroup = food.foodGroup ?? 'Lainnya';
    final groupColor = _getFoodGroupColor(foodGroup);

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: Get.width * 0.9,
          constraints: const BoxConstraints(
            maxWidth: 400,
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: groupColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _getFoodGroupIcon(foodGroup),
                      color: groupColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
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
                            color: AppStyles.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Porsi Standar: ${food.portion.toInt()}g',
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
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppStyles.secondaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Informasi Nutrisi (per 100g):',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Signika',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildNutrientBubble(
                            'Kalori',
                            '${(food.calories / food.portion * 100).toStringAsFixed(0)} kcal',
                            AppStyles.warningColor),
                        _buildNutrientBubble(
                            'Protein',
                            '${(food.protein / food.portion * 100).toStringAsFixed(1)}g',
                            AppStyles.errorColor),
                        _buildNutrientBubble(
                            'Karbo',
                            '${(food.carbs / food.portion * 100).toStringAsFixed(1)}g',
                            AppStyles.successColor),
                        _buildNutrientBubble(
                            'Lemak',
                            '${(food.fat / food.portion * 100).toStringAsFixed(1)}g',
                            AppStyles.infoColor),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: portionController,
                decoration: InputDecoration(
                  labelText: 'Porsi (gram)',
                  labelStyle: const TextStyle(
                    color: AppStyles.primaryColor,
                    fontFamily: 'Signika',
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppStyles.primaryColor),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,1}')),
                ],
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
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppStyles.primaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Batal',
                        style: TextStyle(
                          color: AppStyles.primaryColor,
                          fontSize: 16,
                          fontFamily: 'Signika',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (portionController.text.isNotEmpty) {
                          final portion =
                              double.tryParse(portionController.text);
                          if (portion != null && portion > 0) {
                            controller.addFood(food, portion);
                            Get.back();
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppStyles.primaryColor,
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFoodDetails(FoodNutrition food) {
    final foodGroup = food.foodGroup ?? 'Lainnya';
    final groupColor = _getFoodGroupColor(foodGroup);

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: groupColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _getFoodGroupIcon(foodGroup),
                      color: groupColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
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
                            color: AppStyles.primaryColor,
                          ),
                        ),
                        Text(
                          _getFoodGroupTitle(foodGroup),
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Signika',
                            color: groupColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Informasi Nutrisi (per 100g)',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Signika',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              _buildNutrientTable(food),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppStyles.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Tutup'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNutrientTable(FoodNutrition food) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1.5),
        1: FlexColumnWidth(1),
      },
      children: [
        _buildTableRow(
            'Kalori',
            '${(food.calories / food.portion * 100).toStringAsFixed(0)} kcal',
            AppStyles.warningColor),
        _buildTableRow(
            'Protein',
            '${(food.protein / food.portion * 100).toStringAsFixed(1)} g',
            AppStyles.errorColor),
        _buildTableRow(
            'Karbohidrat',
            '${(food.carbs / food.portion * 100).toStringAsFixed(1)} g',
            AppStyles.successColor),
        _buildTableRow(
            'Lemak',
            '${(food.fat / food.portion * 100).toStringAsFixed(1)} g',
            AppStyles.infoColor),
        if (food.iron != null && food.iron! > 0)
          _buildTableRow(
              'Zat Besi',
              '${(food.iron! / food.portion * 100).toStringAsFixed(1)} mg',
              Colors.brown),
        if (food.calcium != null && food.calcium! > 0)
          _buildTableRow(
              'Kalsium',
              '${(food.calcium! / food.portion * 100).toStringAsFixed(0)} mg',
              Colors.purple),
        if (food.vitaminD != null && food.vitaminD! > 0)
          _buildTableRow(
              'Vitamin D',
              '${(food.vitaminD! / food.portion * 100).toStringAsFixed(1)} mcg',
              Colors.yellow[800]!),
        if (food.zinc != null && food.zinc! > 0)
          _buildTableRow(
              'Seng',
              '${(food.zinc! / food.portion * 100).toStringAsFixed(1)} mg',
              Colors.blueGrey),
        if (food.fiber != null && food.fiber! > 0)
          _buildTableRow(
              'Serat',
              '${(food.fiber! / food.portion * 100).toStringAsFixed(1)} g',
              Colors.green[800]!),
      ],
    );
  }

  TableRow _buildTableRow(String label, String value, Color color) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Signika',
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Signika',
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  void _showDateSelectionDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Pilih Tanggal',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Signika',
                  fontWeight: FontWeight.w600,
                  color: AppStyles.primaryColor,
                ),
              ),
              const SizedBox(height: 24),
              CalendarDatePicker(
                initialDate: controller.currentDate.value,
                firstDate: DateTime.now().subtract(const Duration(days: 30)),
                lastDate: DateTime.now(),
                onDateChanged: (date) {
                  controller.currentDate.value = date;
                  controller.dateFormatted.value =
                      DateFormat('dd MMMM yyyy').format(date);
                  // In a real app you would load the data for this date
                  Get.back();
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text('Batal'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFoodLogHistory() {
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
                'Riwayat Makan Hari Ini',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Signika',
                  fontWeight: FontWeight.w600,
                  color: AppStyles.primaryColor,
                ),
              ),
              const SizedBox(height: 16),
              controller.consumedFoods.isEmpty
                  ? _buildEmptyState(
                      Icons.no_food,
                      'Belum ada makanan dicatat hari ini',
                      'Tambahkan makanan untuk melihat riwayat',
                    )
                  : SizedBox(
                      height: 300,
                      child: ListView.separated(
                        itemCount: controller.consumedFoods.length,
                        separatorBuilder: (context, index) =>
                            const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final food = controller.consumedFoods[index];
                          return _buildFoodItemCard(
                            food,
                            () {
                              Get.back();
                              _showFoodDetails(food);
                            },
                          );
                        },
                      ),
                    ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      Get.back();
                      controller.resetDaily();
                    },
                    icon: const Icon(
                      Icons.delete_sweep,
                      color: AppStyles.errorColor,
                      size: 18,
                    ),
                    label: const Text(
                      'Hapus Semua',
                      style: TextStyle(
                        color: AppStyles.errorColor,
                        fontFamily: 'Signika',
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppStyles.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Tutup'),
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
