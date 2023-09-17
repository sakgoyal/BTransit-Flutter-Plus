import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:btransit_flutter_plus/widgets/drawer.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:xml2json/xml2json.dart';

class HomePage extends StatefulWidget {
  static const String route = '/';
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Marker> _allMarkers = [];
  // ignore: prefer_final_fields
  var _positions = [
    [
      37.22 + (Random().nextDouble() * 0.04),
      -80.45 + (Random().nextDouble() * 0.04)
    ],
    [
      37.22 + (Random().nextDouble() * 0.04),
      -80.45 + (Random().nextDouble() * 0.04)
    ],
    [
      37.22 + (Random().nextDouble() * 0.04),
      -80.45 + (Random().nextDouble() * 0.04)
    ],
  ];

  @override
  void initState() {
    const oneSec = Duration(seconds: 3);
    Timer.periodic(oneSec, (Timer t) => fetchData());
    super.initState();

    const seenIntroBoxKey = 'seenIntroBox(a)';
    if (kIsWeb) {
      SchedulerBinding.instance.addPostFrameCallback(
        (_) async {
          final prefs = await SharedPreferences.getInstance();
          if (prefs.getBool(seenIntroBoxKey) ?? false) return;

          if (!mounted) return;

          final width = MediaQuery.of(context).size.width;
          await showDialog<void>(
            context: context,
            builder: (context) => AlertDialog(
              icon: UnconstrainedBox(
                child: SizedBox.square(
                  dimension: 64,
                  child:
                      Image.asset('assets/ProjectIcon.png', fit: BoxFit.fill),
                ),
              ),
              title: const Text('flutter_map Live Web Demo'),
              content: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: width < 750
                      ? double.infinity
                      : (width / (width < 1100 ? 1.5 : 2.5)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "This is built automatically off of the latest commits to 'master', so may not reflect the latest release available on pub.dev.\nThis is hosted on Firebase Hosting, meaning there's limited bandwidth to share between all users, so please keep loads to a minimum.",
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(right: 8, top: 16, bottom: 4),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "This won't be shown again",
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .inverseSurface
                                .withOpacity(0.5),
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  label: const Text('OK'),
                  icon: const Icon(Icons.done),
                ),
              ],
              contentPadding: const EdgeInsets.only(
                left: 24,
                top: 16,
                bottom: 0,
                right: 24,
              ),
            ),
          );
          await prefs.setBool(seenIntroBoxKey, true);
        },
      );
    }
  }

  // Timer mytimer = Timer.periodic(Duration(seconds: 1), (timer) {
  //       DateTime timenow = DateTime.now();  //get current date and time
  //       time = timenow.hour.toString() + ":" + timenow.minute.toString() + ":" + timenow.second.toString();
  //       setState(() {

  //       });
  //       //mytimer.cancel() //to terminate this timer
  //    });

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(
        'http://www.bt4uclassic.org/webservices/bt4u_webservice.asmx/GetCurrentBusInfo'));

    if (response.statusCode == 200) {
      // Map<String, dynamic> jsonData = convertXMLtoJSON(response.body);
      try {
        _allMarkers.clear();
        throw Exception('Failed to load data');
        // for (var bus in jsonData['DocumentElement']['LatestInfoTable']) {
        //   _allMarkers.add(
        //     Marker(
        //       point: LatLng(
        //         bus['Latitude'],
        //         bus['Longitude'],
        //       ),
        //       builder: (context) => Image.asset('assets/bus.png'),
        //     ),
        //   );
        // }
      } catch (e) {
        var rng = Random();
        _positions[0][0] += (rng.nextDouble() * 0.0005) - 0.00025;
        _positions[0][1] += (rng.nextDouble() * 0.0005) - 0.00025;
        _positions[1][0] += (rng.nextDouble() * 0.0005) - 0.00025;
        _positions[1][1] += (rng.nextDouble() * 0.0005) - 0.00025;
        _positions[2][0] += (rng.nextDouble() * 0.0005) - 0.00025;
        _positions[2][1] += (rng.nextDouble() * 0.0005) - 0.00025;

        _allMarkers.add(
          Marker(
            point: LatLng(
              _positions[0][0],
              _positions[0][1],
            ),
            builder: (context) => Image.asset('assets/bus.png'),
          ),
        );

        _allMarkers.add(
          Marker(
            point: LatLng(
              _positions[1][0],
              _positions[1][1],
            ),
            builder: (context) => Image.asset('assets/bus.png'),
          ),
        );

        _allMarkers.add(
          Marker(
            point: LatLng(
              _positions[2][0],
              _positions[2][1],
            ),
            builder: (context) => Image.asset('assets/bus.png'),
          ),
        );

        setState(() {
          _allMarkers = _allMarkers;
        });
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  Map<String, dynamic> convertXMLtoJSON(String xmlString) {
    final xml2json = Xml2Json();
    xml2json.parse(xmlString);
    return json.decode(xml2json.toOpenRally());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BT Transit Plus', style: TextStyle(fontSize: 40)),
        centerTitle: true,
      ),
      drawer: buildDrawer(context, HomePage.route),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Flexible(
              child: FlutterMap(
                options: MapOptions(
                  center: const LatLng(37.2297094, -80.4216599),
                  zoom: 13,
                  maxBounds: LatLngBounds(
                    const LatLng(-90, -180),
                    const LatLng(90, 180),
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://osm.ridebt.org/hot/{z}/{x}/{y}.png', // ----- this doesnt work because of fucking CORS
                    fallbackUrl:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    // userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                  ),
                  MarkerLayer(
                    markers: _allMarkers,
                  ),
                  // PolygonLayer(polygons: [
                  //   Polygon(
                  //     points: notFilledPoints,
                  //     isFilled: false, // By default it's false
                  //     borderColor: Colors.red,
                  //     borderStrokeWidth: 4,
                  //   ),
                  //   Polygon(
                  //     points: notFilledDotedPoints,
                  //     isFilled: false,
                  //     isDotted: true,
                  //     borderColor: Colors.green,
                  //     borderStrokeWidth: 4,
                  //     color: Colors.yellow,
                  //   ),
                  // ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
