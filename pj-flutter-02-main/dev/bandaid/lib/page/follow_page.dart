import 'package:bandaid/components/app_bar.dart';
import 'package:bandaid/model/user.dart';
import 'package:bandaid/page/profile_page.dart';
import 'package:bandaid/utils/user_functions.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class followPage extends StatefulWidget {
  final followlist;
  final bool following;
  const followPage(
      {Key? key, required this.followlist, required this.following})
      : super(key: key);

  @override
  State<followPage> createState() =>
      _followPageState(followlist: followlist, following: following);
}

class _followPageState extends State<followPage> {
  final followlist;
  final bool following;
  bool showProgress = true;
  List<User> users = [];
  _followPageState({required this.followlist, required this.following});

  void initState() {
    super.initState();
    _fetchUsers();
    Future.delayed(Duration(milliseconds: 50), () {
      setState(() {
        showProgress = false;
      });
    });
  }

  void _fetchUsers() async {
    List<User> fetchedUsers = await getAllUserDetails();
    setState(() {
      users =
          fetchedUsers.where((user) => followlist.contains(user.id)).toList();
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(title: following ? "Following" : "Followers"),
      body: users.isNotEmpty
          ? ListView.builder(
              padding: EdgeInsets.only(top: 16.sp),
              itemCount: users.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ProfilePage(
                              user_id: users[index].id,
                            ))),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.sp, vertical: 15.sp),
                      child: Row(children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(users[index].getImageStatic()),
                          maxRadius: 20.sp,
                        ),
                        SizedBox(
                          width: 16.sp,
                        ),
                        Expanded(
                            child: Container(
                                color: Colors.transparent,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        users[index].getName(),
                                        style: TextStyle(fontSize: 17.sp),
                                      ),
                                    ])))
                      ]),
                    ));
              })
          : Center(
              child: showProgress
                  ? CircularProgressIndicator() : Text("No Followers")),
    );
  }
}
