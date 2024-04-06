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
      body: SingleChildScrollView(
        child: Column(
          children:  <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            Text("Welcome $user_name", style: TextStyle(fontSize: size,fontWeight: FontWeight.bold, color: Colors.deepPurple),),
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
                  onTap: () { _showSpeedDialog(context);},
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

                Container(
                          width: MediaQuery.of(context).size.width*0.1,
                          height: 150.0,
                ),
                GestureDetector(
                  onTap: () { _showMemoryDialog(context);},
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

    void _showMemoryDialog(BuildContext context) {
      showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
          content: Column(
            children:  <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.03,
            ),

            Text('Memory Game',
            style: TextStyle(color: Colors.lightBlue[700], fontWeight: FontWeight.bold, fontSize: 35),
            ),

            Text('Guide',
            style: TextStyle(color: Colors.yellow[700], fontWeight: FontWeight.bold, fontSize: 35),
            ),

            Container(
                height: 20,
            ),

            Row(
              children: [
                  Container(
                    width: 20,
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Aim Of The Game:\n',
                          style: TextStyle(color: Colors.lightBlue[700], fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          TextSpan(
                          text: 'Test your memory',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
              ]
            ),

            Container(
              height: 20,
            ),
            Row(
              children: [
                  Container(
                    width: 20,
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'How To Play:\n',
                          style: TextStyle(color: Colors.lightBlue[700], fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          TextSpan(
                          text: '1. Switch to Memory Game.\n',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          TextSpan(
                          text: '2. Wait for the ring to Turn off.\n',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          TextSpan(
                          text: '3. Press any button to start.\n',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          TextSpan(
                          text: '4. GAME STARTED\n     starting with a sequence\n     of one press.\n',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          TextSpan(
                          text: '5. press the buttons in order\n',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          TextSpan(
                          text: 'The game will add a step\n in each level,\n so stay focused!\n',
                          style: TextStyle(color: Colors.lightBlue[700], fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          TextSpan(
                          text: 'If you miss a press, GAME OVER\n',
                          style: TextStyle(color: Colors.red[600], fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          TextSpan(
                          text: 'Keep it up untill level 16\n',
                          style: TextStyle(color: Colors.lightBlue[700], fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          TextSpan(
                          text: 'We Have A WINNER\n',
                          style: TextStyle(color: Colors.green[600], fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          TextSpan(
                          text: '6. Wait for all buttons to turn off\n     before starting a new game\n     data is being saved.\n',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
              ]
            ),
            
          ],
          )
        );
      }
      );
    }

    void _showSpeedDialog(BuildContext context) {
      showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
          content: Column(
            children:  <Widget>[
              Container(
              height: MediaQuery.of(context).size.height * 0.03,
            ),

            Text('Speed Game',
            style: TextStyle(color: Colors.pink[700], fontWeight: FontWeight.bold, fontSize: 35),
            ),

            Text('Guide',
            style: TextStyle(color: Colors.orange[700], fontWeight: FontWeight.bold, fontSize: 35),
            ),

            Container(
                height: 20,
            ),

            Row(
              children: [
                  Container(
                    width: 20,
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Aim Of The Game:\n',
                          style: TextStyle(color: Colors.orange[800], fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          TextSpan(
                          text: 'Test your quick response',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
              ]
            ),

            Container(
              height: 20,
            ),
            Row(
              children: [
                  Container(
                    width: 20,
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'How To Play:\n',
                          style: TextStyle(color: Colors.orange[700], fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          TextSpan(
                          text: '1. Switch to Speed Game.\n',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          TextSpan(
                          text: '2. Wait for the ring to Turn off.\n',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          TextSpan(
                          text: '3. Press any button to start.\n',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          TextSpan(
                          text: '4. GAME STARTED\n     Look for the button that is lit.\n',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          TextSpan(
                          text: '4. Quickly press the lit button\n',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          TextSpan(
                          text: 'The game will get faster,\n so stay focused!\n',
                          style: TextStyle(color: Colors.pink[700], fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          TextSpan(
                          text: 'If you miss a press, GAME OVER\n',
                          style: TextStyle(color: Colors.red[600], fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          TextSpan(
                          text: 'Keep it up untill level 16\n',
                          style: TextStyle(color: Colors.orange[700], fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          TextSpan(
                          text: 'We Have A WINNER\n',
                          style: TextStyle(color: Colors.green[600], fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          TextSpan(
                          text: '5. Wait for all buttons to turn off\n     before starting a new game\n     data is being saved.\n',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
              ]
            ),
            ],
          )
        );
      }
      );
    }
}
