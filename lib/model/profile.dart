import 'dart:convert';

class Profile {
  final int id;
  final int artistID;
  final String profilePicURL;

  Profile({
    required this.id,
    required this.artistID,
    required this.profilePicURL,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      artistID: json['artist_id'],
      profilePicURL: json['profile_pic_url'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['artist_id'] = artistID;
    data['profile_pic_url'] = profilePicURL;
    return data;
  }
}

List<Profile> parseProfiles(String? json) {
  if (json == null) {
    return [];
  }
  final List<dynamic> parsed = jsonDecode(json);
  return parsed.map((json) => Profile.fromJson(json)).toList();
}
