class BabyProfile {
  final String? id;
  final String userId;
  final String name;
  final int age;
  final double weight;
  final String gender;
  final int mealsPerDay;
  final bool hasAllergy;
  final double activityLevel;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BabyProfile({
    this.id,
    required this.userId,
    required this.name,
    required this.age,
    required this.weight,
    required this.gender,
    required this.mealsPerDay,
    required this.hasAllergy,
    required this.activityLevel,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'name': name,
    'age': age,
    'weight': weight,
    'gender': gender,
    'mealsPerDay': mealsPerDay,
    'hasAllergy': hasAllergy,
    'activityLevel': activityLevel,
    'createdAt': createdAt ?? DateTime.now(),
    'updatedAt': DateTime.now(),
  };

  factory BabyProfile.fromJson(Map<String, dynamic> json) => BabyProfile(
    id: json['id'],
    userId: json['userId'],
    name: json['name'],
    age: json['age'],
    weight: json['weight'].toDouble(),
    gender: json['gender'],
    mealsPerDay: json['mealsPerDay'],
    hasAllergy: json['hasAllergy'],
    activityLevel: json['activityLevel'].toDouble(),
    createdAt: json['createdAt']?.toDate(),
    updatedAt: json['updatedAt']?.toDate(),
  );
}