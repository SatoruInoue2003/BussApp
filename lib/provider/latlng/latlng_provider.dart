import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../model/stop_low/stop_low.dart';
import '../location_provider.dart';

part 'latlng_provider.g.dart';

/// Global変数
GoogleMapController? mapController;

@riverpod
class LatLngNotifier extends _$LatLngNotifier {
  @override
  FutureOr<Position?> build() async {
    final position = await ref.refresh(locationProvider.future);
    state = AsyncValue.data(position);
    return position;
  }

  Future<void> searchPosition(StopLow stopLow) async {
    state = const AsyncValue.loading();

    await AsyncValue.guard(
      () async {
        /// マーカーの位置に移動
        await mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(
                stopLow.stopLat,
                stopLow.stopLon,
              ),
              zoom: 16,
            ),
          ),
        );

        state = AsyncValue.data(
          Position(
            longitude: stopLow.stopLon,
            latitude: stopLow.stopLat,
            timestamp: DateTime.now(),
            accuracy: 0,
            altitude: 0,
            heading: 0,
            speed: 0,
            speedAccuracy: 0,
          ),
        );
      },
    );
  }
}