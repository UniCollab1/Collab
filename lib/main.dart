import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unicollab/services/firebase_auth_service.dart';

import 'file:///C:/Users/shrey/StudioProjects/Collab/lib/app/auth/auth_widget.dart';
import 'file:///C:/Users/shrey/StudioProjects/Collab/lib/app/auth/auth_widget_builder.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthService>(create: (_) => FirebaseAuthService()),
      ],
      child: AuthWidgetBuilder(builder: (context, userSnapshot) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(),
          home: AuthWidget(userSnapshot: userSnapshot),
        );
      }),
    );
  }
}
