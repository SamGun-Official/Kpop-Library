import 'dart:convert';

class Discography {
  final int id;
  final int artistID;
  final String title;
  final String category;
  final String releaseDate;
  final int year;
  final String countryOrigin;
  final String publisher;
  final int? totalDisc;

  Discography({
    required this.id,
    required this.artistID,
    required this.title,
    required this.category,
    required this.releaseDate,
    required this.year,
    required this.countryOrigin,
    required this.publisher,
    required this.totalDisc,
  });

  factory Discography.fromJson(Map<String, dynamic> json) {
    return Discography(
      id: json['id'],
      artistID: json['artist_id'],
      title: json['title'],
      category: json['category'],
      releaseDate: json['release_date'],
      year: json['year'],
      countryOrigin: json['country_origin'],
      publisher: json['publisher'],
      totalDisc: json['total_disc'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['artist_id'] = artistID;
    data['title'] = title;
    data['category'] = category;
    data['release_date'] = releaseDate;
    data['year'] = year;
    data['country_origin'] = countryOrigin;
    data['publisher'] = publisher;
    data['total_disc'] = totalDisc;
    return data;
  }
}

List<Discography> parseDiscographies(String? json) {
  if (json == null) {
    return [];
  }
  final List<dynamic> parsed = jsonDecode(json);
  return parsed.map((json) => Discography.fromJson(json)).toList();
}
