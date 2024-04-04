import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInApi {
  static final _googleSignIn = GoogleSignIn();

  static Future<String?> login() => _googleSignIn.signIn().then((result) {
        return result?.authentication.then((googleKey) {
          var idToken = googleKey.idToken;
          return idToken;
        });
      });
  static Future logout() => _googleSignIn.disconnect();
}
