import 'package:flutter/material.dart';
import 'package:time_tracker_app/app/home_page.dart';
import 'package:time_tracker_app/app/sign_in/sign_in_page.dart';
import 'package:time_tracker_app/services/auth.dart';

class LandingPage extends StatefulWidget {
  final AuthBase auth;

  const LandingPage({Key key, @required this.auth}) : super(key: key);
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  User _user;

  void _updateUser(User user) {
    setState(() {
      _user = user;
    });
  }

  Future<void> _checkCurrentUser() async {
    User user = await widget.auth.currentUser();
    _updateUser(user);
  }

  @override
  void initState() {
    super.initState();
    _checkCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null)
      return SignInPage(
        onSignIn: _updateUser,
        auth: widget.auth,
      );
    else
      return HomePage(
        onSignOut: () => _updateUser(null),
        auth: widget.auth,
      );
  }
}
