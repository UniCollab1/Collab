import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:unicollab/services/firebase_auth_service.dart';
import 'package:unicollab/services/firestore_service.dart';

class SignInPage extends StatelessWidget {
  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      final auth = Provider.of<FirebaseAuthService>(context, listen: false);
      await auth.signInWithGoogle();
      final fireStore = Provider.of<FireStoreService>(context, listen: false);
      await fireStore.addUserToFireStore();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Text(
                  'UNICOLLAB',
                  style: GoogleFonts.sourceSansPro(
                    fontSize: 80,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              SizedBox(
                height: 50.0,
              ),
              Container(
                child: CupertinoButton.filled(
                  child: Text('Continue with Google'),
                  onPressed: () => _signInWithGoogle(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
