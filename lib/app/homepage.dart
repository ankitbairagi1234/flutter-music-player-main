// import 'dart:convert';
// import 'dart:math' as math;
// import 'package:assets_audio_player/assets_audio_player.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:palette_generator/palette_generator.dart';
// import '../models/get_musiclist_model.dart';
// import '../utils/song_util.dart';
// import 'player_page.dart';
// import 'package:http/http.dart'as http;
//
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key}) : super(key: key);
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage>
//     with SingleTickerProviderStateMixin {
//   final player = AssetsAudioPlayer();
//   bool isPlaying = true;
//   List<Audio>? songs = [];
//
//   // define an animation controller for rotate the song cover image
//   late final AnimationController _animationController =
//       AnimationController(vsync: this, duration: const Duration(seconds: 10));
//
//   List<ListElement>? getmusic;
//
//  Future<void> MusicList() async {
//     try {
//       Dio dio = Dio();
//       var request = await dio.get("https://raw.githubusercontent.com/asv0018/asv0018/master/main.json");
//       if (request.statusCode == 200) {
//         print("inside music list method ${request.data}");
//         getmusic  = Getmusic.fromJson(jsonDecode(request.data)).list;
//         if (getmusic != null) {
//           for(var item in getmusic!){
//             songs?.add(Audio('${item.audioUrl}',
//                 metas: Metas(
//                     title: '${item.name}',
//                     artist: '${item.description}',
//                     image: MetasImage.network('${item.imageUrl}'))));
//           }
//           setState(() {
//
//           });
//         }
//       }
//       else {
//         print("failed to load data");
//       }
//     } on Exception catch (e) {
//       print("$e");
//     }
//   }
//
//   @override
//   void initState() {
//     startPlayer();
//     player.isPlaying.listen((event) {
//       if (mounted) {
//         setState(() {
//           isPlaying = event;
//         });
//       }
//     });
//
//     super.initState();
//     MusicList();
//     // getMusicList();
//   }
//   // define a playlist for player
//   void startPlayer() async {
//     await player.open(Playlist(audios: songs),
//         autoStart: false, showNotification: true, loopMode: LoopMode.playlist);
//   }
//
//   @override
//   void dispose() {
//     player.dispose();
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.blue.withOpacity(.2),
//       appBar: AppBar(
//         title: const Text(
//           'Mex Player',
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: false,
//         backgroundColor: Colors.transparent,
//       ),
//       body: Stack(
//         alignment: Alignment.bottomCenter,
//         children: [
//           SafeArea(
//               child: ListView.separated(
//             separatorBuilder: (context, index) {
//               return const Divider(
//                 color: Colors.white24,
//                 height: 0,
//                 thickness: 1,
//                 indent: 85,
//                 endIndent: 20,
//               );
//             },
//             itemCount: songs!.length,
//             itemBuilder: (context, index) {
//               return Padding(
//                 padding: const EdgeInsets.only(top: 10),
//                 child: ListTile(
//                   title: Text(
//                     songs![index].metas.title!,
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                   subtitle: Text(
//                     songs![index].metas.artist!,
//                     style: const TextStyle(color: Colors.white54),
//                   ),
//                   leading: ClipRRect(
//                       borderRadius: BorderRadius.circular(10),
//                       child: Image.network(songs![index].metas.image!.path,height: 2000)),
//                   onTap: () async {
//                     await player.playlistPlayAtIndex(index);
//                     setState(() {
//                       player.getCurrentAudioImage;
//                       player.getCurrentAudioTitle;
//                     });
//                   },
//                 ),
//               );
//             },
//           )),
//           player.getCurrentAudioImage == null
//               ? const SizedBox.shrink()
//               : FutureBuilder<PaletteGenerator>(
//                   future: getPosterColors(player),
//                   builder: (context, snapshot) {
//                     return Dismissible(
//                       key: UniqueKey(),
//                       onDismissed: (direction) {
//                         player.stop();
//                       },
//                       child: Container(
//                         margin: const EdgeInsets.symmetric(
//                             horizontal: 15, vertical: 50),
//                         height: 75,
//                         decoration: BoxDecoration(
//                             gradient: LinearGradient(
//                                 begin: Alignment.topLeft,
//                                 end: const Alignment(0, 5),
//                                 colors: [
//                                   snapshot.data?.lightMutedColor?.color ??
//                                       Colors.grey,
//                                   snapshot.data?.mutedColor?.color ??
//                                       Colors.grey,
//                                 ]),
//                             borderRadius: BorderRadius.circular(20)),
//                         child: ListTile(
//                           leading: AnimatedBuilder(
//                             // rotate the song cover image
//                             animation: _animationController,
//                             builder: (_, child) {
//                               // if song is not playing
//                               if (!isPlaying) {
//                                 _animationController.stop();
//                               } else {
//                                 _animationController.forward();
//                                 _animationController.repeat();
//                               }
//                               return Transform.rotate(
//                                   angle:
//                                       _animationController.value * 2 * math.pi,
//                                   child: child);
//                             },
//                             child: CircleAvatar(
//                                 radius: 30,
//                                 backgroundColor: Colors.grey,
//                                 backgroundImage: AssetImage(
//                                     player.getCurrentAudioImage?.path ?? '')),
//                           ),
//
//                           onTap: () {
//                             showModalBottomSheet(
//                                 context: context,
//                                 isScrollControlled: true,
//                                 elevation: 0,
//                                 builder: (context) {
//                                   return FractionallySizedBox(
//                                     heightFactor: 0.96,
//                                     child: PlayerPage(
//                                       player: player,
//                                     ),
//                                   );
//                                 });
//                           },
//                           title: Text(player.getCurrentAudioTitle),
//                           subtitle: Text(player.getCurrentAudioArtist),
//                           trailing: IconButton(
//                             padding: EdgeInsets.zero,
//                             onPressed: () async {
//                               await player.playOrPause();
//                             },
//                             icon: isPlaying
//                                 ? const Icon(Icons.pause)
//                                 : const Icon(Icons.play_arrow),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//         ],
//       ),
//     );
//   }
//
//
//   getMusicList() async {
//     List<Audio> songs  = [];
//     await MusicList();
//     Future.delayed(Duration(seconds: 2));
//     if (getmusic != null) {
//       for(var item in getmusic!){
//         songs.add(Audio.network('${item.audioUrl}',
//             metas: Metas(
//                 title: '${item.name}',
//                 artist: '${item.description}',
//                 image: MetasImage.asset('${item.imageUrl}'))));
//       }
//     }
//     this.songs = songs;
//   }
//
//
// }
import 'dart:convert';
import 'dart:math' as math;
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import '../models/get_musiclist_model.dart';
import '../utils/song_util.dart';
import 'player_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  final player = AssetsAudioPlayer();
  bool isPlaying = true;
  List<Audio>? songs = [];
  bool  playorpouse = false;

  // define an animation controller for rotate the song cover image
  late final AnimationController _animationController =
  AnimationController(vsync: this, duration: const Duration(seconds: 10));

  List<ListElement>? getmusic;

  Future<void> musicList() async {
    try {
      Dio dio = Dio();
      var request = await dio.get("https://raw.githubusercontent.com/asv0018/asv0018/master/main.json");
      if (request.statusCode == 200) {
        print("inside music list method ${request.data}");
        getmusic  = Getmusic.fromJson(jsonDecode(request.data)).list;
        if (getmusic != null) {
          setState(() {
            for(var item in getmusic!){

              songs?.add(Audio.file('${item.audioUrl}',
                  metas: Metas(
                  title: '${item.name}',
                  artist: '${item.description}',
                  image: MetasImage.network('${item.imageUrl}')
              )));
            }
          });
        }
      }
      else {
        print("failed to load data");
      }
    }catch (e, s) {
      print("musicList Exception Exception : $e, $s");
    }
  }
Audio? audio;
  @override
  void initState() {
    startPlayer();
    player.isPlaying.listen((event) {
      if (mounted) {
        setState(() {
          isPlaying = event;
        });
      }
    });

    super.initState();
    musicList();
    // getMusicList();
  }

  // define a playlist for player
  void startPlayer() async {
    await player.open(Playlist(audios: songs),
        autoStart: false, showNotification: true, loopMode: LoopMode.playlist);
  }

  @override
  void dispose() {
    player.dispose();
    _animationController.dispose();
    super.dispose();
  }
  final assetsAudioPlayer =  AssetsAudioPlayer();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      appBar: AppBar(
        title: const Text(
          'Hello Ayushi',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        backgroundColor: primary,
      ),
      body: Column(
        // alignment: Alignment.bottomCenter,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: primary,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide:BorderSide()
                ),
              ),
            ),
          ),
          Expanded(
            child:  ListView.builder(
              itemCount: songs!.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
                  child: Card(
                    color: cardclr,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child:  Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: ListTile(
                        title: Text(
                          songs![index].metas.title!,
                          style: const TextStyle(color: Colors.black87),
                        ),
                        subtitle: Text(
                          songs![index].metas.artist!,
                          style: const TextStyle(color: Colors.black),
                        ),
                        leading: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(songs![index].metas.image!.path)),

                        onTap: () async {
                          try {
                            if(kIsWeb) {
                              await assetsAudioPlayer.open(
                               audio =  Audio.file(songs![index].path),
                              );
                            } else {
                              await assetsAudioPlayer.open(songs![index]);
                              await assetsAudioPlayer.play();
                            }
                            setState(() {
                              playorpouse = !playorpouse;
                              playorpouse?assetsAudioPlayer.play():assetsAudioPlayer.stop();
                              player.getCurrentAudioImage;
                              player.getCurrentAudioTitle;
                            });
                          } catch (e,s) {
                            print("Exception Exception build : $e, $s");
                          }
                          // await player.playlistPlayAtIndex(songs[index].metas.);
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // ListView.separated(
          //   separatorBuilder: (context, index) {
          //     return const Divider(
          //       color: Colors.white24,
          //       height: 0,
          //       thickness: 1,
          //       indent: 85,
          //       endIndent: 20,
          //     );
          //   },
          //   itemCount: songs!.length,
          //   itemBuilder: (context, index) {
          //     return Card(
          //
          //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          //       child:  Padding(
          //         padding: const EdgeInsets.only(top: 0),
          //         child: ListTile(
          //           title: Text(
          //             songs![index].metas.title!,
          //             style: const TextStyle(color: Colors.black87),
          //           ),
          //           subtitle: Text(
          //             songs![index].metas.artist!,
          //             style: const TextStyle(color: Colors.black),
          //           ),
          //           leading: ClipRRect(
          //               borderRadius: BorderRadius.circular(10),
          //               child: Image.network(songs![index].metas.image!.path)),
          //           // onTap: () async {
          //           //   print("build onTap got invoked");
          //           //   try {
          //           //     final assetsAudioPlayer = AssetsAudioPlayer();
          //           //     print("ListTile onTap songs![index].metas.album! : ${songs?[index].path}");
          //           //     if(kIsWeb) {
          //           //       print("inside if means platform is web");
          //           //       await assetsAudioPlayer.open(
          //           //         Audio.file(songs![index].path),
          //           //       );
          //           //     } else {
          //           //       print("inside else means platform is IOS/ Android");
          //           //       await assetsAudioPlayer.open(songs![index]);
          //           //       await assetsAudioPlayer.play();
          //           //     }
          //           //     assetsAudioPlayer.play();
          //           //     setState(() {
          //           //       player.getCurrentAudioImage;
          //           //       player.getCurrentAudioTitle;
          //           //     });
          //           //   } catch (e,s) {
          //           //     print("Exception Exception build : $e, $s");
          //           //   }
          //           //   // await player.playlistPlayAtIndex(songs[index].metas.);
          //           // },
          //         ),
          //       ),
          //     );
          //
          //   },
          // ),
        ],
      ),
    );
  }
  static const Color primary = Color(0xffFFEDCB);
  static const Color cardclr = Color(0xffF0DBB2);
// getMusicList() async {
//   List<Audio> songs  = [];
//   await MusicList();
//   Future.delayed(Duration(seconds: 2));
//   if (getmusic != null) {
//     for(var item in getmusic!){
//       songs.add(Audio.network('${item.audioUrl}',
//           metas: Metas(
//               title: '${item.name}',
//               artist: '${item.description}',
//               image: MetasImage.asset('${item.imageUrl}'))));
//     }
//   }
//   this.songs = songs;
// }
}