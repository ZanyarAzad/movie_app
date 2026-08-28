import '../../core/constants/api_constants.dart';

class CastModel {
  final int id;
  final String name;
  final String? character;
  final String? profilePath;
  final int order;

  const CastModel({
    required this.id,
    required this.name,
    this.character,
    this.profilePath,
    this.order = 0,
  });

  factory CastModel.fromJson(Map<String, dynamic> json) {
    return CastModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      character: json['character'] as String?,
      profilePath: json['profile_path'] as String?,
      order: json['order'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'character': character,
      'profile_path': profilePath,
      'order': order,
    };
  }

  String get profileUrl => ApiConstants.getProfileUrl(profilePath);
}

class CrewModel {
  final int id;
  final String name;
  final String? job;
  final String? department;
  final String? profilePath;

  const CrewModel({
    required this.id,
    required this.name,
    this.job,
    this.department,
    this.profilePath,
  });

  factory CrewModel.fromJson(Map<String, dynamic> json) {
    return CrewModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      job: json['job'] as String?,
      department: json['department'] as String?,
      profilePath: json['profile_path'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'job': job,
      'department': department,
      'profile_path': profilePath,
    };
  }

  String get profileUrl => ApiConstants.getProfileUrl(profilePath);
}
