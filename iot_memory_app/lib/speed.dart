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
    Map<String,double> data = {};
    barsData = [];
    int games = 0;
    int wins = 0;
    int level = 0;
    final authRepository = Provider.of<AuthRepository>(context,  listen : false);
    user_data = authRepository.speed_data;
    for (var i = 1; i <= 16; i++) {
      if(user_data['level_$i'] != 0){
        games = games + user_data['level_$i'] as int;
        if(i == 16) wins = user_data['level_$i'] as int;
        if(i > level) level = i;
        data['$i'] = user_data['level_$i'].toDouble();
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
    double f = authRepository.fast.toDouble();
    double s = authRepository.slow.toDouble();
    print(' in page :::: fast = $f and slow = $s');
    setState(() {
      total_games = games;
      total_wins = wins;
      max_level = level;
      fast = authRepository.fast.toDouble();
      slow = authRepository.slow.toDouble();
    });
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
    final authRepository = Provider.of<AuthRepository>(context,  listen : false);
    authRepository.getData();
    String user_name = authRepository.userName;
    setState(() {
      user_data = authRepository.speed_data;
    });
    create_bars_list();
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
      backgroundColor: Colors.pink[100],
      iconTheme: IconThemeData(color: Colors.pink[700],),
      ),
      body: SingleChildScrollView(
          child: Column(
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
                  child: Text('Total Wins: $total_wins',
                  style: TextStyle(
                    color: Colors.green[800],
                    fontSize: 20,
                    ),),
                ),
              ],
            ),

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
                  child: Text('Top Level: $max_level',
                  style: TextStyle(
                    color: Colors.orange[800],
                    fontSize: 20,
                    ),),
                ),
              ],
            ),

            Container(
                  width: MediaQuery.of(context).size.width * 0.05,
                  height: 200,
                  child: Align(
                    alignment: Alignment.center,
                    child:PieChart(PieChartData(
                      centerSpaceRadius: 10,
                      borderData: FlBorderData(show: false),
                      sections: [
                        PieChartSectionData(value: fast, color: Colors.green, radius: 90),
                        PieChartSectionData(value: slow, color: Colors.pink[200], radius: 70),
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
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 30,
                                  getTitlesWidget: getTitles,
                                ),
                              ),
                              leftTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                  borderData: FlBorderData(
                                show: false,
                              ),
                  barGroups: barsData,
                  gridData: const FlGridData(show: false),
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 20,
                ),
              ),
            ),

            Container(
              height: MediaQuery.of(context).size.height * 0.02,
            ),

            
           ],
          ),
      ),
    );
  }
}
