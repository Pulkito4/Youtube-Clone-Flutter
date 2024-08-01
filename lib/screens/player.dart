import 'package:timeago/timeago.dart' as timeago;

import 'package:flutter/material.dart';
import 'package:numeral/numeral.dart';
import 'package:youtube_clone/services/yt.services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Player extends StatefulWidget {
  final String id;
  const Player({super.key, required this.id});

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  YtServices obj = YtServices();

  final ValueNotifier<Color> likeButtonColor =
      ValueNotifier<Color>(Colors.white);

  final ValueNotifier<Color> dislikeButtonColor =
      ValueNotifier<Color>(Colors.white);

  final ValueNotifier<String> _subButtonText =
      ValueNotifier<String>("Subscribe");

  late YoutubePlayerController _controller;
  final bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.id,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: YoutubePlayerBuilder(
          player: YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.red,
            progressColors: const ProgressBarColors(
              playedColor: Colors.red,
              handleColor: Colors.red,
            ),
            onReady: () {
              _controller.addListener(listener);
            },
          ),
          builder: (context, player) {
            List data;
            return Column(
              children: [
                // main video player
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: player),
                FutureBuilder(
                  future: Future.wait([
                    obj.getVideoDetails(widget.id),
                    obj.getChannelDetails(widget.id),
                    obj.getVideoComments(widget.id)
                  ]),
                  builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child:
                              CircularProgressIndicator()); // Show a loading indicator while waiting
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                      // return const Center(child: Text("Something went wrong"));
                    }
                    if (!snapshot.hasData || snapshot.data == null) {
                      return const Text("No data available");
                    }

                    if (snapshot.hasData) {
                      var videoDeets = snapshot.data![0]["items"][0];
                      var channelDeets = snapshot.data![1]["items"][0];
                      var comments = snapshot.data![2]["items"];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),

                        // Video Details
                        child: Column(
                          children: [
                            // Video Title
                            Text(
                              videoDeets["snippet"]["title"],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              // Video views and published date
                              children: [
                                Text(
                                    "${(int.parse(videoDeets["statistics"]["viewCount"])).numeral(digits: 1)} views"),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text((videoDeets["snippet"]["publishedAt"] !=
                                        null)
                                    ? timeago
                                        .format(DateTime.parse(
                                            videoDeets['snippet']
                                                ['publishedAt']))
                                        .toString()
                                    : "No date available"),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),

                            // Channel Details : logo, name, subscribers   +  Subscribe button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          channelDeets["snippet"]["thumbnails"]
                                              ["default"]["url"]),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      child: Text(
                                        videoDeets["snippet"]["channelTitle"],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16),
                                        overflow: TextOverflow.fade,
                                        maxLines: 1,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text((int.parse(channelDeets['statistics']
                                            ['subscriberCount']))
                                        .numeral(digits: 1))
                                  ],
                                ),

                                // Subscribe button
                                ValueListenableBuilder<String>(
                                    valueListenable: _subButtonText,
                                    builder: (context, value, child) {
                                      return ElevatedButton(
                                        onPressed: () {
                                          _subButtonText.value =
                                              (value == "Subscribe")
                                                  ? "Subscribed"
                                                  : "Subscribe";
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            minimumSize: const Size(0, 30)),
                                        child: Text(
                                          value,
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                      );
                                    })
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),

                            // Like, Dislike, Share, Download, Clip buttons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Like and Dislike Buttons
                                Container(
                                  decoration: BoxDecoration(
                                      color:
                                          const Color.fromARGB(255, 36, 34, 34),
                                      borderRadius: BorderRadius.circular(50)),
                                  width: 120,
                                  height: 30,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          if (likeButtonColor.value ==
                                              Colors.white) {
                                            likeButtonColor.value = Colors.blue;
                                            dislikeButtonColor.value =
                                                Colors.white;
                                          } else {
                                            likeButtonColor.value =
                                                Colors.white;
                                          }
                                        },

                                        // Like Button
                                        child: Row(
                                          children: [
                                            ValueListenableBuilder<Color>(
                                              valueListenable: likeButtonColor,
                                              builder: (context, color, child) {
                                                return Icon(
                                                  Icons.thumb_up,
                                                  size: 15,
                                                  color: color,
                                                );
                                              },
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text((int.parse(
                                                    videoDeets["statistics"]
                                                        ["likeCount"]))
                                                .numeral(digits: 1)),
                                          ],
                                        ),
                                      ),
                                      const Text("|"),
                                      GestureDetector(
                                        onTap: () {
                                          if (dislikeButtonColor.value ==
                                              Colors.white) {
                                            dislikeButtonColor.value =
                                                Colors.blue;
                                            likeButtonColor.value =
                                                Colors.white;
                                          } else {
                                            dislikeButtonColor.value =
                                                Colors.white;
                                          }
                                        },

                                        // Dislike Button

                                        child: ValueListenableBuilder<Color>(
                                          valueListenable: dislikeButtonColor,
                                          builder: (context, color, child) {
                                            return Icon(
                                              Icons.thumb_down,
                                              size: 15,
                                              color: color,
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Share Button
                                Container(
                                  height: 30,
                                  width: 90,
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(255, 36, 34, 34),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.share,
                                        size: 15,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text("Share")
                                    ],
                                  ),
                                ),

                                // Download Button
                                Container(
                                  height: 30,
                                  width: 110,
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(255, 36, 34, 34),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.download,
                                        size: 15,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text("Download")
                                    ],
                                  ),
                                ),

                                // Clip Button
                                Container(
                                  height: 30,
                                  width: 75,
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(255, 36, 34, 34),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.cut,
                                        size: 15,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text("Clip")
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),

                            //Comments box
                            GestureDetector(
                              //Go to comments page
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  isDismissible: false,
                                  isScrollControlled: true,
                                  builder: (context) {
                                    return Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.65,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  "Comments",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 22,
                                                  ),
                                                ),
                                                IconButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    icon: const Icon(
                                                      Icons.close,
                                                      size: 35,
                                                    ))
                                              ],
                                            ),
                                          ),
                                          const Divider(
                                            color: Colors.grey,
                                            thickness: 1,
                                          ),
                                          Expanded(
                                            child: ListView.builder(
                                              /* itemCount: int.parse(
                                                  videoDeets["statistics"]
                                                      ["commentCount"]), */

                                              // making it such because only 20 comments are returned per page by the api and to load more comments knowledge of pagination would be required
                                              itemCount: comments.length,
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Column(children: [
                                                    Row(
                                                      children: [
                                                        // Author Profile Image
                                                        CircleAvatar(
                                                          backgroundImage:
                                                              NetworkImage(
                                                            comments[index]["snippet"]
                                                                        [
                                                                        "topLevelComment"]
                                                                    ["snippet"][
                                                                "authorProfileImageUrl"],
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),

                                                        // Author Name
                                                        Text(
                                                          comments[index]["snippet"]
                                                                      [
                                                                      "topLevelComment"]
                                                                  ["snippet"][
                                                              "authorDisplayName"],
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),

                                                        // Published Date
                                                        Text(
                                                          timeago
                                                              .format(DateTime.parse(comments[index]
                                                                              [
                                                                              "snippet"]
                                                                          [
                                                                          "topLevelComment"]
                                                                      [
                                                                      "snippet"]
                                                                  [
                                                                  "publishedAt"]))
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      ],
                                                    ),

                                                    // Comment
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.75,
                                                      child: Text(
                                                        comments[index]["snippet"]
                                                                    [
                                                                    "topLevelComment"]
                                                                ["snippet"]
                                                            ["textOriginal"],
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 2,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),

                                                    // Like and Reply Buttons
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.75,
                                                      child: Row(
                                                        children: [
                                                          // Like Button
                                                          Row(
                                                            children: [
                                                              const Icon(
                                                                Icons.thumb_up,
                                                                size: 15,
                                                              ),
                                                              const SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                Numeral(comments[index]["snippet"]["topLevelComment"]["snippet"]
                                                                            [
                                                                            "likeCount"]
                                                                        as num)
                                                                    .numeral(
                                                                        digits:
                                                                            1),
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),

                                                              // Dislike Button
                                                              const Icon(
                                                                Icons
                                                                    .thumb_down,
                                                                size: 15,
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            width: 20,
                                                          ),
                                                          // Reply Button
                                                          GestureDetector(
                                                            onTap: () {},
                                                            child: const Icon(
                                                              Icons.comment,
                                                              size: 15,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ]),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 36, 34, 34),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          const Text(
                                            "Comments",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(int.parse(
                                                  videoDeets["statistics"]
                                                      ["commentCount"])
                                              .numeral(digits: 1)),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                comments[0]["snippet"]
                                                            ["topLevelComment"]
                                                        ["snippet"]
                                                    ["authorProfileImageUrl"]),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.75,
                                            child: Text(
                                              comments[0]["snippet"]
                                                      ["topLevelComment"]
                                                  ["snippet"]["textOriginal"],
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    }
                    return const Center(child: Text("No data available"));
                  },
                ),

                // Related Videos Scrollable List
                FutureBuilder(
                    future: obj.getPopularVideos("US"),
                    builder: (context, AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.hasData) {
                        data = snapshot.data["items"];
                        return Expanded(
                          child: ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              var element = data[index];
                              return Card(
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Player(id: element["id"])));
                                      },
                                      child: Image.network(element["snippet"]
                                          ["thumbnails"]["high"]["url"]),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                element["snippet"]["thumbnails"]
                                                    ["default"]["url"]),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Text(
                                                  element["snippet"]["title"],
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      fontSize: 18),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      element["snippet"]
                                                          ["channelTitle"],
                                                    ),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    Text(
                                                        "${(int.parse(element["statistics"]["viewCount"])).numeral(digits: 1)} views"),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    Text(timeago
                                                        .format(DateTime.parse(
                                                            element["snippet"][
                                                                "publishedAt"]))
                                                        .toString())
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      }
                      if (snapshot.hasError) {
                        return const Center(
                            child: Text("Something went wrong"));
                      }
                      return const Center(child: CircularProgressIndicator());
                    })
              ],
            );
          },
        ),
      ),
    );
  }
}
