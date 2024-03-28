import 'package:flutter/material.dart';
import 'userInfo.dart';
import 'package:provider/provider.dart';

class memoryGuide extends StatefulWidget {
  @override
  _memoryGuideState createState() => _memoryGuideState();
}

class _memoryGuideState extends State<memoryGuide> {
  @override
 Widget build(BuildContext context) {
double size = 35;
    final authRepository = Provider.of<AuthRepository>(context,  listen : false);
    String user_name = authRepository.userName;
    return Scaffold(
      backgroundColor: Colors.yellow[50],
      appBar: AppBar(
      backgroundColor: Colors.yellow[100],
      iconTheme: IconThemeData(color: Colors.yellow[600],),
      ),
      body: SingleChildScrollView(
        child: Column(
          children:  <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.03,
            ),

            Text('Speed Game',
            style: TextStyle(color: Colors.lightBlue[700], fontWeight: FontWeight.bold, fontSize: size),
            ),

            Text('Guide',
            style: TextStyle(color: Colors.yellow[700], fontWeight: FontWeight.bold, fontSize: size),
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
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          TextSpan(
                          text: '2. Wait for the ring to Turn off.\n',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          TextSpan(
                          text: '3. GAME STARTED\n     starting with sequence of one press.\n',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          TextSpan(
                          text: '4. press the buttons in order\n',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          TextSpan(
                          text: 'The game will add a step in each level,\n so stay focused!\n',
                          style: TextStyle(color: Colors.lightBlue[500], fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          TextSpan(
                          text: 'If you miss a press, GAME OVER\n',
                          style: TextStyle(color: Colors.red[600], fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          TextSpan(
                          text: 'Keep it up untill level 16\n',
                          style: TextStyle(color: Colors.yellow[700], fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          TextSpan(
                          text: 'We Have A WINNER\n',
                          style: TextStyle(color: Colors.green[600], fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
              ]
            ),
            
          ],
        ),
      ),
    );
  }
}
