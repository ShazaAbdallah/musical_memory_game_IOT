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
  double max_y = 0;
  List<BarChartGroupData> barsData = [];
  LinearGradient get _barsGradient => LinearGradient(
        colors: [
          Colors.lightBlue[500]!,
          Colors.deepPurple[500]!,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
  );

  void  create_bars_list() {
    Map<String,double> data = {};
    barsData = [];
    total_games = 0;
    print(user_data);
    for (var i = 1; i <= 16; i++) {
      if(user_data['memory_game']['level_$i'] != null){
        total_games = total_games + user_data['memory_game']['level_$i'] as int;
        if(i == 16) total_wins = user_data['memory_game']['level_$i'] as int;
        if(i > max_level) max_level = i;
        if(user_data['memory_game']['level_$i'].toDouble() > max_y) max_y = user_data['memory_game']['level_$i'].toDouble();
        data['$i'] = user_data['memory_game']['level_$i'].toDouble();
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
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
      backgroundColor: Colors.lightBlue[100],
      iconTheme: IconThemeData(color: Colors.lightBlue[800],),
      ),
      body: SingleChildScrollView(
        child:  StreamBuilder(
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

              Text('Memory Game',
              style: TextStyle(color: Colors.lightBlue[800], fontWeight: FontWeight.bold, fontSize: size),
              ),

              Text('Statistics',
              style: TextStyle(color: Colors.yellow[700], fontWeight: FontWeight.bold, fontSize: size),
              ),

              Container(
                height: MediaQuery.of(context).size.height * 0.02,
              ),

              Card(
                color: Colors.white,
                shadowColor: Colors.lightBlue[700],
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
                            color: Colors.lightBlue[800],
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
                            color: Colors.yellow[800],
                            fontSize: 20,
                            ),),
                        ),
                      ],
                    ),
                    Container(
                    height: 200 + max_y*2,
                    width:  MediaQuery.of(context).size.width-20,
                    child: BarChart(
                      BarChartData(
                        barTouchData: BarTouchData(
                                      enabled: false,
                                      touchTooltipData: BarTouchTooltipData(
                                        tooltipBgColor: Colors.transparent,
                                        tooltipPadding: EdgeInsets.zero,
                                        tooltipMargin: 5,
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
                                      axisNameWidget: Text('Level', style: TextStyle(color: Colors.lightBlue[700], fontWeight: FontWeight.bold),),
                                      axisNameSize: 25,
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 30,
                                        getTitlesWidget: getTitles,
                                      ),
                                    ),
                                    leftTitles: AxisTitles(
                                      axisNameSize: 25,
                                      axisNameWidget: Text('Score', style: TextStyle(color: Colors.lightBlue[700], fontWeight: FontWeight.bold),),
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
                        gridData: FlGridData(
                              show: true,
                              checkToShowVerticalLine: dontShowAllGrids,
                          ),
                        alignment: BarChartAlignment.spaceAround,
                        maxY: max_y*1.2,
                      ),
                    ),
                  ),
                ],)
              ),
              
            ],
            );
          }
        )
      ),
    );
  }
  bool dontShowAllGrids(double value) {
    return false;
  }
}
