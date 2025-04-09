import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_google_maps_webservices/places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:get/get.dart';

class LocationController extends GetxController {
  final pickupController = TextEditingController();
  final dropController = TextEditingController();

  final GoogleMapsPlaces _places = GoogleMapsPlaces(
    // apiKey: 'AIzaSyCiJLymeCL0CTqTmcmPJ5T0lkLwA02OxWg',
    apiKey: 'AIzaSyDKGDpcjv7eWDHPQxx_4QUzDpS5vrcFp9w',
  );

  Timer? _debounce;
  var pickupSuggestions = <Prediction>[].obs;
  var dropSuggestions = <Prediction>[].obs;

  void onSearchChanged(String text, bool isPickup) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (text.isNotEmpty) {
        fetchSuggestions(text, isPickup);
      } else {
        if (isPickup) {
          pickupSuggestions.clear();
        } else {
          dropSuggestions.clear();
        }
      }
    });
  }

  Future<void> fetchSuggestions(String input, bool isPickup) async {
    final response = await _places.autocomplete(input);
    if (response.isOkay) {
      if (isPickup) {
        pickupSuggestions.value = response.predictions;
      } else {
        dropSuggestions.value = response.predictions;
      }
    } else {
      print('Suggestion Error: ${response.errorMessage}');
    }
  }

  Future<void> selectSuggestion(Prediction prediction, bool isPickup) async {
    FocusManager.instance.primaryFocus?.unfocus();

    final latLng = await getLatLngFromAddress(prediction.description!);

    if (isPickup) {
      pickupController.text = prediction.description!;
      pickupSuggestions.clear();
    } else {
      dropController.text = prediction.description!;
      dropSuggestions.clear();
    }

    print("Selected: ${prediction.description} => $latLng");
  }

  Future<LatLng> getLatLngFromAddress(String address) async {
    List<geocoding.Location> locations =
    await geocoding.locationFromAddress(address);
    return LatLng(locations.first.latitude, locations.first.longitude);
  }

  @override
  void onClose() {
    pickupController.dispose();
    dropController.dispose();
    _debounce?.cancel();
    super.onClose();
  }
}
