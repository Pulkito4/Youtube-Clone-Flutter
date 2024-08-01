import 'package:flutter/material.dart';
import 'package:youtube_clone/screens/player.dart';
import 'package:youtube_clone/services/yt.services.dart';
import 'package:timeago/timeago.dart' as timeago;

class SearchScreen extends StatefulWidget {
  final String query;
  final Function(String) addToPreviousSearches;
  const SearchScreen({
    super.key,
    required this.query,
    required this.addToPreviousSearches,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  YtServices obj = YtServices();

  @override
  Widget build(BuildContext context) {
    List data;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: TextField(
          controller: TextEditingController(text: widget.query),
          decoration: const InputDecoration(
            hintText: 'Search...',
            border: InputBorder.none,
          ),
          onSubmitted: (query) {
            widget.addToPreviousSearches(query);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SearchScreen(
                        query: query,
                        addToPreviousSearches: widget.addToPreviousSearches)));
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.mic),
            onPressed: () {
              // Handle mic button press
            },
          ),
          IconButton(
            icon: const Icon(Icons.cast),
            onPressed: () {
              // Handle cast button press
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Handle options button press
            },
          ),
        ],
      ),
      body: Container(
        child: FutureBuilder(
            future: obj.searchVideos(widget.query),
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
                                      Player(id: element["id"]["videoId"])));
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
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                      Row(
                                        children: [
                                          Text(element["snippet"]
                                              ["channelTitle"]),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          /* 
                                          Text(
                                              "${(int.parse(element["statistics"]["viewCount"])).numeral(digits: 1)} views"), */
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Text(timeago
                                              .format(DateTime.parse(
                                                  element["snippet"]
                                                      ["publishedAt"]))
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
                );
              }
              if (snapshot.hasError) {
                return const Center(child: Text("Something went wrong"));
              }
              return const Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }
}
