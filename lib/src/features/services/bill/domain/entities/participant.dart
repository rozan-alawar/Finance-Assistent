import 'package:flutter/material.dart';

/// Custom item for custom split
class SplitItem {
  final String id;
  final String name;
  final double amount;

  const SplitItem({required this.id, this.name = '', this.amount = 0.0});

  SplitItem copyWith({String? id, String? name, double? amount}) {
    return SplitItem(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
    );
  }
}

/// Participant entity for group bills
class ParticipantEntity {
  final String id;
  final String name;
  final String? avatarUrl;
  final double shareAmount;
  final double sharePercentage;
  final bool hasPaid;
  final bool isCurrentUser;
  final Color avatarColor;
  final List<SplitItem> items;
  final bool isExpanded;

  const ParticipantEntity({
    required this.id,
    required this.name,
    this.avatarUrl,
    this.shareAmount = 0.0,
    this.sharePercentage = 0.0,
    this.hasPaid = false,
    this.isCurrentUser = false,
    this.avatarColor = const Color(0xFF3447AA),
    this.items = const [],
    this.isExpanded = false,
  });

  ParticipantEntity copyWith({
    String? id,
    String? name,
    String? avatarUrl,
    double? shareAmount,
    double? sharePercentage,
    bool? hasPaid,
    bool? isCurrentUser,
    Color? avatarColor,
    List<SplitItem>? items,
    bool? isExpanded,
  }) {
    return ParticipantEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      shareAmount: shareAmount ?? this.shareAmount,
      sharePercentage: sharePercentage ?? this.sharePercentage,
      hasPaid: hasPaid ?? this.hasPaid,
      isCurrentUser: isCurrentUser ?? this.isCurrentUser,
      avatarColor: avatarColor ?? this.avatarColor,
      items: items ?? this.items,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }

  /// Get initials from name
  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  /// Calculate subtotal from items
  double get itemsSubtotal {
    double total = 0.0;
    for (final item in items) {
      total += item.amount;
    }
    return total;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ParticipantEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Avatar colors for participants
class ParticipantColors {
  static const List<Color> colors = [
    Color(0xFF3447AA), // Primary blue (for current user)
    Color(0xFFFFB74D), // Orange
    Color(0xFF81C784), // Green
    Color(0xFFE57373), // Red
    Color(0xFF64B5F6), // Light blue
    Color(0xFFBA68C8), // Purple
    Color(0xFF4DB6AC), // Teal
    Color(0xFFFFD54F), // Yellow
  ];

  static Color getColor(int index) {
    return colors[index % colors.length];
  }
}
