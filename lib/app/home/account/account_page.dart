import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/common_widgets/avatar.dart';
import 'package:time_tracker_app/common_widgets/platform_alert_dialog.dart';
import 'package:time_tracker_app/services/auth.dart';

class AccountPage extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(
        context,
        listen: false,
      );
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await PlatformAlertDialog(
      title: 'Logout',
      content: 'Are you sure that you want to logout?',
      cancelActionText: 'Cancel',
      defaultActionText: 'Logout',
    ).show(context);

    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Logout',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
            onPressed: () => _confirmSignOut(context),
          ),
        ],
        bottom: PreferredSize(
            child: _buildUserInfo(user), preferredSize: Size.fromHeight(130)),
      ),
    );
  }

  Widget _buildUserInfo(User user) {
    return Column(
      children: [
        Avatar(photoUrl: user.photoUrl, radius: 50.0),
        SizedBox(height: 8.0),
        if (user.displayName != null)
          Text(
            user.displayName,
            style: TextStyle(color: Colors.white),
          ),
        SizedBox(height: 8.0),
      ],
    );
  }
}
