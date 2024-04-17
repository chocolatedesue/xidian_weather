// forecast_page.dart

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xidian_weather/model/my7DayWeather.dart';
import 'package:xidian_weather/provider/weather_provider.dart';

class ForecastPage extends StatefulWidget {
  @override
  _ForecastPageState createState() => _ForecastPageState();
}

class _ForecastPageState extends State<ForecastPage> {
  LineChartData buildTempData(
      List<FlSpot> tempMaxList,List <FlSpot> tempMinList  ,List<Daily> dailyForecasts) {
    return LineChartData(
      minX: 0,
      maxX: 6,
      minY: tempMinList.map((e) => e.y).reduce((a, b) => a < b ? a : b) - 5,
      maxY: tempMaxList.map((e) => e.y).reduce((a, b) => a > b ? a : b) + 5,

      lineBarsData: [
        LineChartBarData(
          
          spots: tempMaxList,
          isCurved: true,
          barWidth: 3,
          color: Colors.red,
          isStrokeCapRound: true,
          belowBarData: BarAreaData(
            show: true,
          ),
        ),

        LineChartBarData(
          spots: tempMinList,
          isCurved: true,
          barWidth: 3,
          color: Color.fromRGBO(0, 0, 255, 1),
          isStrokeCapRound: true,
          belowBarData: BarAreaData(
            show: true,
          ),
        ),
      ],
      titlesData: FlTitlesData(
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        leftTitles: AxisTitles(
          axisNameWidget: Text('温度(℃)'),
          
          sideTitles: SideTitles(

              showTitles: true,
              interval: (tempMaxList
                          .map((e) => e.y)
                          .reduce((a, b) => a > b ? a : b) -
                      tempMaxList.map((e) => e.y).reduce((a, b) => a < b ? a : b)) /
                  4,
              reservedSize: 50),
        ),
        topTitles: AxisTitles(
          // axisNameWidget: Text('温度折线图'),
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        bottomTitles: AxisTitles(
          axisNameWidget: Text('日期'),
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: (value, _) {
              final date = dailyForecasts[value.toInt()].fxDate;
              return Text('${date.day}');
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    final dailyForecasts = weatherProvider.the7dayWeather?.daily;

    if (dailyForecasts == null || dailyForecasts.isEmpty) {
      // 数据为空，显示空页面
      return Scaffold(
        appBar: AppBar(
          title: Text('7 天预报'),
        ),
        body: Center(
          child: Text('暂无预报数据'),
        ),
      );
    } else {
      // 数据存在，显示图表
      // 提取温度和湿度数据
      final List<FlSpot> tempMaxSpot =
          dailyForecasts.asMap().entries.map((entry) {
        final index = entry.key;
        final forecast = entry.value;
        return FlSpot(index.toDouble(), double.parse(forecast.tempMax));
      }).toList();

      final List<FlSpot> tempMinSpot =
          dailyForecasts.asMap().entries.map((entry) {
        final index = entry.key;
        final forecast = entry.value;
        return FlSpot(index.toDouble(), double.parse(forecast.tempMin));
      }).toList();

      final List<FlSpot> humiditySpots =
          dailyForecasts.asMap().entries.map((entry) {
        final index = entry.key;
        final forecast = entry.value;
        return FlSpot(index.toDouble(), double.parse(forecast.humidity));
      }).toList();

      return Scaffold(
        appBar: AppBar(
          title: Text('7 天预报'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: LineChart(
            buildTempData(tempMaxSpot, tempMinSpot ,dailyForecasts),
            // buildTempData(tempMinSpot, dailyForecasts)
          ),
        ),
      );
    }
  }
}
