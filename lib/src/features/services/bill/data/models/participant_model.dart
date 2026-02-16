import '../../domain/entities/participant.dart';

/// Participant model for API serialization
class ParticipantModel extends ParticipantEntity {
  const ParticipantModel({
    required super.id,
    required super.name,
    super.avatarUrl,
    super.shareAmount,
    super.sharePercentage,
    super.hasPaid,
    super.isCurrentUser,
  });

  /// Create ParticipantModel from JSON
  factory ParticipantModel.fromJson(Map<String, dynamic> json) {
    return ParticipantModel(
      id:
          json['id'] as String? ??
          json['_id'] as String? ??
          json['userId'] as String? ??
          '',
      name: json['name'] as String? ?? json['userName'] as String? ?? '',
      avatarUrl:
          json['avatarUrl'] as String? ??
          json['avatar'] as String? ??
          json['image'] as String?,
      shareAmount:
          (json['shareAmount'] as num?)?.toDouble() ??
          (json['share'] as num?)?.toDouble() ??
          0.0,
      sharePercentage:
          (json['sharePercentage'] as num?)?.toDouble() ??
          (json['percentage'] as num?)?.toDouble() ??
          0.0,
      hasPaid: json['hasPaid'] as bool? ?? json['paid'] as bool? ?? false,
      isCurrentUser:
          json['isCurrentUser'] as bool? ?? json['isMe'] as bool? ?? false,
    );
  }

  /// Convert to JSON for API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (avatarUrl != null) 'avatarUrl': avatarUrl,
      'shareAmount': shareAmount,
      'sharePercentage': sharePercentage,
      'hasPaid': hasPaid,
      'isCurrentUser': isCurrentUser,
    };
  }

  /// Create from entity
  factory ParticipantModel.fromEntity(ParticipantEntity entity) {
    return ParticipantModel(
      id: entity.id,
      name: entity.name,
      avatarUrl: entity.avatarUrl,
      shareAmount: entity.shareAmount,
      sharePercentage: entity.sharePercentage,
      hasPaid: entity.hasPaid,
      isCurrentUser: entity.isCurrentUser,
    );
  }
}
