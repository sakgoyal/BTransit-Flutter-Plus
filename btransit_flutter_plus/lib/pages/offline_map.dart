import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:btransit_flutter_plus/widgets/drawer.dart';
import 'package:latlong2/latlong.dart';

class OfflineMapPage extends StatelessWidget {
  static const String route = '/offline_map';

  const OfflineMapPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Offline Map')),
      drawer: buildDrawer(context, route),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 8, bottom: 8),
              child: Text(
                  'This is an offline map that is showing Anholt Island, Denmark.'),
            ),
            Flexible(
              child: FlutterMap(
                options: MapOptions(
                  center: const LatLng(56.704173, 11.543808),
                  minZoom: 12,
                  maxZoom: 14,
                  maxBounds: LatLngBounds(
                    const LatLng(56.7378, 11.6644),
                    const LatLng(56.6877, 11.5089),
                  ),
                ),
                children: [
                  TileLayer(
                    tileProvider: AssetTileProvider(),
                    maxZoom: 14,
                    urlTemplate: 'assets/map/anholt_osmbright/{z}/{x}/{y}.png',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
