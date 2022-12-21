import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:social_integration/features/login/login_page.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late User user;

  @override
  void initState() {
    // TODO: implement initState
    user = widget.user;
    print("photo ${user.photoURL}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile"
        ),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(

            children: [
              CachedNetworkImage(

                imageUrl: user.photoURL??"",
                imageBuilder: (context, imageProvider) => Container(
                  width: 60.0,
                  height: 60,
                  decoration: BoxDecoration(
                    shape:BoxShape.circle ,
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
                placeholder: (context, url) => const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.person),
              ),
              const SizedBox(
                height:20,
              ),
              Text(
                user.displayName??"",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500
                ),
              ),
          const SizedBox(
            height:20,
          ),
          Text(
            user.email??"",
            style: const TextStyle(
                fontSize: 18,
                color: Colors.blue,
              fontStyle: FontStyle.italic
            ),
          ),
              const SizedBox(
                height: 50,
              ),
              ElevatedButton(
                  onPressed: (){
                     signOut();
                     Navigator.pushAndRemoveUntil(
                         context, MaterialPageRoute(
                         builder: (context) => LoginPage(
                         )
                     ), (route)=> false
                     );
                  },
                  child: const Text(
                    "Signout"
                  ))
            ],
          ),

        ),
      ),

    );
  }

  signOut()  async {
    List<String> userSignInMethods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(user.email!);

    switch(userSignInMethods.first){
      case "facebook.com":{
        await FacebookAuth.instance.logOut();
      }
      break;
      case "google.com":{
        await GoogleSignIn().signOut();
      }
      break;
    }

  }
}
