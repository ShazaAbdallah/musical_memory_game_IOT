import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'userInfo.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_charts/flutter_charts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';

class memoryGame extends StatefulWidget {
  @override
  _memoryGameState createState() => _memoryGameState();
}

class _memoryGameState extends State<memoryGame> {

  late StreamSubscription<DatabaseEvent> _subscription;
  Map<dynamic,dynamic> user_data = {};
  int total_games = 0;
  int total_wins = 0;
  int max_level = 0;
  List<BarChartGroupData> barsData = [];
  LinearGradient get _barsGradient => LinearGradient(
        colors: [
          Colors.yellow[500]!,
          Colors.lightBlue[500]!,
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
    user_data = authRepository.memory_data;
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
    setState(() {
      total_games = games;
      total_wins = wins;
      max_level = level;
    });
  }

  Widget getTitles(double value, TitleMeta meta) {
    final style = TextStyle(
      color: Colors.lightBlue[400],
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
      user_data = authRepository.memory_data;
    });
    create_bars_list();
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
      backgroundColor: Colors.lightBlue[100],
      iconTheme: IconThemeData(color: Colors.lightBlue[800],),
      ),
      body: Center(
          child: Column(
          children:  <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.03,
            ),

            Text('Memory Game',
            style: TextStyle(color: Colors.lightBlue[800], fontWeight: FontWeight.bold, fontSize: size),
            ),

            Text('Statistics',
            style: TextStyle(color: Colors.yellow[700], fontWeight: FontWeight.bold, fontSize: size),
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
                    color: Colors.lightBlue[800],
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
                    color: Colors.yellow[800],
                    fontSize: 20,
                    ),),
                ),
              ],
            ),

            Container(
              height: 300,
              width:  MediaQuery.of(context).size.width,
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
                                        color: Colors.lightBlue,
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
           ],
          ),
      ),
    );
  }
}
