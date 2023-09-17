import 'package:csv/csv.dart';
import 'package:flutter/services.dart'; // Import this for rootBundle
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:btransit_flutter_plus/widgets/drawer.dart';
import 'package:latlong2/latlong.dart';

class PolygonPage extends StatelessWidget {
  static const String route = 'polygon';

  const PolygonPage({Key? key}) : super(key: key);

  void printCSV() async {
    final content =
        await rootBundle.loadString('assets/google_transit/stops.txt');
    final fields = const CsvToListConverter().convert(content);
    print(fields);
  }

  @override
  Widget build(BuildContext context) {
    final notFilledPoints = <LatLng>[
      const LatLng(51.5, -0.09),
      const LatLng(53.3498, -6.2603),
      const LatLng(48.8566, 2.3522),
    ];

    final notFilledDotedPoints = <LatLng>[
      const LatLng(49.29, -2.57),
      const LatLng(51.46, -6.43),
      const LatLng(49.86, -8.17),
      const LatLng(48.39, -3.49),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Polygons')),
      drawer: buildDrawer(context, PolygonPage.route),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 8, bottom: 8),
              child: Text('Polygons'),
            ),
            Flexible(
              child: FlutterMap(
                options: MapOptions(
                  center: const LatLng(51.5, -0.09),
                  zoom: 5,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                  ),
                  PolygonLayer(polygons: [
                    Polygon(
                      points: notFilledPoints,
                      isFilled: false, // By default it's false
                      borderColor: Colors.red,
                      borderStrokeWidth: 4,
                    ),
                    Polygon(
                      points: notFilledDotedPoints,
                      isFilled: false,
                      isDotted: true,
                      borderColor: Colors.green,
                      borderStrokeWidth: 4,
                      color: Colors.yellow,
                    ),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
