/// Model for category from API
/// GET /api/v1/categories
class CategoryApiModel {
  final String id;
  final String name;
  final String? icon;
  final String? color;

  const CategoryApiModel({
    required this.id,
    required this.name,
    this.icon,
    this.color,
  });

  factory CategoryApiModel.fromJson(Map<String, dynamic> json) {
    return CategoryApiModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      icon: json['icon'] as String?,
      color: json['color'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (icon != null) 'icon': icon,
      if (color != null) 'color': color,
    };
  }
}

/// Response wrapper for categories list
class CategoriesResponse {
  final List<CategoryApiModel> categories;

  const CategoriesResponse({required this.categories});

  factory CategoriesResponse.fromJson(Map<String, dynamic> json) {
    final categoriesList = json['categories'] as List<dynamic>? ??
                           json['data'] as List<dynamic>? ?? [];
    return CategoriesResponse(
      categories: categoriesList
          .map((e) => CategoryApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Parse directly from list response
  factory CategoriesResponse.fromList(List<dynamic> list) {
    return CategoriesResponse(
      categories: list
          .map((e) => CategoryApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

