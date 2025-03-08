import 'package:flutter/material.dart';
import 'package:growell_app/models/food_nutrition_model.dart';
import 'package:growell_app/utils/food_utils.dart';
import 'package:intl/intl.dart';

class FoodItemCard extends StatelessWidget {
  final FoodNutrition food;
  final VoidCallback onTap;
  final VoidCallback? onDelete;
  
  const FoodItemCard({
    Key? key,
    required this.food,
    required this.onTap,
    this.onDelete,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final foodGroup = food.foodGroup ?? 'Lainnya';
    final groupColor = FoodUtils.getFoodGroupColor(foodGroup);
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
                  FoodUtils.getFoodGroupIcon(foodGroup),
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
                  foodGroup,
                  style: TextStyle(
                    fontFamily: 'Signika',
                    fontSize: 12,
                    color: groupColor,
                  ),
                ),
              ),
              if (onDelete != null) ...[
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                  onPressed: onDelete,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
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
}
