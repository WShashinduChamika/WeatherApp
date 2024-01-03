import 'package:demo4/screens/map_screens/simple_map.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MapTypes extends StatefulWidget {
  const MapTypes({super.key});

  @override
  State<MapTypes> createState() => _MapTypesState();
}

class _MapTypesState extends State<MapTypes> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('map types'),
        centerTitle: true,
      ),
      body: Container(
        width: width,
        height: height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SimpleMap()),
                );
              },
              child: Text('Simple Map'),
            ),
          ],
        ),
      ),
    );
  }
}
