import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_final/features/splash_screen/splash_screen.dart';
import 'package:flutter_final/home_screen.dart';
import 'package:flutter_final/main_game/game_data.dart';
import 'package:flutter_final/main_game/pages/create_page.dart';
import 'package:flutter_final/main_game/pages/home_page.dart';
import 'package:flutter_final/main_game/pages/join_page.dart';
import 'package:flutter_final/user_auth/presentation/pages/login_page.dart';
import 'firebase_options.dart';
import 'package:flutter_final/main_game/pages/tic_tac_toe.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      routes: {
        '/': (context) => const SplashScreen(
              text: "我的遊戲",
              child: LoginPage(),
            ),
        '/home': (context) => const HomePage(),
        '/create':(context)=>const CreatePage(),
        '/join':(context)=>const JoinPage(),
        '/test':(context)=>const HomeScreen(),
        '/ticTacToe':(context)=>TicTacToe(),
      
      },
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             TextButton(onPressed: (){} , child: const Text("google")),
//           ],
//         ),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
