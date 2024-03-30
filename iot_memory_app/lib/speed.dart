import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'userInfo.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_charts/flutter_charts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:circular_charts/circular_charts.dart';
import 'package:circular_chart_flutter/circular_chart_flutter.dart';
import 'dart:async';

class speedGame extends StatefulWidget {
  @override
  _speedGameState createState() => _speedGameState();
}

class _speedGameState extends State<speedGame> {

  late StreamSubscription<DatabaseEvent> _subscription;
  Map<dynamic,dynamic> user_data = {};
  int total_games = 0;
  int total_wins = 0;
  int max_level = 0;
  double fast = 0;
  double slow = 0;
  double max_y = 0;
  int last = 0;
  List<BarChartGroupData> barsData = [];
  LinearGradient get _barsGradient => LinearGradient(
        colors: [
          Colors.deepOrange[400]!,
          Colors.deepPurple[400]!,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
  );

  void  create_bars_list() {
    total_games = 0;
    Map<String,double> data = {};
    barsData = [];
    print(user_data);
    for (var i = 1; i <= 16; i++) {
      if(user_data['speed_game']['level_$i'] != null){
        total_games = total_games + user_data['speed_game']['level_$i'] as int;
        if(i == 16) total_wins = user_data['speed_game']['level_$i'] as int;
        if(i > max_level) max_level = i;
        if(user_data['speed_game']['level_$i'].toDouble() > max_y) max_y = user_data['speed_game']['level_$i'].toDouble();
        data['$i'] = user_data['speed_game']['level_$i'].toDouble();
        barsData.add(
          BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: data['$i']!.toDouble(),
                gradient: _barsGradient,
              )
            ],
            showingTooltipIndicators: [0],
          )
        );
      }
    }
    last = user_data['speed_game']['last'] as int ?? 0;
    int f = user_data['speed_game']['fast'] as int ?? 0;
    int s = user_data['speed_game']['slow']as int ?? 0;
    fast = f.toDouble();
    slow = s.toDouble();
  }

  Widget getTitles(double value, TitleMeta meta) {
    final style = TextStyle(
      color: Colors.pink[400],
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text = value.toInt().toString();
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }

  @override
  Widget build(BuildContext context) {
    double size = 32;
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
      backgroundColor: Colors.pink[100],
      iconTheme: IconThemeData(color: Colors.pink[700],),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: Provider.of<AuthRepository>(context, listen: false).getDataStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData) {
              return Center(child: Text('No data available'));
            }

            user_data = snapshot.data?.snapshot.value as Map<dynamic,dynamic>;
            create_bars_list();
            return Column(
              children:  <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),

                Text('Speed Game',
                style: TextStyle(color: Colors.pink[700], fontWeight: FontWeight.bold, fontSize: size),
                ),

                Text('Statistics',
                style: TextStyle(color: Colors.orange[700], fontWeight: FontWeight.bold, fontSize: size),
                ),

                Container(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),

                Card(
                  color: Colors.white,
                  shadowColor: Colors.pink[700],
                  surfaceTintColor: Colors.white,
                  elevation: 10.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                    child: Column(children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.05,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Total Games: $total_games',
                          style: TextStyle(
                            color: Colors.pink[700],
                            fontSize: 20,
                            ),),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.05,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Total Wins: $total_wins',
                          style: TextStyle(
                            color: Colors.green[800],
                            fontSize: 20,
                            ),),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.05,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Top Level: $max_level',
                          style: TextStyle(
                            color: Colors.orange[800],
                            fontSize: 20,
                            ),),
                        ),
                      ],
                    ),

                    Container(
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        child: BarChart(
                          BarChartData(
                            barTouchData: BarTouchData(
                                          enabled: false,
                                          touchTooltipData: BarTouchTooltipData(
                                            tooltipBgColor: Colors.transparent,
                                            tooltipPadding: EdgeInsets.zero,
                                            tooltipMargin: 8,
                                            getTooltipItem: (
                                              BarChartGroupData group,
                                              int groupIndex,
                                              BarChartRodData rod,
                                              int rodIndex,
                                            ) {
                                              return BarTooltipItem(
                                                rod.toY.round().toString(),
                                                const TextStyle(
                                                  color: Colors.pink,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                            titlesData: FlTitlesData(
                                        show: true,
                                        bottomTitles: AxisTitles(
                                          axisNameWidget: Text('Level', style: TextStyle(color: Colors.pink[700], fontWeight: FontWeight.bold),),
                                          axisNameSize: 25,
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            reservedSize: 30,
                                            getTitlesWidget: getTitles,
                                          ),
                                        ),
                                        leftTitles: AxisTitles(
                                          axisNameSize: 25,
                                          axisNameWidget: Text('Score', style: TextStyle(color: Colors.pink[700], fontWeight: FontWeight.bold),),
                                          sideTitles: SideTitles(showTitles: false),
                                        ),
                                        topTitles: const AxisTitles(
                                          axisNameWidget: Text('  '),
                                          sideTitles: SideTitles(showTitles: false),
                                        ),
                                        rightTitles: const AxisTitles(
                                          axisNameWidget: Text('  '),
                                          sideTitles: SideTitles(showTitles: false),
                                        ),
                                      ),
                            borderData: FlBorderData(
                                          show: false,
                                        ),
                            barGroups: barsData,
                            gridData: FlGridData(show: true, checkToShowVerticalLine: dontShowAllGrids,),
                            alignment: BarChartAlignment.spaceAround,
                            maxY:  max_y*1.2,
                          ),
                        ),
                      ),
                    ],)
                ),

                Card(
                  color: Colors.white,
                  shadowColor: Colors.pink[700],
                  surfaceTintColor: Colors.white,
                  elevation: 10.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                    child:Column(children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.03,
                        child:Align(
                          alignment: Alignment.centerLeft,
                          child: Text(last == 1 ? "   Wow! you were FAST in last Game" : "   Stay Focused, you were Slow in last Game",
                            style: TextStyle(color: (last == 1 ? Colors.green[700] : Colors.pink),fontSize: 18)),                     
                        )
                      ),
                      Container(
                            width: MediaQuery.of(context).size.width * 0.05,
                            height: 180,
                            child: Align(
                              alignment: Alignment.center,
                              child:PieChart(PieChartData(
                                centerSpaceRadius: 10,
                                borderData: FlBorderData(show: false),
                                sections: [
                                  PieChartSectionData(value: fast, color: Colors.green, radius: 80),
                                  PieChartSectionData(value: slow, color: Colors.pink[200], radius: 60),
                                ])),
                            ),
                      ),

                      Row(
                        children: [
                          Container(
                            width: 12.0,
                            height: 12.0,
                          ),
                          Container(
                            width: 12.0,
                            height: 12.0,
                            color: Colors.green,
                          ),
                          SizedBox(width: 4.0),
                          Text("FAST",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),),
                          Container(
                            width: 12.0,
                            height: 12.0,
                          ),
                          Container(
                            width: 12.0,
                            height: 12.0,
                            color: Colors.pink[200],
                          ),
                          SizedBox(width: 4.0),
                          Text("SLOW",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),),
                        ],
                      ),
                    ],)
                ),

              ],
              );
          },
        )
      ),
    );
  }
  bool dontShowAllGrids(double value) {
    return false;
  }
}
