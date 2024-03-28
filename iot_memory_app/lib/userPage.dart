import 'package:flutter/material.dart';
import 'userInfo.dart';
import 'package:provider/provider.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    double size = 35;
    final authRepository = Provider.of<AuthRepository>(context,  listen : false);
    String user_name = authRepository.userName;
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
      backgroundColor: Colors.deepPurple[100],
      iconTheme: IconThemeData(color: Colors.deepPurple[400],),
      leading: IconButton(
            icon: const Icon(Icons.logout_outlined, color: Colors.deepPurple),
            onPressed: () async{
                await authRepository.logOut();
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
          ),
      ),
      body: Center(
        child: Column(
          children:  <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.03,
            ),

            RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'W',
                  style: TextStyle(color: Colors.yellow[700], fontWeight: FontWeight.bold, fontSize: size),
                ),
                TextSpan(
                  text: 'e',
                  style: TextStyle(color: Colors.lightBlue[700], fontWeight: FontWeight.bold, fontSize: size),
                ),
                TextSpan(
                  text: 'l',
                  style: TextStyle(color: Colors.orange[800], fontWeight: FontWeight.bold, fontSize: size),
                ),
                TextSpan(
                  text: 'c',
                  style: TextStyle(color: Colors.pink[700], fontWeight: FontWeight.bold, fontSize: size),
                ),
                TextSpan(
                  text: 'o',
                  style: TextStyle(color: Colors.lightBlue[700], fontWeight: FontWeight.bold, fontSize: size),
                ),
                TextSpan(
                  text: 'm',
                  style: TextStyle(color: Colors.orange[800], fontWeight: FontWeight.bold, fontSize: size),
                ),
                TextSpan(
                  text: 'e',
                  style: TextStyle(color: Colors.pink[700], fontWeight: FontWeight.bold, fontSize: size),
                ),
                TextSpan(
                  text: ' $user_name', // Include the user name after "Welcome"
                  style: TextStyle(color: Colors.deepPurple[400], fontWeight: FontWeight.bold, fontSize: size),
                ),
              ],
            ),
            ),

            Container(
              height: MediaQuery.of(context).size.height * 0.04,
            ),

            Row(
              children: [
                GestureDetector(
                  onTap: () { Navigator.of(context).pushNamed('/user/speed');},
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.45,
                    height: MediaQuery.of(context).size.width * 0.45,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/pink.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Container(
                          width: MediaQuery.of(context).size.width*0.1,
                          height: 150.0,
                ),
                GestureDetector(
                  onTap: () { Navigator.of(context).pushNamed('/user/speedGuide');},
                  child: Container(
                          width: MediaQuery.of(context).size.width*0.45,
                          height: MediaQuery.of(context).size.width*0.45,
                          decoration: const BoxDecoration(
                            image:  DecorationImage(
                              image:  AssetImage('assets/orange.png'),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                ),
              ],
            ),

            Container(
                      width: 150.0,
                      height: 50.0,
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () { Navigator.of(context).pushNamed('/user/memoryGuide');},
                  child: Container(
                          width: MediaQuery.of(context).size.width*0.45,
                          height: MediaQuery.of(context).size.width*0.45,
                          decoration: const BoxDecoration(
                            image:  DecorationImage(
                              image:  AssetImage('assets/yellow.png'),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                ),
                Container(
                          width: MediaQuery.of(context).size.width*0.1,
                          height: 150.0,
                ),
                GestureDetector(
                  onTap: () { Navigator.of(context).pushNamed('/user/memory');},
                  child: Container(
                          width: MediaQuery.of(context).size.width*0.45,
                          height: MediaQuery.of(context).size.width*0.45,
                          decoration: const BoxDecoration(
                            image:  DecorationImage(
                              image:  AssetImage('assets/blue.png'),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                ),
              ],
            ),

            Container(
              height: 30,
            ),
            GestureDetector(
              onTap: () { _showDialog(context); },
              child: Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        image:  DecorationImage(
                          image:  AssetImage('assets/ques.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
            ),
          ]
          ,)
      ),
    );
  }

    void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/yellow_ring.png', width: 50, height: 50),
              Text('Yellow Light: connecting to WIFI'),
              SizedBox(height: 20),
              Image.asset('assets/blue_ring.png', width: 50, height: 50),
              Text('Blue Light: Memory Game'),
              SizedBox(height: 20),
              Image.asset('assets/pink_ring.png', width: 50, height: 50),
              Text('Pink Light: Speed Game'),
              SizedBox(height: 20),
              Image.asset('assets/green_ring.png', width: 50, height: 50),
              Text('Green Light: Game Level'),
              SizedBox(height: 20),
              Image.asset('assets/red_ring.png', width: 50, height: 50),
              Text('Red Light: You Lost :( Game Over'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
