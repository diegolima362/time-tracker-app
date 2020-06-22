import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/app/home/jobs_page.dart';
import 'package:time_tracker_app/app/sign_in/sign_in_page.dart';
import 'package:time_tracker_app/services/auth.dart';
import 'package:time_tracker_app/services/database.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);

    return StreamBuilder<User>(
      stream: auth.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User user = snapshot.data;
          if (user == null) {
            return SignInPage.create(context);
          } else {
            return Provider<Database>(
              create: (_) => FirestoreDatabase(uid: user.uid),
              child: JobsPage(),
            );
          }
        } else {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Log In ...',
                    style: TextStyle(
                      fontSize: 38.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  CircularProgressIndicator(
                    backgroundColor: Colors.amber,
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
