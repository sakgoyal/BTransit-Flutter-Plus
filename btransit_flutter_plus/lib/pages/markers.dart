import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:btransit_flutter_plus/widgets/drawer.dart';
import 'package:latlong2/latlong.dart';

class MarkerPage extends StatefulWidget {
  static const String route = '/markers';

  const MarkerPage({Key? key}) : super(key: key);

  @override
  MarkerPageState createState() {
    return MarkerPageState();
  }
}

class MarkerPageState extends State<MarkerPage> {
  final alignments = {
    315: Alignment.topLeft,
    0: Alignment.topCenter,
    45: Alignment.topRight,
    270: Alignment.centerLeft,
    null: Alignment.center,
    90: Alignment.centerRight,
    225: Alignment.bottomLeft,
    180: Alignment.bottomCenter,
    135: Alignment.bottomRight,
  };

  Alignment anchorAlign = Alignment.topCenter;
  bool counterRotate = false;
  late final customMarkers = <Marker>[
    buildPin(const LatLng(51.51868093513547, -0.12835376940892318)),
    buildPin(const LatLng(53.33360293799854, -6.284001062079881)),
  ];

  Marker buildPin(LatLng point) => Marker(
        point: point,
        builder: (ctx) =>
            const Icon(Icons.location_pin, size: 60, color: Colors.black),
        width: 60,
        height: 60,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Markers')),
      drawer: buildDrawer(context, MarkerPage.route),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox.square(
                  dimension: 130,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                    ),
                    itemCount: 9,
                    itemBuilder: (_, index) {
                      final deg = alignments.keys.elementAt(index);
                      final align = alignments.values.elementAt(index);

                      return IconButton.outlined(
                        onPressed: () => setState(() => anchorAlign = align),
                        icon: Transform.rotate(
                          angle: deg == null ? 0 : deg * pi / 180,
                          child: Icon(
                            deg == null ? Icons.circle : Icons.arrow_upward,
                            color: anchorAlign == align ? Colors.green : null,
                            size: deg == null ? 16 : null,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Tap the map to add markers!'),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text('Counter-rotation'),
                        const SizedBox(width: 10),
                        Switch.adaptive(
                          value: counterRotate,
                          onChanged: (v) => setState(() => counterRotate = v),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Flexible(
            child: FlutterMap(
              options: MapOptions(
                center: const LatLng(51.5, -0.09),
                zoom: 5,
                onTap: (_, p) => setState(() => customMarkers.add(buildPin(p))),
                interactiveFlags:
                    InteractiveFlag.all - InteractiveFlag.doubleTapZoom,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                ),
                MarkerLayer(
                  rotate: counterRotate,
                  anchorPos: AnchorPos.align(AnchorAlign.center),
                  markers: [
                    Marker(
                      point:
                          const LatLng(47.18664724067855, -1.5436768515939427),
                      width: 64,
                      height: 64,
                      anchorPos: AnchorPos.align(AnchorAlign.left),
                      builder: (context) => const ColoredBox(
                        color: Colors.lightBlue,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text('-->'),
                        ),
                      ),
                    ),
                    Marker(
                      point:
                          const LatLng(47.18664724067855, -1.5436768515939427),
                      width: 64,
                      height: 64,
                      anchorPos: AnchorPos.align(AnchorAlign.right),
                      builder: (context) => const ColoredBox(
                        color: Colors.pink,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('<--'),
                        ),
                      ),
                    ),
                    Marker(
                      point:
                          const LatLng(47.18664724067855, -1.5436768515939427),
                      rotate: false,
                      builder: (context) =>
                          const ColoredBox(color: Colors.black),
                    ),
                  ],
                ),
                MarkerLayer(
                  markers: customMarkers,
                  rotate: counterRotate,
                  anchorPos: AnchorPos.align(AnchorAlign.top),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
