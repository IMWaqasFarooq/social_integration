import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class SignInProvider extends ChangeNotifier {


  User? _user;
  User? get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _error = "";
  String get error => _error;

  // for loading dialog

   signInWithGoogle() async {
     _isLoading = true;
     notifyListeners();
    // Trigger the authentication flow
    GoogleSignIn signIn = GoogleSignIn();
    if(await signIn.isSignedIn()){
      signIn.signOut();
    }

    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if(googleUser != null){
      try{
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;


        // Create a new credential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );


        // Once signed in, return the UserCredential
        UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
        _user =userCredential.user;
        _isLoading = false;
        notifyListeners();

      }on FirebaseAuthException catch  (e){
        _error = await getError(e);
        _isLoading = false;
        notifyListeners();
      }
    }else{
      _error = "something went wrong";
      _isLoading = false;
      notifyListeners();
    }


    // Obtain the auth details from the request

  }

   signInWithFacebook() async {
     _isLoading = true;
     notifyListeners();

    // if(await FacebookAuth.instance.accessToken != null){
    //   await FacebookAuth.instance.logOut();
    // }
    // Trigger the sign-in flow
     try{
       final LoginResult loginResult = await FacebookAuth.instance.login(
         // permissions: ['email','public_profile']
       );



       // Create a credential from the access token
       final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);

       // Once signed in, return the UserCredential
       UserCredential credential = await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
       print("UserCredentials...${credential.toString()}");
       _user = credential.user;
       _isLoading = false;
       notifyListeners();
     }on FirebaseAuthException catch  (e){
       _error = await getError(e);
       _isLoading = false;
       notifyListeners();
     }

  }

  Future<String> getError(FirebaseAuthException e) async {
    if (e.code == 'account-exists-with-different-credential') {
      // The account already exists with a different credential
      String email = e.email!;
      AuthCredential pendingCredential = e.credential!;

      // Fetch a list of what sign-in methods exist for the conflicting user
      List<String> userSignInMethods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);

      return "this email is already register with method of ${userSignInMethods.first}";


    }else{
      return "Failed to login";
    }

  }


}