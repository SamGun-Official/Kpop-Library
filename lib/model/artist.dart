import 'dart:convert';

class Artist {
  final int id;
  final String stageName;
  final String? koreanName;
  final String profileDesc;
  final int debutYear;
  final String careerType;
  final bool activeStatus;

  Artist({
    required this.id,
    required this.stageName,
    required this.koreanName,
    required this.profileDesc,
    required this.debutYear,
    required this.careerType,
    required this.activeStatus,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      id: json['id'],
      stageName: json['stage_name'],
      koreanName: json['korean_name'] ?? "",
      profileDesc: json['profile_desc'],
      debutYear: json['debut_year'],
      careerType: json['career_type'],
      activeStatus: json['active_status'] == 1 ? true : false,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['stage_name'] = stageName;
    data['korean_name'] = koreanName;
    data['profile_desc'] = profileDesc;
    data['debut_year'] = debutYear;
    data['career_type'] = careerType;
    data['active_status'] = activeStatus;
    return data;
  }
}

List<Artist> parseArtists(String? json) {
  if (json == null) {
    return [];
  }
  final List<dynamic> parsed = jsonDecode(json);
  return parsed.map((json) => Artist.fromJson(json)).toList();
}
