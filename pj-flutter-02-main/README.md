# Project Name
BandAid

# Project Description
BandAid is a software solution to provide an intuitive way for musicians to collaborate together to experiment and produce different genres of music that they don't normally try themselves as well as sounds and techniques that they are not familiar with. Using BandAid, musicians can create their own profiles on the app by providing their personal and professional experience, and then they can easily connect with other musicians on the app. In addition, the app enables musicians to share their ideas, interact socially, and collaborate on different projects in a simple and easy manner.

# MVP Deployment Instructions
Note: It is preferred that you use Visual Studio Code and an iOS simulator to run this application as the instructions are based upon the assumption that both of these are installed on your local device.

Instructions:
- Clone the repository (pj-flutter-02) and change directories into a folder called "bandaid" (can be done by typing "cd pj-flutter-02/dev/bandaid" in the terminal).
- Type the following instructions in the terminal (in order):
  - "flutter pub get" to install all dependencies
  - "flutter build ios" to build the application
  - "flutter run" in the terminal to run the application on your device
  
-  If "flutter run" does not work, try running a file called "Runner.xcworkspace" (found in pj-flutter-02/dev/bandaid/ios) from Xcode. This should open up the application successfully.

- If "flutter run" opens up a web version of the application, it means that the simulator is not directly linked to your IDE. In that case, do the following instead:
  - Launch the iOS simulator via the command palette (Ctrl+Shift+P) in Visual Studio Code. Then, run "main.dart" (found under dev/bandaid/lib) in debug mode. The application should automatically load on the phone simulation being displayed on your device's screen.

If you can run the app on an iOS simulator, you should be able to deploy the application onto an actual iPhone by following the instructions at this link: https://docs.flutter.dev/get-started/install/macos#deploy-to-physical-ios-devices

# Project Members
- Aviv, 59664942, AvivSamet
- Andy, 77651728, andysglez
- Kirill, 77711406, kirrarista
- Leon, 59664884, LeonFeng0325
- Rishabh, 40368609, rishabhpoikayil

# Tech Stack
- Flutter
- Python
- SQLAlchemy
- FastAPI
- AWS (Deployment)

# Project Use Case
End users can upload their personal profiles including their location, personal interests, musical skills, social medias, and so on. After signing up, users can look up other musicians using the search ability given certain parameters such as distance and musical skills, and connect with them to socialize and collaborate on different projects.


# Project Tech Stack BreakDown
For our project, our frontend will be built using Flutter framework with Dart. And our backend will be built using FastAPI framework with Python, and our backend will provide custom authentication, Google Oauth, and other CRUD capabilities. And we will deploy our backend to AWS.

Role: Amateur musicians, site admins.


# Deployment
- APK: [Link](https://drive.google.com/file/d/1er4CgS66Edg0jwdvUxfaR392bfoZM6tT/view?usp=sharing)
