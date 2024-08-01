import 'package:flutter/material.dart';
import 'package:youtube_clone/screens/search_screen.dart';

import 'home.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List screens = const [
    Home(),
    Center(child: Text("Shorts")),
    Center(child: Text("Create")),
    Center(child: Text("Subscriptions")),
    Center(child: Text("UserAccount"))
  ];
  int currentIndex = 0;
  List<String> previousSearches = [];
    late FocusNode _focusNode;

 @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
  void addToPreviousSearches(String query) {
    setState(() {
      previousSearches.add(query);
    });
  }

  void _showSearchModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  focusNode: _focusNode,
                  decoration: const InputDecoration(
                    hintText: 'Search...',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (query) {
                    addToPreviousSearches(query);
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchScreen(
                          query: query,
                          addToPreviousSearches: addToPreviousSearches,
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (previousSearches.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Previous Searches',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: previousSearches.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(previousSearches[index]),
                            onTap: () {
                              setState(() {
                                // Move the clicked item to the top of the list
                                String selectedSearch = previousSearches.removeAt(index);
                                previousSearches.insert(0, selectedSearch);
                              });
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SearchScreen(
                                      query: previousSearches[0],
                                      addToPreviousSearches:
                                          addToPreviousSearches),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    ).whenComplete((){
      _focusNode.unfocus();
    });

    // Request focus after the modal bottom sheet is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          // backgroundColor: Colors.transparent,
          leading: Row(
            children: [
              const SizedBox(
                width: 5,
              ),
              Image.network(
                "https://cdn-icons-png.flaticon.com/256/1384/1384060.png",
                height: 40,
                width: 50,
              ),
              const Text(
                "YouTube",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              )
            ],
          ),
          leadingWidth: 150,
          actions: [
            IconButton(
              icon: const Icon(Icons.cast),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                _showSearchModal(context);
              },
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedIconTheme: const IconThemeData(color: Colors.white),
          selectedItemColor: Colors.red,
          backgroundColor: Colors.transparent,
          currentIndex: currentIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Colors.white,
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.shop_two_rounded,
                ),
                label: "Shorts"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                label: "Create"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.subscriptions,
                  color: Colors.white,
                ),
                label: "Subscriptions"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.account_circle,
                  color: Colors.white,
                ),
                label: "You")
          ],
          onTap: (value) {
            currentIndex = value;
            setState(() {});
          },
        ),
        body: screens[currentIndex],
      ),
    );
  }
}
