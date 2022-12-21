
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:social_integration/features/profile/profile_page.dart';
import 'package:provider/provider.dart';

import '../../core/widgets/show_loader.dart';
import '../../core/widgets/snack_bar.dart';
import 'provider/sign_in_provider.dart';





class LoginPage extends StatefulWidget {
  const LoginPage({super.key});



  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {


  late User user;
  // SignIn signIn = SignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SignInButton(
              Buttons.Google,
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),

              onPressed: () async {
                handleSignIn("google");

              },
            ),
            SizedBox(
              height: 20,
            ),
            SignInButton(
              Buttons.Facebook,
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),

              onPressed: () async {
                handleSignIn("facebook");

              },
            ),
          ],
        ),
      ),

    );
  }

  handleSignIn(String method) async {
    SignInProvider provider = context.read<SignInProvider>();

    switch(method){
      case "google":
        await provider.signInWithGoogle();
        break;
      case "facebook":
        await provider.signInWithFacebook();
        break;

    }



    if(provider.isLoading){
      showLoaderDialog(context);
    }else if (provider.error.isNotEmpty){
      showSnackBar(context, provider.error);
    }else if (provider.user != null){
      user= provider.user!;
      print("user...$user");
      openProfilePage();
    }
  }

  openProfilePage(){
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => ProfilePage(
            user: user
        )));
  }




}
