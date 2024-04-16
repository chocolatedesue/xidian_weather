import 'package:flutter/material.dart';
import 'package:xidian_weather/model/geoInfo.dart';

class SavePage extends StatefulWidget {
  @override
  _SavePageState createState() => _SavePageState();
}

class _SavePageState extends State<SavePage> {
  List<GeoInfo> savedCities = [
    // GeoInfo(code: code, location: location)
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          // 其他 Widget (例如标题或搜索栏)
          Expanded(
            child: ListView.builder(
              itemCount: savedCities.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(savedCities[index].location[0].name ?? '未知',
                        style: TextStyle(fontSize: 20, color: Colors.red)),
                    subtitle: Text(
                        "ID: ${savedCities[index].location[0].id}\nlat: ${savedCities[index].location[0].lat ?? '未知'} lon: ${savedCities[index].location[0].lon ?? '未知'}",
                        style: TextStyle(fontSize: 15, color: Colors.blue)),
                  ),
                );
              },
            ),
          ),
          // 其他 Widget (例如按钮或底部导航栏)
        ],
      ),
    );
  }
}
