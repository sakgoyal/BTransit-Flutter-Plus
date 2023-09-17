import 'package:flutter/material.dart';
import 'package:btransit_flutter_plus/pages/animated_map_controller.dart';
import 'package:btransit_flutter_plus/pages/circle.dart';
import 'package:btransit_flutter_plus/pages/home.dart';
import 'package:btransit_flutter_plus/pages/interactive_test_page.dart';
import 'package:btransit_flutter_plus/pages/latlng_to_screen_point.dart';
import 'package:btransit_flutter_plus/pages/many_markers.dart';
import 'package:btransit_flutter_plus/pages/map_controller.dart';
import 'package:btransit_flutter_plus/pages/map_inside_listview.dart';
import 'package:btransit_flutter_plus/pages/markers.dart';
import 'package:btransit_flutter_plus/pages/moving_markers.dart';
import 'package:btransit_flutter_plus/pages/offline_map.dart';
import 'package:btransit_flutter_plus/pages/plugin_scalebar.dart';
import 'package:btransit_flutter_plus/pages/plugin_zoombuttons.dart';
import 'package:btransit_flutter_plus/pages/point_to_latlng.dart';
import 'package:btransit_flutter_plus/pages/polygon.dart';
import 'package:btransit_flutter_plus/pages/secondary_tap.dart';
import 'package:btransit_flutter_plus/pages/stateful_markers.dart';
import 'package:btransit_flutter_plus/pages/tile_builder_example.dart';
import 'package:btransit_flutter_plus/pages/tile_loading_error_handle.dart';
import 'package:url_strategy/url_strategy.dart';

void main() {
  setPathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter_map Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF8dea88),
      ),
      home: const HomePage(),
      routes: <String, WidgetBuilder>{
        MapControllerPage.route: (context) => const MapControllerPage(),
        AnimatedMapControllerPage.route: (context) =>
            const AnimatedMapControllerPage(),
        MarkerPage.route: (context) => const MarkerPage(),
        PluginScaleBar.route: (context) => const PluginScaleBar(),
        PluginZoomButtons.route: (context) => const PluginZoomButtons(),
        OfflineMapPage.route: (context) => const OfflineMapPage(),
        MovingMarkersPage.route: (context) => const MovingMarkersPage(),
        CirclePage.route: (context) => const CirclePage(),
        PolygonPage.route: (context) => const PolygonPage(),
        TileLoadingErrorHandle.route: (context) =>
            const TileLoadingErrorHandle(),
        TileBuilderPage.route: (context) => const TileBuilderPage(),
        InteractiveTestPage.route: (context) => const InteractiveTestPage(),
        ManyMarkersPage.route: (context) => const ManyMarkersPage(),
        StatefulMarkersPage.route: (context) => const StatefulMarkersPage(),
        MapInsideListViewPage.route: (context) => const MapInsideListViewPage(),
        PointToLatLngPage.route: (context) => const PointToLatLngPage(),
        LatLngScreenPointTestPage.route: (context) =>
            const LatLngScreenPointTestPage(),
        SecondaryTapPage.route: (context) => const SecondaryTapPage(),
      },
    );
  }
}
