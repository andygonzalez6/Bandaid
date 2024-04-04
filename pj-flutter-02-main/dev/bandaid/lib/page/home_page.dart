import 'package:bandaid/components/app_bar.dart';
import 'package:bandaid/components/user_card.dart';
import 'package:bandaid/page/settings_page.dart';
import 'package:bandaid/page/messaging_page.dart';
import 'package:bandaid/page/search_page.dart';
import 'package:flutter/material.dart';
import 'package:bandaid/model/user.dart';
import 'package:bandaid/page/profile_page.dart';
import 'package:bandaid/utils/user_functions.dart';
import 'package:http/http.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Homepage> {
  User? user;
  List<User>? userlist;
  List<Widget>? pages;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchInfo();
  }

  void _fetchInfo() async {
    User fetchedUser = await getCurrentUserDetails(context);
    List<User> fetchedUsers = await getAllUserDetails();

    await getAllUsersGenres(fetchedUsers);
    await getAllUsersInstruments(fetchedUsers);
    
    fetchedUsers.removeWhere((element) => element.id == fetchedUser.id);
    List<Widget> fetchedpages = [
      Home(userlist: fetchedUsers),
      SearchPage(userlist: fetchedUsers),
      MessagingPage(user: fetchedUser, userlist: fetchedUsers),
      ProfilePage(user_id: fetchedUser.id),
      SettingsPage(),
    ];

    setState(() {
      user = fetchedUser;
      userlist = fetchedUsers;
      pages = fetchedpages;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: _buildAppBarTitle(currentIndex),
      ),
      body: Center(
        child: ((userlist != null) && (user != null) && (pages != null))
            ? (pages?[currentIndex])
            : const CircularProgressIndicator(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }

  String _buildAppBarTitle(int currentIndex) {
    switch (currentIndex) {
      case 0:
        return 'Home';
      case 1:
        return 'Search';
      case 2:
        return 'Messages';
      case 3:
        return 'My Profile';
      default:
        return 'Settings';
    }
  }
}

class Home extends StatefulWidget {
  final userlist;
  const Home({Key? key, required this.userlist}) : super(key: key);

  @override
  State<Home> createState() => _HomePageState(userlist: userlist);
}

class _HomePageState extends State<Home> {
  final userlist;
  final List<String> categories = ["Name", "Title", "Location"];
  String selectedCategory = "Name"; // Default sorting category
  _HomePageState({required this.userlist});

  @override
  Widget build(BuildContext context) => userlist != null
      ? Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: categories
                  .map((category) => FilterChip(
                        label: Text(category),
                        showCheckmark: false,
                        pressElevation: 2,
                        labelStyle: TextStyle(
                          color: selectedCategory == category
                              ? Colors.white
                              : Colors.black,
                        ),
                        selectedColor: Colors.pink,
                        selected: selectedCategory == category,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              selectedCategory = category;
                            }
                          });
                        },
                      ))
                  .toList(),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                itemCount: userlist?.length,
                itemBuilder: (BuildContext context, int index) {
                  // Sort the userlist based on the selected category
                  List<User>? sortedUserList =
                      sortUsers(userlist, selectedCategory);

                  return user_card(user: sortedUserList![index]);
                },
              ),
            ),
          ],
        )
      : Center(child: const CircularProgressIndicator());

  // Function to sort users based on the selected category
  List<User>? sortUsers(List<User>? userList, String category) {
    if (userList == null) return null;

    switch (category) {
      case "Name":
        userList.sort((a, b) => a.name.compareTo(b.name));
        break;
      case "Title":
        userList.sort((a, b) => a.title.compareTo(b.title));
        break;
      case "Location":
        userList.sort((a, b) => a.address.compareTo(b.address));
        break;
    }

    return userList;
  }
}
