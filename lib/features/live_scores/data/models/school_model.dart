import '../../domain/entities/school.dart';

/// School data model with Laravel JSON serialization
class SchoolModel extends School {
  const SchoolModel({
    required super.id,
    required super.name,
    required super.shortName,
    required super.region,
    super.crestUrl,
    super.titlesCount,
  });

  factory SchoolModel.fromJson(Map<String, dynamic> json) {
    return SchoolModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      shortName: json['short_name'] as String? ?? '',
      region: json['region'] as String? ?? '',
      crestUrl: json['crest_url'] as String?,
      titlesCount: json['titles_count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'short_name': shortName,
      'region': region,
      'crest_url': crestUrl,
      'titles_count': titlesCount,
    };
  }
}
