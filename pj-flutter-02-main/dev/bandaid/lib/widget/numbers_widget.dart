import 'package:bandaid/page/follow_page.dart';
import 'package:flutter/material.dart';

class NumbersWidget extends StatelessWidget {
  final following;
  final followers;
  const NumbersWidget({required this.followers, required this.following});
  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          buildButton(context, followers.length.toString(), 'Followers'),
          buildDivider(),
          buildButton(context, following.length.toString(), 'Following'),
        ],
      );
  Widget buildDivider() => Container(
        height: 24,
        child: VerticalDivider(),
      );

  Widget buildButton(BuildContext context, String value, String text) =>
      MaterialButton(
        padding: EdgeInsets.symmetric(vertical: 4),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => text == "Following"
                  ? followPage(followlist: following, following: true)
                  : followPage(followlist: followers, following: false)));
        },
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              value,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            SizedBox(height: 2),
            Text(
              text,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
}
