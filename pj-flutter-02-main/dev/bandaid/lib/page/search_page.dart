import 'package:bandaid/components/user_card.dart';
import 'package:bandaid/model/user.dart';
import 'package:bandaid/utils/user_functions.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SearchPage extends StatefulWidget {
  final List<User> userlist;
  const SearchPage({Key? key, required this.userlist}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState(userlist: userlist);
}

class _SearchPageState extends State<SearchPage> {
  List<User> userlist;
  Map<int, List<dynamic>> userGenres = {};
  Map<int, List<dynamic>> userInstruments = {};
  final String hintText = "Search by name, title, preferences, or location";
  TextEditingController search_query = TextEditingController();
  _SearchPageState({required this.userlist});

  List<User> displayed_users = [];
  void initState() {
    super.initState();
    _fetchInfo();
  }

  void _fetchInfo() async {
    await getAllUsersGenres(userlist);
    await getAllUsersInstruments(userlist);
  }

  void updateList(String value) {
    displayed_users = userlist;
    setState(() {
      displayed_users = userlist
          .where((User el) =>
              el.getName().toLowerCase().contains(value.toLowerCase()) ||
              el.getInstruments().any((instrument) =>
                  instrument.toLowerCase().contains(value.toLowerCase())) ||
              el.getGenres().any((genre) =>
                  genre.toLowerCase().contains(value.toLowerCase())) ||
              el.title.toLowerCase().contains(value.toLowerCase()) ||
              el.address.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                offset: const Offset(12, 26),
                blurRadius: 50,
                spreadRadius: 0,
                color: Colors.grey.withOpacity(.1)),
          ]),
          child: TextField(
            controller: search_query,
            onChanged: (value) {
              updateList(value);
            },
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.search,
                color: Color(0xff4338CA),
              ),
              filled: true,
              fillColor: Colors.white,
              hintText: hintText,
              hintStyle: const TextStyle(color: Colors.grey),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 2.0),
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
              ),
            ),
          ),
        ),
        Expanded(
            child: ListView.builder(
                padding:
                    EdgeInsets.symmetric(horizontal: 15.0.sp, vertical: 10.sp),
                itemCount: displayed_users.length,
                itemBuilder: (BuildContext context, int index) {
                  return user_card(
                      user: displayed_users[index]);
                }))
      ],
    );
  }
}
