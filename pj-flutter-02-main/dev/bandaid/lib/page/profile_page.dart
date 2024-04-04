import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:bandaid/components/app_bar.dart';
import 'package:bandaid/components/gradient_button.dart';
import 'package:bandaid/components/player_widget.dart';
import 'package:bandaid/utils/api_endpoints.dart';

import 'package:bandaid/utils/user_functions.dart';
import 'package:flutter/material.dart';
import 'package:bandaid/model/user.dart';
import 'package:bandaid/utils/user_preferences.dart';
import 'package:bandaid/widget/appbar_widget.dart';
import 'package:bandaid/widget/numbers_widget.dart';
import 'package:bandaid/widget/profile_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ProfilePage extends StatefulWidget {
  final user_id;
  ProfilePage({required this.user_id});
  @override
  State<ProfilePage> createState() {
    return _ProfilePageState(user_id: user_id);
  }
}

class _ProfilePageState extends State<ProfilePage> {
  final user_id;
  User? user;
  User? current_user;
  bool loading = true;
  bool? me = false;
  Uint8List? bytes;
  final player = AudioPlayer();
  _ProfilePageState({required this.user_id});

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  void _fetchUsers() async {
    User fetched_current_user = await getCurrentUserDetails(context);
    User fetched_user = await getUserDetails(user_id);
    dynamic fetched_bytes = await getUserSound(user_id);
    setState(() {
      current_user = fetched_current_user;
      user = fetched_user;
      me = (user!.id == current_user!.id);
      if (fetched_bytes != null) {
        bytes = fetched_bytes;
        player.setSourceBytes(fetched_bytes);
      }
      loading = false;
    });
  }

  Future<void> _uploadAndRefresh() async {
    try {
      await uploadImage();
      _refresh();
    } catch (error) {
      // Handle errors (e.g., show an error message)
      print("Error uploading image: $error");
    }
  }

  Future<void> _refresh() async {
    try {
      _fetchUsers();
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: (me!),
      appBar: (!loading && !me!)
          ? GradientAppBar(title: (user!.getName()))
          : AppBar(backgroundColor: Colors.transparent, elevation: 0.0),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: (!loading)
            ? (Column(
                children: [
                  const SizedBox(height: 24),
                  ProfileWidget(
                      imagePath:
                          (!me!) ? user!.getImageStatic() : user!.getImage(),
                      onClicked: () {
                        if (current_user!.id == user!.id) {
                          _uploadAndRefresh();
                        }
                      },
                      me: me!),
                  const SizedBox(height: 24),
                  buildName(user!),
                  const SizedBox(height: 24),
                  NumbersWidget(
                      followers: user!.followers, following: user!.following),
                  const SizedBox(height: 24),
                  (!me!)
                      ? (current_user!.following.contains(user!.id)
                          ? GradientButton(
                              text: "Unfollow",
                              onPressed: () => {unfollow(user!.id), _refresh()})
                          : GradientButton(
                              text: "Follow",
                              onPressed: () => {follow(user!.id), _refresh()}))
                      : Text(""),
                  (!me!)
                      ? SizedBox(
                          height: 24,
                        )
                      : Text(""),
                  Row(
                    children: [
                      buildGenres(user!),
                      const SizedBox(width: 24,),
                      buildInstruments(user!),
                    ],
                  ),
                  const SizedBox(height: 24,),
                  if (bytes != null)
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 10, bottom: 20),
                            child: Text(
                              'Latest Sample',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ),
                          PlayerWidget(player: player)
                        ]),
                  const SizedBox(height: 24),
                  buildAbout(user!),
                  const SizedBox(height: 24),
                  (me!)
                      ? GradientButton(
                          text: "Log Out", onPressed: () => {logout(context)})
                      : Text(""),
                ],
              ))
            : SizedBox(
                height: 80.h,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
      ),
    );
  }

  Widget buildName(User user) => Column(
    crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              user.name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );

  Widget buildAbout(User user) => Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              user.about,
              style: TextStyle(fontSize: 16, height: 1.4),
            ),
          ],
        ),
      );

    Widget buildGenres(User user) => Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Genres',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            user.genres.length >= 1 ?Text(
              user.genres[0],
              style: TextStyle(fontSize: 16),
            ) : Text("None"),
            user.genres.length >= 2 ?Text(
              user.genres[1],
              style: TextStyle(fontSize: 16),
            ) : Text(""),
            user.genres.length >= 3 ?Text(
              user.genres[2],
              style: TextStyle(fontSize: 16),
            ): Text(""),
          ],
        ),
      );

      Widget buildInstruments(User user) => Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Instruments',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            user.instruments.length >= 1 ?Text(
              user.instruments[0],
              style: TextStyle(fontSize: 16),
            ) : Text("None"),
            user.instruments.length >= 2 ? Text(
              user.instruments[1],
              style: TextStyle(fontSize: 16),
            ) : Text(""),
            user.instruments.length >= 3 ? Text(
              user.instruments[2],
              style: TextStyle(fontSize: 16),
            ): Text(""),
          ],
        ),
      );

  
}
