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
  // 构建温度图数据
  LineChartData buildTempData(List<FlSpot> tempMaxList,
      List<FlSpot> tempMinList, List<Daily> dailyForecasts) {
    double maxY = tempMaxList.map((e) => e.y).reduce((a, b) => a > b ? a : b);
    double minY = tempMinList.map((e) => e.y).reduce((a, b) => a < b ? a : b);

    // 计算interval
    double interval = (maxY - minY) / 4;

    // 将minY和maxY调整为interval的整数倍
    minY = (minY / interval).floor() * interval;
    maxY = (maxY / interval).ceil() * interval;

    return LineChartData(
      minX: 0,
      maxX: 6,
      minY: minY,
      maxY: maxY,
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
          axisNameWidget: Text(
            '温度(℃)',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          axisNameSize: 30,
          sideTitles: SideTitles(
              showTitles: true, interval: interval, reservedSize: 50),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        bottomTitles: AxisTitles(
          axisNameWidget: Text(
            '日期',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          axisNameSize: 30,
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

  // 构建湿度图数据
  LineChartData buildHumidityData(
      List<FlSpot> humiditySpots, List<Daily> dailyForecasts) {
    double maxY = humiditySpots.map((e) => e.y).reduce((a, b) => a > b ? a : b);
    double minY = 0; // 湿度最低为0

    // 计算interval
    double interval = (maxY - minY) / 4;

    // 将minY和maxY调整为interval的整数倍
    minY = (minY / interval).floor() * interval;
    maxY = (maxY / interval).ceil() * interval;

    return LineChartData(
      minX: 0,
      maxX: 6,
      minY: minY,
      maxY: maxY,
      lineBarsData: [
        LineChartBarData(
          spots: humiditySpots,
          isCurved: true,
          barWidth: 3,
          color: Colors.green,
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
          axisNameWidget: Text(
            '湿度(%)',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          axisNameSize: 30,
          sideTitles: SideTitles(
              showTitles: true, interval: interval, reservedSize: 50),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        bottomTitles: AxisTitles(
          axisNameWidget: Text(
            '日期',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          axisNameSize: 30,
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
          child: Column(
            children: [
              Card(
                child: SizedBox(
                  // 使用 SizedBox 限制 LineChart 的大小
                  height: 200, // 设置图表的高度
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: LineChart(
                      buildTempData(tempMaxSpot, tempMinSpot, dailyForecasts),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20), // 添加图表之间的间距
              Card(
                child: SizedBox(
                  // 使用 SizedBox 限制 LineChart 的大小
                  height: 200, // 设置图表的高度
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: LineChart(
                      buildHumidityData(humiditySpots, dailyForecasts),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
