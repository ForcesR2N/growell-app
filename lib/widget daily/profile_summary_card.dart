import 'package:flutter/material.dart';
import 'package:growell_app/utils/food_utils.dart';
import 'package:growell_app/widget%20daily/nutrient_summary_box.dart';

import 'app_styles.dart';

class ProfileSummaryCard extends StatelessWidget {
  final String age;
  final String weight;
  final String weightStatus;
  final double targetCalories;
  final double targetProtein;
  final double targetCarbs;
  final double targetFat;
  
  const ProfileSummaryCard({
    Key? key,
    required this.age,
    required this.weight,
    required this.weightStatus,
    required this.targetCalories,
    required this.targetProtein,
    required this.targetCarbs,
    required this.targetFat,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
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
                    'Usia $age bulan',
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'Signika',
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    'Berat $weight kg (${FoodUtils.getWeightStatusText(weightStatus)})',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Signika',
                      color: FoodUtils.getWeightStatusColor(weightStatus),
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
              NutrientSummaryBox(
                title: 'Kalori',
                value: '${targetCalories.toStringAsFixed(0)} kcal',
                icon: Icons.local_fire_department,
                color: AppStyles.warningColor,
              ),
              NutrientSummaryBox(
                title: 'Protein',
                value: '${targetProtein.toStringAsFixed(1)} g',
                icon: Icons.fitness_center,
                color: AppStyles.errorColor,
              ),
              NutrientSummaryBox(
                title: 'Karbo',
                value: '${targetCarbs.toStringAsFixed(1)} g',
                icon: Icons.grain,
                color: AppStyles.successColor,
              ),
              NutrientSummaryBox(
                title: 'Lemak',
                value: '${targetFat.toStringAsFixed(1)} g',
                icon: Icons.opacity,
                color: AppStyles.infoColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}