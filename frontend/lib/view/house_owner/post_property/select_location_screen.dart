import 'package:final_project/model/location.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// ======================================================
// APP COLORS
// ======================================================

const Color primaryColor = Color(0xFF03045E);
const Color secondaryColor = Color(0xFF90E0EF);
const Color backgroundColor = Color(0xFFF4FCFE);
const Color lightSecondaryColor = Color(0xFFE6F9FC);

class SelectLocationScreen extends StatefulWidget {
  const SelectLocationScreen({super.key});

  @override
  State<SelectLocationScreen> createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  LatLng? selectedPosition;

  String selectedAddress = "Tap somewhere on the map";

  bool isLoadingAddress = false;

  static const LatLng initialPosition = LatLng(11.5564, 104.9282);

  final Geocoding geocoding = Geocoding();

  // ======================================================
  // SELECT LOCATION
  // ======================================================

  Future<void> selectLocation(LatLng position) async {
    setState(() {
      selectedPosition = position;
      selectedAddress = "Getting address...";
      isLoadingAddress = true;
    });

    try {
      final List<Placemark> placemarks = await geocoding
          .placemarkFromCoordinates(position.latitude, position.longitude)
          .timeout(const Duration(seconds: 8));

      if (!mounted) return;

      if (placemarks.isNotEmpty) {
        final Placemark place = placemarks.first;

        final List<String?> addressParts = [
          place.street,
          place.subLocality,
          place.locality,
          place.administrativeArea,
          place.country,
        ];

        final String address = addressParts
            .where((part) => part != null && part.trim().isNotEmpty)
            .join(", ");

        setState(() {
          selectedAddress = address.isNotEmpty ? address : "Selected location";
        });
      }
    } catch (e) {
      if (!mounted) return;

      print("GEOCODING ERROR: $e");

      setState(() {
        selectedAddress =
            "Lat: ${position.latitude.toStringAsFixed(6)}, "
            "Lng: ${position.longitude.toStringAsFixed(6)}";
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoadingAddress = false;
        });
      }
    }
  }

  // ======================================================
  // CLOSE SCREEN
  // ======================================================

  void closeScreen([PropertyLocation? location]) {
    if (!mounted) return;

    Get.back(result: location);
  }

  // ======================================================
  // CONFIRM LOCATION
  // ======================================================

  void confirmLocation() {
    if (selectedPosition == null) return;

    final PropertyLocation location = PropertyLocation(
      address: selectedAddress,
      latitude: selectedPosition!.latitude,
      longitude: selectedPosition!.longitude,
    );

    closeScreen(location);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      // ======================================================
      // APP BAR
      // ======================================================
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,

        leading: IconButton(
          onPressed: () {
            closeScreen();
          },

          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: primaryColor,
          ),
        ),

        title: const Text(
          "Select Location",
          style: TextStyle(
            color: primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),

        centerTitle: true,
      ),

      body: Stack(
        children: [
          // ======================================================
          // GOOGLE MAP
          // ======================================================
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: initialPosition,
              zoom: 14,
            ),

            onTap: selectLocation,

            zoomControlsEnabled: false,

            myLocationButtonEnabled: false,

            markers: selectedPosition == null
                ? <Marker>{}
                : {
                    Marker(
                      markerId: const MarkerId("property"),

                      position: selectedPosition!,

                      icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueRed,
                      ),
                    ),
                  },
          ),

          // ======================================================
          // SELECTED LOCATION CARD
          // ======================================================
          Positioned(
            left: 16,
            right: 16,
            bottom: 20,

            child: Container(
              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.circular(15),

                border: Border.all(color: secondaryColor.withOpacity(0.45)),

                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.10),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),

              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  // ==================================================
                  // TITLE
                  // ==================================================
                  const Text(
                    "Selected Location",
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ==================================================
                  // ADDRESS
                  // ==================================================
                  Row(
                    children: [
                      // Icon background
                      Container(
                        width: 40,
                        height: 40,

                        decoration: BoxDecoration(
                          color: lightSecondaryColor,

                          borderRadius: BorderRadius.circular(10),
                        ),

                        child: const Icon(
                          Icons.location_on_outlined,
                          color: primaryColor,
                          size: 23,
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: Text(
                          selectedAddress,

                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                            height: 1.4,
                          ),
                        ),
                      ),

                      // ==================================================
                      // LOADING
                      // ==================================================
                      if (isLoadingAddress)
                        const Padding(
                          padding: EdgeInsets.only(left: 8),

                          child: SizedBox(
                            width: 18,
                            height: 18,

                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: primaryColor,
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  // ==================================================
                  // CONFIRM BUTTON
                  // ==================================================
                  SizedBox(
                    width: double.infinity,
                    height: 48,

                    child: ElevatedButton(
                      onPressed: selectedPosition == null || isLoadingAddress
                          ? null
                          : () {
                              debugPrint('CONFIRM BUTTON CLICKED');
                              confirmLocation();
                            },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,

                        foregroundColor: Colors.white,

                        disabledBackgroundColor: secondaryColor.withOpacity(
                          0.55,
                        ),

                        disabledForegroundColor: primaryColor.withOpacity(0.45),

                        elevation: 0,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),

                      child: const Text(
                        "Confirm Location",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
