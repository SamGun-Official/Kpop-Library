import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kpop_library/model/artist.dart';
import 'package:kpop_library/model/discography.dart';
import 'package:kpop_library/model/profile.dart';

class ArtistScreen extends StatelessWidget {
  static const routeName = '/artist';
  final List<dynamic> args;

  const ArtistScreen({Key? key, required this.args}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ArtistData(
        artistID: args[0],
      ),
    );
  }
}

class ArtistData extends StatefulWidget {
  final int artistID;

  const ArtistData({Key? key, required this.artistID}) : super(key: key);

  @override
  State<ArtistData> createState() => _ArtistDataState();
}

class _ArtistDataState extends State<ArtistData> {
  late Future<List<Artist>> artistsData;
  late Future<List<Profile>> profilesData;
  late Future<List<Discography>> discographiesData;

  List<Map<String, dynamic>> imagesURL = List.empty(growable: true);
  double containerPadding = 0.0;
  double scrollWidth = 0.8;
  String stageName = "Artists";
  int activePage = 0;

  @override
  void initState() {
    super.initState();
    artistsData = fetchArtists(widget.artistID);
    artistsData.then((artists) {
      setState(() {
        stageName = artists[0].stageName;
      });
    });
    profilesData = fetchProfiles(widget.artistID);
    discographiesData = fetchDiscographies(widget.artistID);
  }

  Future<List<Artist>> fetchArtists(int artistID) async {
    final response = await http.get(Uri.parse('https://samgun-official.my.id/kpop/api/artists/fetch/$artistID'));
    if (response.statusCode == 200) {
      return parseArtists(response.body);
    } else {
      throw Exception("No artist was found!");
    }
  }

  Future<List<Profile>> fetchProfiles(int artistID) async {
    final response = await http.get(Uri.parse('https://samgun-official.my.id/kpop/api/profiles/$artistID'));
    if (response.statusCode == 200) {
      return parseProfiles(response.body);
    } else {
      throw Exception("No profile was found!");
    }
  }

  Future<List<Discography>> fetchDiscographies(int artistID) async {
    final response = await http.get(Uri.parse('https://samgun-official.my.id/kpop/api/discographies/$artistID'));
    if (response.statusCode == 200) {
      return parseDiscographies(response.body);
    } else {
      throw Exception("No profile was found!");
    }
  }

  Widget appContainer(bool isMobile) {
    return Container(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: FutureBuilder<List<dynamic>>(
          future: Future.wait([
            fetchArtists(widget.artistID),
            fetchProfiles(widget.artistID),
            fetchDiscographies(widget.artistID),
          ]),
          builder: (context1, snapshot) {
            const double boxSize = 48.0;
            if (snapshot.hasData) {
              final List<Artist> artists = snapshot.data![0];
              final List<Profile> profiles = snapshot.data![1];
              // final List<Discography> discographies = snapshot.data![2];
              if (isMobile) {
                return ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 250.0,
                            child: PageView.builder(
                              itemCount: profiles.length,
                              pageSnapping: true,
                              controller: PageController(viewportFraction: 0.8),
                              onPageChanged: (page) {
                                setState(() {
                                  activePage = page;
                                });
                              },
                              itemBuilder: (context2, position) {
                                return Container(
                                  color: Colors.black,
                                  margin: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Expanded(
                                        child: Image.network(profiles[position].profilePicURL),
                                      ),
                                    ],
                                  ),
                                );
                                // ),
                              },
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                                      child: Text("About $stageName", textAlign: TextAlign.start, style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                                Text(artists[0].profileDesc),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                );
              } else {
                return ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 2,
                            child: PageView.builder(
                              itemCount: profiles.length,
                              pageSnapping: true,
                              controller: PageController(viewportFraction: scrollWidth),
                              onPageChanged: (page) {
                                setState(() {
                                  activePage = page;
                                });
                              },
                              itemBuilder: (context2, position) {
                                return Container(
                                  color: Colors.black,
                                  margin: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Expanded(
                                        child: Image.network(profiles[position].profilePicURL),
                                      ),
                                    ],
                                  ),
                                );
                                // ),
                              },
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                                      child: Text("About $stageName", textAlign: TextAlign.start, style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                                Text(
                                  artists[0].profileDesc,
                                  style: const TextStyle(fontSize: 16.0),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                );
              }
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(stageName, style: const TextStyle(fontWeight: FontWeight.bold)),
        titleSpacing: 4.0,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            if (constraints.maxWidth <= 600) {
              return appContainer(true);
            } else {
              if (constraints.maxWidth <= 1024) {
                containerPadding = 0.0;
                scrollWidth = 0.7;
              } else if (constraints.maxWidth <= 1536) {
                containerPadding = 64.0;
                scrollWidth = 0.5;
              } else {
                containerPadding = 128.0;
                scrollWidth = 0.3;
              }
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: containerPadding),
                child: appContainer(false),
              );
            }
          },
        ),
      ),
    );
  }
}
