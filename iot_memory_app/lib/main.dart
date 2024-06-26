import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'userInfo.dart';
import 'userPage.dart';
import 'memory.dart';
import 'speed.dart';

late FirebaseApp iot_app;
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  iot_app = await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override

  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthRepository.instance(iot_app),
      child:MaterialApp(
        title: 'IOT',
        theme: ThemeData(
              primarySwatch: Colors.deepPurple,
            ),
        routes: {
          '/': (context) =>  const MyHomePage(),
          '/user' : (context) => UserPage(),
          '/user/memory' : (context) => memoryGame(),
          '/user/speed' : (context) => speedGame(),
        }
      )
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  final ScrollController scrollController = ScrollController();
  GlobalKey textFieldKey = GlobalKey();
  FocusNode emailFocusNode = FocusNode();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();
  late AnimationController animationController;
  late Animation<double> _animation;
  final snackBarDiffPass = const SnackBar(
    content: Text( 'Error signing up: passwords do not match'),
  );
  final snackBarSignUpSuccess = const SnackBar(
    content: Text( 'You\'ve singed up successfully'),
  );
  bool _isLogin = true;
  bool _isLoading = false;
  bool validate = true;

  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(animationController);
  }

  String removeSquareBracketSections(String input) {
    RegExp regex = RegExp(r'\[.*?\]');
    return input.replaceAll(regex, '');
  }

  Future<void> _perform_Repository() async {
    final authRepository = Provider.of<AuthRepository>(context,  listen : false);

    if (!_isLogin) {
      if (confirmController.text == passwordController.text) {
        setState(() {
          _isLoading = true;
        });
        try {
          var isSuccess = await authRepository.signUp(
            userNameController.text.trim(),
            passwordController.text,
          );
          if (!mounted) return;
          if (isSuccess != null) {
            ScaffoldMessenger.of(context).showSnackBar(snackBarSignUpSuccess);
            await authRepository.signIn(
              userNameController.text.trim(),
              passwordController.text,
            );
            setState(() {
              _isLoading = false;
            });
            Navigator.of(context).pushNamed('/user');
            return;
          }
        }
        catch (e) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(removeSquareBracketSections(e.toString())),
              duration: Duration(seconds: 4),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(snackBarDiffPass);
        setState(() {
          validate = false;
          FocusScope.of(context).unfocus();
          return;
        });
      }
    }else{
      setState(() {
        _isLoading = true;
      });
      try {
        await authRepository.signIn(
          userNameController.text.trim(),
          passwordController.text,
        );
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pushNamed('/user');
        return;
      }
      catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(removeSquareBracketSections(e.toString())),
            duration: Duration(seconds: 4),
          ),
        );
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[100],
      ),

      body:SingleChildScrollView(
        controller: scrollController,
        child: Center(
            child: Stack(
                children: <Widget>[
                  Column(
                      children: <Widget>[

                        Container(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),

                        Container(
                          height: MediaQuery.of(context).size.height * 0.07,
                          child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Musical',
                                style: TextStyle(color: Colors.pink[700], fontWeight: FontWeight.bold, fontSize: 26),
                                ),
                                TextSpan(
                                text: ' Memory',
                                style: TextStyle(color: Colors.orange[800], fontWeight: FontWeight.bold, fontSize: 26),
                                ),
                                TextSpan(
                                text: ' Game',
                                style: TextStyle(color: Colors.lightBlue[700], fontWeight: FontWeight.bold, fontSize: 26),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Container(
                          width: 150.0,
                          height: 150.0,
                          decoration: const BoxDecoration(
                            image:  DecorationImage(
                              image:  AssetImage('assets/logIn2.png'),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),

                        Container(
                          width: 300.0,
                          padding: const EdgeInsets.only(top: 50.0),
                          child: TextFormField(
                            key: textFieldKey,
                            focusNode: emailFocusNode,
                            controller: userNameController,
                            decoration:   InputDecoration(
                              filled: true,
                              fillColor: Colors.deepPurple[100],
                              labelText: 'Username',
                              labelStyle:  TextStyle(color: Colors.deepPurple[700], fontSize: 24),
                              prefixIcon:  Icon(Icons.person, color: Colors.deepPurple[700],  size: 30),
                              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                              enabledBorder:  UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: Colors.deepPurple[400]!),
                              ),
                            ),
                            onEditingComplete: () {
                              FocusScope.of(context).nextFocus();
                            },
                          ),
                        ),

                        Container(
                          width: 300.0,
                          padding: const EdgeInsets.only(top: 10.0),
                          child: TextFormField(
                              keyboardType: TextInputType.visiblePassword,
                              controller: passwordController,
                              obscureText: true,
                              decoration:   InputDecoration(
                                filled: true,
                                fillColor: Colors.deepPurple[100],
                                labelText: 'Password',
                                labelStyle:  TextStyle(color: Colors.deepPurple[700], fontSize: 24),
                                prefixIcon:  Icon(Icons.password, color: Colors.deepPurple[700], size: 30),
                                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                enabledBorder:  UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(color: Colors.deepPurple[400]!),
                                ),
                              ),
                              onEditingComplete: () async {
                                _isLogin? await _perform_Repository() : FocusScope.of(context).nextFocus();
                              }
                          ),
                        ),

                        Visibility(
                          visible: !_isLogin,
                          child:FadeTransition(
                            opacity: _animation,
                            child: Container(
                              width: 300.0,
                              padding: const EdgeInsets.only(top: 10.0),
                              child: TextFormField(
                                  keyboardType: TextInputType.visiblePassword,
                                  controller: confirmController,
                                  obscureText: true,
                                  decoration:   InputDecoration(
                                    filled: true,
                                    fillColor: Colors.deepPurple[100],
                                    labelText: 'Verify Password',
                                    labelStyle:  TextStyle(color: Colors.deepPurple[700], fontSize: 24),
                                    prefixIcon:  Icon(Icons.password, color: Colors.deepPurple[700], size: 30),
                                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                    enabledBorder:  UnderlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(color: Colors.deepPurple[400]!),
                                    ),
                                  ),
                                  onEditingComplete: () async {
                                    await _perform_Repository();
                                  }
                              ),
                            ),
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.only(top: 50.0),
                          child: SizedBox(
                            width: 300.0,
                            height: 55.0,
                            child: ElevatedButton(
                              onPressed: () async {
                                await _perform_Repository();
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color?>(Colors.deepPurple[400]),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                ),
                              ),
                              child:  Text(_isLogin ? 'Log In' : 'Sign Up',
                                style: TextStyle(
                                  color: Colors.deepPurple[50],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22.0,
                                ),
                              ),
                            ),
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: SizedBox(
                            width: 300.0,
                            height: 55.0,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _isLogin = !_isLogin;
                                  if (_isLogin) {
                                    animationController.reverse();
                                  } else {
                                    animationController.forward();
                                  }
                                });
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color?>(Colors.deepPurple[100]),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                ),
                              ),
                              child: Text(_isLogin
                                  ? 'Don\'t have an account?\nSign up'
                                  : 'Already have an account? Login',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.deepPurple[700],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                ),
                              ),

                            ),
                          ),
                        ),

                        Container(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                        if (_isLoading)
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 1.3,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                      ]
                  ),
                ]
            )
        ),
      ),
    );
  }

}
