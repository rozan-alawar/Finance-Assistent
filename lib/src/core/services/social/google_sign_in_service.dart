import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInService {
  final GoogleSignIn _googleSignIn;

  GoogleSignInService({String? serverClientId})
    : _googleSignIn = GoogleSignIn(
        scopes: const ['email', 'profile'],
        serverClientId: serverClientId,
      );

  Future<({String? token, String? error})> signInToken() async {
    try {
      GoogleSignInAccount? account = await _googleSignIn.signInSilently();
      account ??= await _googleSignIn.signIn();
      if (account == null) {
        return (token: null, error: 'Sign-in cancelled or not configured');
      }
      final auth = await account.authentication;
      final token = auth.idToken ?? auth.accessToken;
      if (token == null || token.isEmpty) {
        return (token: null, error: 'Missing token from Google');
      }
      return (token: token, error: null);
    } catch (e) {
      return (token: null, error: e.toString());
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}
