import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

// To use the create user function.
import 'package:firebase_auth/firebase_auth.dart';

// Use this when initializing the firebase.
import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // choose and run the homepage
      home: const HomeApp(),
    ));
}

// use stl to quickly create a stateless widget.
class HomeApp extends StatefulWidget {
  const HomeApp({super.key});

  @override
  State<HomeApp> createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  // creating 2 TextEditingController which take whatever input inside a textfield.
  // declaring a variable as late makes sure that the variables will have values, but in the future.
  late final TextEditingController _email;
  late final TextEditingController _password;

  // But must create an initializer and a disposer manually.
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // to create app bars and materials and such use Scaffold.
    return Scaffold(
      
      // Shows on top of the app and make an instance of it
      appBar: AppBar(
        // The text that'll show on top of the appBar.
        title: const Text('Register'),
        ),
        // inside that white area 'Canvas u might say'.
        // Child is anything that u'll put inside the parent element, in this case TextButton is the parent and Text is the child.
        // FutureBuilder is something that based on a condition it'll build the Widgets.
        body: FutureBuilder(
          future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform
            ),

            // snapshot is a state, u can get the result of the future using it.
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return Column(
                children: [
                  // Creating 2 'textboxes' one for email and the second for password.
                  // username textbox
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    enableSuggestions: false,
                    autocorrect: false,
                    controller: _email,
                    // Adding a placeholder.. 
                    decoration: const InputDecoration(
                      hintText: 'Enter Email ', 
                    ),
                  ),
                  // password textbox
                  TextField(
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    controller: _password,
                    decoration: const InputDecoration(
                      hintText: 'Enter Password ',
                    ),
                  ),
                  TextButton(onPressed: () async {
                    // Must initialize Firebase before using it!
                    await Firebase.initializeApp(
                      options: DefaultFirebaseOptions.currentPlatform,
                    );
                    // Note: if any "Configuration not found" error is there, go to the console website and enable the configuration for ur security option "email and password, facebook, apple, twitter.... sign in"
                    // as the user clicks on the button create 2 variables and get the text from the text boxes using the TextEditingController
                    final email = _email.text;
                    final password = _password.text;
            
                    // must put await as this is a Future function.
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: email,
                        password: password
                        );
                      }, child: const Text('Register'),),
                  ],
                );
                default:
                  return const Text('Loading...');
              }
          }, 
        ),
    );
  }
}