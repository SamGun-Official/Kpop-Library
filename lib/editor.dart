import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:permission_handler/permission_handler.dart';

class EditorScreen extends StatelessWidget {
  static const routeName = '/editor';

  const EditorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              var status = await Permission.storage.status;
              if (status.isDenied) {
                // We didn't ask for permission yet or the permission has been denied before but not permanently.
              }

              // You can can also directly ask the permission about its status.
              if (await Permission.storage.isRestricted) {
                // The OS restricts access, for example because of parental controls.
              }

              var a = await Permission.storage.request();
              debugPrint("PASS? ${a.isGranted} $a");
              if (a.isGranted) {
                debugPrint("SOMETHING HERE");
                // Either the permission was already granted before or the user just granted it.
                FilePicker.platform.pickFiles()
                  ..then(
                    (result) {
                      if (result == null) return;
                      if (result.count == 0) return;
                      if (kIsWeb) {
                        /// Use [MetadataRetriever.fromBytes] on Web.
                        MetadataRetriever.fromBytes(
                          result.files.first.bytes!,
                        )
                          ..then(
                            (metadata) {
                              // showData(metadata);
                            },
                          )
                          ..catchError((_) {
                            // setState(() {
                            //   _child = const Text('Couldn\'t extract metadata');
                            // });
                          });
                      } else {
                        /// Use [MetadataRetriever.fromFile] on Windows, Linux, macOS, Android or iOS.
                        MetadataRetriever.fromFile(
                          File(result.files.first.path!),
                        )
                          ..then(
                            (metadata) {
                              debugPrint(metadata.toString());
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text("TEST ${metadata.trackName}"),
                              ));
                              // showData(metadata);
                            },
                          )
                          ..catchError((_) {
                            // setState(() {
                            //   _child = const Text('Couldn\'t extract metadata');
                            // });
                          });
                      }
                    },
                  )
                  ..catchError((_) {
                    // setState(() {
                    //   _child = const Text('Couldn\'t to select file');
                    // });
                  });

                // debugPrint("=================");
                // MetadataRetriever.fromFile(File("audio/01 Feel Special.flac"))
                //     .then(
                //   (metadata) {
                //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                //       content: Text("Sending Message ${metadata.trackName}"),
                //     ));
                //     // debugPrint(metadata.trackName.toString());
                //   },
                // );
              }
            },
            child: const Text("Load and Decode FLAC File"),
          ),
        ],
      ),
    );
  }
}
