import 'package:bandaid/model/user.dart';
import 'package:bandaid/page/profile_page.dart';
import 'package:bandaid/utils/api_endpoints.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class user_card extends StatelessWidget {
  final User user;
  user_card({required this.user});

  @override
  Widget build(context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ProfilePage(user_id: user.id)));
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 4,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: FutureBuilder<PaletteGenerator>(
                // Use FutureBuilder to asynchronously get the average color
                future: _generatePalette(context),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    // Use the average color for the background
                    Color backgroundColor = snapshot.data!.dominantColor!.color;

                    return Stack(
                      children: [
                        Image.network(
                          getServerApiUrl(
                              user.imagePath + "/" + user.id.toString()),
                          height: 40.h,
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.fill,
                        ),
                        ListTile(
                          title: Text(
                            user.getName(),
                            style: TextStyle(
                              fontSize: 20,
                              color: _getTextColor(backgroundColor),
                            ),
                          ),
                          subtitle: Text(
                            user.title,
                            style: TextStyle(
                              color: _getTextColor(backgroundColor),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              user.address,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: _getTextColor(backgroundColor),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    // Display a placeholder while the color is being calculated
                    return Container(
                      height: 40.h,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey, // Placeholder color
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<PaletteGenerator> _generatePalette(BuildContext context) async {
    // Generate the color palette for the image
    return PaletteGenerator.fromImageProvider(
      NetworkImage(getServerApiUrl(user.imagePath + "/" + user.id.toString())),
      size: Size(40.h, MediaQuery.of(context).size.width),
    );
  }

  // Function to calculate text color based on background color brightness
  Color _getTextColor(Color backgroundColor) {
    return backgroundColor.computeLuminance() > 0.5
        ? Colors.black
        : Colors.white;
  }
}
