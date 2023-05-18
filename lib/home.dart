import 'package:flutter/material.dart';
// import 'package:kpop_library/view/list_artist.dart';
import 'package:http/http.dart' as http;
import 'package:kpop_library/model/artist.dart';
import 'package:kpop_library/model/profile.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SafeArea(child: ArtistData());
  }
}

class ArtistData extends StatefulWidget {
  const ArtistData({Key? key}) : super(key: key);

  @override
  State<ArtistData> createState() => _ArtistDataState();
}

class _ArtistDataState extends State<ArtistData> {
  late Future<List<Artist>> artistsData;
  late Future<List<Profile>> profilesData;

  List<Map<String, dynamic>> imagesURL = List.empty(growable: true);
  bool loadImage = false;
  int gridViewCount = 5;
  double containerPadding = 0;

  @override
  void initState() {
    super.initState();
    artistsData = fetchArtists();
    artistsData.then((artists) {
      for (Artist artist in artists) {
        profilesData = fetchProfiles(artist.id);
        profilesData.then((profiles) {
          for (Profile profile in profiles) {
            setState(() {
              imagesURL.add({
                "artist_id": profile.artistID,
                "profile_pic_url": profile.profilePicURL,
              });
            });
          }
        }).whenComplete(() {
          if (artists.length == imagesURL.length) {
            setState(() {
              loadImage = true;
              imagesURL.sort((a, b) => a["artist_id"].compareTo(b["artist_id"]));
            });
          }
        });
      }
    });
  }

  Future<List<Artist>> fetchArtists() async {
    final response = await http.get(Uri.parse('https://samgun-official.my.id/kpop/api/artists'));
    if (response.statusCode == 200) {
      return parseArtists(response.body);
    } else {
      throw Exception("No artist was found!");
    }
  }

  Future<List<Profile>> fetchProfiles(int artistID) async {
    final response = await http.get(Uri.parse('https://samgun-official.my.id/kpop/api/profiles/fetch/$artistID'));
    if (response.statusCode == 200) {
      return parseProfiles(response.body);
    } else {
      throw Exception("No artist was found!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Artists", style: TextStyle(fontWeight: FontWeight.bold)),
        leadingWidth: 16.0,
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth <= 600) {
            return Container(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: FutureBuilder<List<Artist>>(
                  future: fetchArtists(),
                  builder: (context, snapshot) {
                    const double boxSize = 48.0;
                    if (snapshot.hasData) {
                      final List<Artist> artists = snapshot.data!;
                      artists.sort((a, b) => a.id.compareTo(b.id));
                      return ListView.builder(
                        itemCount: artists.length,
                        itemBuilder: (context, index) {
                          final Artist artist = artists[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                ProfileAvatar(
                                  loadImage: loadImage,
                                  imageSource: loadImage ? imagesURL[index]["profile_pic_url"] : "",
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 12.0),
                                  child: InkWell(
                                    child: Text(artist.stageName, style: const TextStyle(fontSize: 16.0)),
                                    onTap: () {
                                      setState(() {});
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                    return const SizedBox(
                      width: boxSize,
                      height: boxSize,
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
            );
          } else {
            if (constraints.maxWidth <= 1024) {
              gridViewCount = 3;
              containerPadding = 0.0;
            } else if (constraints.maxWidth <= 1536) {
              gridViewCount = 4;
              containerPadding = 64.0;
            } else {
              gridViewCount = 5;
              containerPadding = 128.0;
            }
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: containerPadding),
              child: Container(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: FutureBuilder<List<Artist>>(
                    future: fetchArtists(),
                    builder: (context, snapshot) {
                      const double boxSize = 48.0;
                      if (snapshot.hasData) {
                        final List<Artist> artists = snapshot.data!;
                        artists.sort((a, b) => a.id.compareTo(b.id));
                        return GridView.builder(
                          itemCount: artists.length,
                          itemBuilder: (context, index) {
                            final Artist artist = artists[index];
                            return InkWell(
                              onTap: () {},
                              hoverColor: Colors.transparent,
                              child: Card(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                      child: loadImage ? Image.network(imagesURL[index]["profile_pic_url"], fit: BoxFit.cover) : const Text("data"),
                                    ),
                                    const SizedBox(height: 8),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        artist.stageName,
                                        style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                                      child: Text(artist.koreanName!),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: gridViewCount,
                            mainAxisSpacing: 8.0,
                            crossAxisSpacing: 8.0,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      return const SizedBox(
                        width: boxSize,
                        height: boxSize,
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class ProfileAvatar extends StatelessWidget {
  final String? imageSource;
  final bool loadImage;

  const ProfileAvatar({
    Key? key,
    required this.loadImage,
    required this.imageSource,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double circleRadius = 32.0;
    if (loadImage) {
      return CircleAvatar(
        backgroundColor: Colors.white,
        radius: circleRadius + 1.0,
        child: CircleAvatar(
          backgroundImage: NetworkImage(imageSource!),
          radius: circleRadius,
        ),
      );
    } else {
      return CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor,
        radius: circleRadius,
      );
    }
  }
}
