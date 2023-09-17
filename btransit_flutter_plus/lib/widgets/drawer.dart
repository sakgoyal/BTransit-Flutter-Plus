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

Widget _buildMenuItem(
  BuildContext context,
  Widget title,
  String routeName,
  String currentRoute, {
  Widget? icon,
}) {
  final isSelected = routeName == currentRoute;

  return ListTile(
    title: title,
    leading: icon,
    selected: isSelected,
    onTap: () {
      if (isSelected) {
        Navigator.pop(context);
      } else {
        Navigator.pushReplacementNamed(context, routeName);
      }
    },
  );
}

Drawer buildDrawer(BuildContext context, String currentRoute) {
  return Drawer(
    child: ListView(
      children: <Widget>[
        DrawerHeader(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/ProjectIcon.png',
                height: 48,
              ),
              const SizedBox(height: 16),
              const Text(
                'flutter_map Demo',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text(
                '© flutter_map Authors & Contributors',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
        _buildMenuItem(
          context,
          const Text('Home'),
          HomePage.route,
          currentRoute,
          icon: const Icon(Icons.home),
        ),
        const Divider(),
        _buildMenuItem(
          context,
          const Text('Marker Layer'),
          MarkerPage.route,
          currentRoute,
        ),
        _buildMenuItem(
          context,
          const Text('Polygon Layer'),
          PolygonPage.route,
          currentRoute,
        ),
        _buildMenuItem(
          context,
          const Text('Circle Layer'),
          CirclePage.route,
          currentRoute,
        ),
        const Divider(),
        _buildMenuItem(
          context,
          const Text('Map Controller'),
          MapControllerPage.route,
          currentRoute,
        ),
        _buildMenuItem(
          context,
          const Text('Animated Map Controller'),
          AnimatedMapControllerPage.route,
          currentRoute,
        ),
        _buildMenuItem(
          context,
          const Text('Interactive Flags'),
          InteractiveTestPage.route,
          currentRoute,
        ),
        const Divider(),
        _buildMenuItem(
          context,
          const Text('Asset Sourced Map (Offline Map)'),
          OfflineMapPage.route,
          currentRoute,
        ),
        const Divider(),
        _buildMenuItem(
          context,
          const Text('Stateful Markers'),
          StatefulMarkersPage.route,
          currentRoute,
        ),
        _buildMenuItem(
          context,
          const Text('Many Markers'),
          ManyMarkersPage.route,
          currentRoute,
        ),
        _buildMenuItem(
          context,
          const Text('Moving Marker'),
          MovingMarkersPage.route,
          currentRoute,
        ),
        const Divider(),
        _buildMenuItem(
          context,
          const Text('ScaleBar Plugins'),
          PluginScaleBar.route,
          currentRoute,
        ),
        _buildMenuItem(
          context,
          const Text('ZoomButtons Plugins'),
          PluginZoomButtons.route,
          currentRoute,
        ),
        const Divider(),
        _buildMenuItem(
          context,
          const Text('Map Inside Scrollable'),
          MapInsideListViewPage.route,
          currentRoute,
        ),
        _buildMenuItem(
          context,
          const Text('Secondary Tap (right click)'),
          SecondaryTapPage.route,
          currentRoute,
        ),
        const Divider(),
        _buildMenuItem(
          context,
          const Text('Custom Tile Error Handling'),
          TileLoadingErrorHandle.route,
          currentRoute,
        ),
        _buildMenuItem(
          context,
          const Text('Custom Tile Builder'),
          TileBuilderPage.route,
          currentRoute,
        ),
        const Divider(),
        _buildMenuItem(
          context,
          const Text('Screen Point -> LatLng'),
          PointToLatLngPage.route,
          currentRoute,
        ),
        _buildMenuItem(
          context,
          const Text('LatLng -> Screen Point'),
          LatLngScreenPointTestPage.route,
          currentRoute,
        ),
      ],
    ),
  );
}
