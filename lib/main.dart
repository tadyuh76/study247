import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studie/constants/colors.dart';
import 'package:studie/firebase_options.dart';
import 'package:studie/screens/about_screen/about_screen.dart';
import 'package:studie/screens/create_room_screen/create_room_screen.dart';
import 'package:studie/screens/root_screen/root_screen.dart';
import 'package:studie/screens/settings_screen/settings_screen.dart';
import 'package:studie/screens/sign_in_screen/sign_in_screen.dart';
import 'package:studie/screens/sign_up_screen/sign_up_screen.dart';
import 'package:studie/screens/solo_study_screen/solo_study_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: App()));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown,
        },
      ),
      theme: ThemeData(
        fontFamily: 'Quicksand',
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ThemeData().colorScheme.copyWith(primary: kPrimaryColor),
      ),
      routes: {
        SignInScreen.routeName: ((context) => const SignInScreen()),
        SignUpScreen.routeName: ((context) => const SignUpScreen()),
        RootScreen.routeName: ((context) => const RootScreen()),
        CreateRoomScreen.routeName: ((context) => const CreateRoomScreen()),
        SoloStudyScreen.routeName: ((context) => const SoloStudyScreen()),
        SettingsScreen.routeName: ((context) => const SettingsScreen()),
        AboutScreen.routeName: ((context) => const AboutScreen()),
      },
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const RootScreen();
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return const SignInScreen();
        },
      ),
      builder: (context, child) => _Unfocus(child: child!),
    );
  }
}

// unfocus the keyboard whenever user tap the screen
class _Unfocus extends StatelessWidget {
  final Widget child;
  const _Unfocus({required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusManager.instance.primaryFocus?.unfocus,
      behavior: HitTestBehavior.translucent,
      child: child,
    );
  }
}
