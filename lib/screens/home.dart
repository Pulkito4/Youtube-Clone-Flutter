import 'package:flutter/material.dart';
import 'package:numeral/numeral.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:youtube_clone/screens/player.dart';
import 'package:youtube_clone/services/yt.services.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  YtServices obj = new YtServices();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List data;
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: FutureBuilder(
              future: obj.getPopularVideos("IN"),
              builder: (context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  data = snapshot.data["items"];
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      var element = data[index];
                      return Card(
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
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
                                    backgroundImage: NetworkImage(element["snippet"]
                                        ["thumbnails"]["default"]["url"]),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text(
                                          element["snippet"]["title"],
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                        Row(
                                          children: [
                                            Expanded(child: Text(element["snippet"]["channelTitle"])),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Expanded(
                                              child: Text(
                                                  "${(int.parse(element["statistics"]["viewCount"])).numeral(digits: 1)} views"),
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Expanded(
                                              child: Text(timeago
                                                  .format(DateTime.parse(
                                                      element["snippet"]["publishedAt"]))
                                                  .toString()),
                                            )
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
                  );
                }
                if (snapshot.hasError) {
                  return const Center(child: Text("Something went wrong"));
                }
                return const Center(child:  CircularProgressIndicator());
              }),
        ),
      ),
    );
  }
}
