import 'dart:convert';
import 'dart:math' as math;

import 'package:final_project/model/apartmentFlat.dart';
import 'package:final_project/model/house.dart';
import 'package:final_project/model/property.dart';
import 'package:final_project/model/room.dart';
import 'package:final_project/service/property_service.dart';
import 'package:final_project/view/renter/property_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

const Color primaryColor = Color(0xFF03045E);
const Color secondaryColor = Color(0xFF90E0EF);
const Color backgroundColor = Color(0xFFF8FAFC);
const Color lightSecondaryColor = Color(0xFFE6F9FC);

class MapScreen extends StatefulWidget {
  final Property? initialProperty;

  const MapScreen({super.key, this.initialProperty});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final PropertyService propertyService = PropertyService();
  LatLng? selectedReferenceLocation;

  String? selectedReferenceName;

  bool isChoosingReferenceLocation = false;

  final TextEditingController searchController = TextEditingController();

  GoogleMapController? mapController;

  static const LatLng initialPosition = LatLng(11.5564, 104.9282);

  List<Property> properties = [];

  bool isLoading = true;

  String? errorMessage;

  String searchText = "";

  String selectedType = "All";

  int? selectedPropertyId;

  final Geocoding geocoding = Geocoding();

  double? getDistanceToProperty(Property property) {
    if (selectedReferenceLocation == null) {
      return null;
    }

    final double? propertyLat = property.location.latitude;

    final double? propertyLng = property.location.longitude;

    if (propertyLat == null || propertyLng == null) {
      return null;
    }

    const double earthRadiusKm = 6371;

    final double lat1 = selectedReferenceLocation!.latitude * math.pi / 180;

    final double lon1 = selectedReferenceLocation!.longitude * math.pi / 180;

    final double lat2 = propertyLat * math.pi / 180;

    final double lon2 = propertyLng * math.pi / 180;

    final double deltaLat = lat2 - lat1;
    final double deltaLon = lon2 - lon1;

    final double a =
        math.sin(deltaLat / 2) * math.sin(deltaLat / 2) +
        math.cos(lat1) *
            math.cos(lat2) *
            math.sin(deltaLon / 2) *
            math.sin(deltaLon / 2);

    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadiusKm * c;
  }

  Future<void> selectReferenceLocation(LatLng position) async {
    setState(() {
      selectedReferenceLocation = position;
      selectedReferenceName = "Loading location...";
      isChoosingReferenceLocation = false;
    });

    try {
      final List<Placemark> placemarks = await geocoding
          .placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        final Placemark place = placemarks.first;

        final List<String> parts =
            [place.name, place.street, place.subLocality, place.locality]
                .where((item) => item != null && item!.trim().isNotEmpty)
                .map((item) => item!.trim())
                .toList();

        if (!mounted) {
          return;
        }

        setState(() {
          selectedReferenceName = parts.isNotEmpty
              ? parts.join(", ")
              : "Selected location";
        });
      }
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        selectedReferenceName = "Selected location";
      });

      print("REFERENCE LOCATION ERROR: $e");
    }
  }

  @override
  void initState() {
    super.initState();

    selectedPropertyId = widget.initialProperty?.id;

    loadProperties();
  }

  @override
  void dispose() {
    searchController.dispose();

    mapController?.dispose();

    super.dispose();
  }

  // Load real properties
  Future<void> loadProperties() async {
    if (mounted) {
      setState(() {
        isLoading = true;

        errorMessage = null;
      });
    }

    try {
      final response = await propertyService.getRenterProperties();

      final dynamic decoded = jsonDecode(response.body);

      if (response.statusCode == 200 && decoded["success"] == true) {
        final List<dynamic> data = decoded["properties"] ?? [];

        final List<Property> loadedProperties = data.map((item) {
          return Property.fromJson(Map<String, dynamic>.from(item));
        }).toList();

        if (!mounted) {
          return;
        }

        setState(() {
          properties = loadedProperties;

          isLoading = false;
        });

        await moveToInitialProperty();
      } else {
        if (!mounted) {
          return;
        }

        setState(() {
          errorMessage = decoded["message"] ?? "Failed to load properties";

          isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        errorMessage = "Unable to load properties";

        isLoading = false;
      });

      print("MAP PROPERTY LOAD ERROR: $e");
    }
  }

  // Search and filter properties
  List<Property> get displayedProperties {
    final String query = searchText.trim().toLowerCase();

    final List<Property> result = properties.where((property) {
      final String name = property.name.toLowerCase();

      final String address = (property.location.address ?? "").toLowerCase();

      final String type = getPropertyType(property);

      final bool matchesSearch =
          query.isEmpty || name.contains(query) || address.contains(query);

      final bool matchesType = selectedType == "All" || type == selectedType;

      return matchesSearch && matchesType;
    }).toList();

    // If renter selected a reference location,
    // show nearest properties first.
    if (selectedReferenceLocation != null) {
      result.sort((a, b) {
        final double? distanceA = getDistanceToProperty(a);

        final double? distanceB = getDistanceToProperty(b);

        if (distanceA == null && distanceB == null) {
          return 0;
        }

        if (distanceA == null) {
          return 1;
        }

        if (distanceB == null) {
          return -1;
        }

        return distanceA.compareTo(distanceB);
      });
    }

    return result;
  }

  // Map markers
  Set<Marker> get propertyMarkers {
    final Set<Marker> markers = {};

    for (final Property property in displayedProperties) {
      final double? latitude = property.location.latitude;

      final double? longitude = property.location.longitude;

      if (latitude == null || longitude == null) {
        continue;
      }

      final int markerId = property.id ?? identityHashCode(property);

      markers.add(
        Marker(
          markerId: MarkerId(markerId.toString()),

          position: LatLng(latitude, longitude),

          infoWindow: InfoWindow(
            title: property.name,

            snippet: "\$${property.price.toStringAsFixed(0)} / month",

            onTap: () {
              openPropertyDetail(property);
            },
          ),

          onTap: () {
            setState(() {
              selectedPropertyId = property.id;
            });
          },
        ),
      );
    }

    if (selectedReferenceLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId("reference_location"),

          position: selectedReferenceLocation!,

          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),

          infoWindow: InfoWindow(
            title: selectedReferenceName ?? "Selected location",
            snippet: "Reference location",
          ),
        ),
      );
    }

    return markers;
  }

  String getPropertyType(Property property) {
    if (property is House) {
      return "House";
    }

    if (property is ApartmentFlat) {
      return "Apartment";
    }

    if (property is Room) {
      return "Room";
    }

    return "Property";
  }

  // Focus initial property
  Future<void> moveToInitialProperty() async {
    if (mapController == null) {
      return;
    }

    Property? targetProperty;

    if (widget.initialProperty != null) {
      final int? initialId = widget.initialProperty!.id;

      if (initialId != null) {
        for (final property in properties) {
          if (property.id == initialId) {
            targetProperty = property;

            break;
          }
        }
      }

      targetProperty ??= widget.initialProperty;
    }

    if (targetProperty != null) {
      await focusProperty(targetProperty);

      return;
    }

    await moveCameraToFirstProperty();
  }

  // Move camera to first property
  Future<void> moveCameraToFirstProperty() async {
    if (mapController == null) {
      return;
    }

    for (final property in displayedProperties) {
      final double? latitude = property.location.latitude;

      final double? longitude = property.location.longitude;

      if (latitude != null && longitude != null) {
        await mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(LatLng(latitude, longitude), 13),
        );

        return;
      }
    }
  }

  // Focus selected property
  Future<void> focusProperty(Property property) async {
    final double? latitude = property.location.latitude;

    final double? longitude = property.location.longitude;

    if (latitude == null || longitude == null || mapController == null) {
      return;
    }

    if (mounted) {
      setState(() {
        selectedPropertyId = property.id;
      });
    }

    await mapController!.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(latitude, longitude), 16),
    );
  }

  // Open property detail
  Future<void> openPropertyDetail(Property property) async {
    await Get.to(() => PropertyDetailScreen(property: property));
  }

  @override
  Widget build(BuildContext context) {
    final List<Property> filteredProperties = displayedProperties;

    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: backgroundColor,

        elevation: 0,

        centerTitle: true,

        iconTheme: const IconThemeData(color: primaryColor),

        title: const Text(
          "Property Map",

          style: TextStyle(
            fontSize: 18,

            fontWeight: FontWeight.w800,

            color: primaryColor,
          ),
        ),
      ),

      body: Column(
        children: [
          buildSearchSection(),

          const SizedBox(height: 12),

          buildTypeFilters(),

          const SizedBox(height: 8),

          buildReferenceLocationButton(),

          const SizedBox(height: 18),

          // The map and property panel share the remaining space.
          // The property panel can now be dragged up and down.
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(child: buildMap()),

                DraggableScrollableSheet(
                  initialChildSize: 0.28,
                  minChildSize: 0.20,
                  maxChildSize: 0.88,
                  builder: (context, scrollController) {
                    return buildPropertyList(
                      filteredProperties,
                      scrollController,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Search
  Widget buildSearchSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),

      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 46,

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.circular(14),

                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.07),

                    blurRadius: 8,

                    offset: const Offset(0, 3),
                  ),
                ],
              ),

              child: TextField(
                controller: searchController,

                onChanged: (value) {
                  setState(() {
                    searchText = value;
                  });
                },

                style: const TextStyle(color: primaryColor),

                decoration: InputDecoration(
                  hintText: "Search this area",

                  hintStyle: const TextStyle(color: Colors.black38),

                  prefixIcon: const Icon(Icons.search, color: primaryColor),

                  suffixIcon: searchText.isEmpty
                      ? null
                      : IconButton(
                          onPressed: () {
                            searchController.clear();

                            setState(() {
                              searchText = "";
                            });
                          },

                          icon: const Icon(
                            Icons.close_rounded,

                            color: primaryColor,

                            size: 19,
                          ),
                        ),

                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          Container(
            height: 46,

            width: 46,

            decoration: BoxDecoration(
              color: lightSecondaryColor,

              borderRadius: BorderRadius.circular(14),

              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.05),

                  blurRadius: 6,

                  offset: const Offset(0, 2),
                ),
              ],
            ),

            child: IconButton(
              onPressed: () {},

              icon: const Icon(Icons.tune, color: primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  // Type filters
  Widget buildTypeFilters() {
    return SizedBox(
      height: 38,

      child: ListView(
        scrollDirection: Axis.horizontal,

        padding: const EdgeInsets.symmetric(horizontal: 16),

        children: [
          typeChip("All"),
          typeChip("House"),
          typeChip("Apartment"),
          typeChip("Room"),
        ],
      ),
    );
  }

  Widget buildReferenceLocationButton() {
    final bool hasLocation = selectedReferenceLocation != null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),

        width: double.infinity,
        height: 52,

        decoration: BoxDecoration(
          color: isChoosingReferenceLocation
              ? lightSecondaryColor
              : Colors.white,

          borderRadius: BorderRadius.circular(14),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(
                isChoosingReferenceLocation ? 0.12 : 0.07,
              ),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: TextButton(
          onPressed: () {
            setState(() {
              isChoosingReferenceLocation = !isChoosingReferenceLocation;
            });
          },

          style: TextButton.styleFrom(
            foregroundColor: primaryColor,

            padding: const EdgeInsets.symmetric(horizontal: 16),

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),

          child: Row(
            children: [
              Icon(
                isChoosingReferenceLocation
                    ? Icons.touch_app_outlined
                    : hasLocation
                    ? Icons.edit_location_alt_outlined
                    : Icons.add_location_alt_outlined,

                color: primaryColor,
                size: 22,
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  isChoosingReferenceLocation
                      ? "Tap on the map to choose location"
                      : hasLocation
                      ? selectedReferenceName ?? "Selected location"
                      : "Choose reference location",

                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
              ),

              if (isChoosingReferenceLocation)
                const Icon(Icons.close_rounded, size: 20, color: primaryColor)
              else
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 22,
                  color: Colors.black38,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget typeChip(String text) {
    final bool isSelected = selectedType == text;

    return Padding(
      padding: const EdgeInsets.only(right: 10),

      child: ChoiceChip(
        label: Text(text),

        selected: isSelected,

        onSelected: (_) {
          setState(() {
            selectedType = text;
          });

          moveCameraToFirstProperty();
        },

        selectedColor: primaryColor,

        backgroundColor: lightSecondaryColor,
        checkmarkColor: Colors.white,

        labelStyle: TextStyle(
          color: isSelected ? Colors.white : primaryColor,

          fontWeight: FontWeight.w600,
        ),

        side: BorderSide.none,

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  // Map
  Widget buildMap() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: primaryColor),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(25),

          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              const Icon(
                Icons.error_outline_rounded,

                size: 45,

                color: primaryColor,
              ),

              const SizedBox(height: 12),

              Text(
                errorMessage!,

                textAlign: TextAlign.center,

                style: const TextStyle(color: Colors.black54),
              ),

              const SizedBox(height: 15),

              ElevatedButton(
                onPressed: loadProperties,

                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,

                  foregroundColor: Colors.white,
                ),

                child: const Text("Try Again"),
              ),
            ],
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),

      child: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: initialPosition,

          zoom: 13,
        ),

        onMapCreated: (controller) {
          mapController = controller;

          moveToInitialProperty();
        },

        markers: propertyMarkers,

        zoomControlsEnabled: false,

        myLocationButtonEnabled: false,

        onTap: (LatLng position) {
          if (!isChoosingReferenceLocation) {
            return;
          }

          selectReferenceLocation(position);
        },
      ),
    );
  }

  // Bottom property panel
  Widget buildPropertyList(
    List<Property> properties,
    ScrollController scrollController,
  ) {
    return Container(
      width: double.infinity,

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),

        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.08),

            blurRadius: 15,

            offset: const Offset(0, -3),
          ),
        ],
      ),

      // Keep a permanent gap at the top of the white panel.
      // Because this Padding is OUTSIDE the scroll view, the gap stays
      // visible even when the property list is scrolled.
      child: Padding(
        padding: const EdgeInsets.only(top: 14),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),

          child: CustomScrollView(
            controller: scrollController,

            physics: const ClampingScrollPhysics(),

            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 9, 16, 6),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      // Drag handle
                      Center(
                        child: Container(
                          width: 42,
                          height: 5,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD1D5DB),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "${properties.length} ${properties.length == 1 ? "Property" : "Properties"} Found",

                              style: const TextStyle(
                                color: primaryColor,

                                fontSize: 16,

                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),

                          const Icon(
                            Icons.location_on_outlined,

                            size: 17,

                            color: primaryColor,
                          ),

                          const SizedBox(width: 3),

                          const Text(
                            "Map",

                            style: TextStyle(
                              color: primaryColor,

                              fontSize: 11,

                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 2),
                    ],
                  ),
                ),
              ),

              if (properties.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: buildEmptyState(),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final bool isLast = index == properties.length - 1;

                      return Column(
                        children: [
                          propertyItem(properties[index]),

                          if (!isLast)
                            Divider(
                              height: 1,
                              color: primaryColor.withOpacity(0.08),
                            ),
                        ],
                      );
                    }, childCount: properties.length),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Property item
  Widget propertyItem(Property property) {
    final bool isSelected = selectedPropertyId == property.id;
    final double? distance = getDistanceToProperty(property);

    return Material(
      color: Colors.transparent,

      child: InkWell(
        onTap: () {
          focusProperty(property);
        },

        borderRadius: BorderRadius.circular(12),

        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),

          decoration: BoxDecoration(
            color: isSelected
                ? lightSecondaryColor.withOpacity(0.45)
                : Colors.transparent,

            borderRadius: BorderRadius.circular(12),
          ),

          child: Row(
            children: [
              buildPropertyImage(property),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      property.name,

                      maxLines: 1,

                      overflow: TextOverflow.ellipsis,

                      style: const TextStyle(
                        color: primaryColor,

                        fontSize: 14,

                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,

                          size: 14,

                          color: primaryColor,
                        ),

                        const SizedBox(width: 3),

                        Expanded(
                          child: Text(
                            property.location.address ?? "Unknown location",

                            maxLines: 1,

                            overflow: TextOverflow.ellipsis,

                            style: const TextStyle(
                              fontSize: 11,

                              color: Colors.black45,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    Text(
                      "\$${property.price.toStringAsFixed(0)} / month",

                      style: const TextStyle(
                        fontSize: 13,

                        fontWeight: FontWeight.w700,

                        color: primaryColor,
                      ),
                    ),
                    if (distance != null) ...[
                      const SizedBox(height: 4),

                      Row(
                        children: [
                          const Icon(
                            Icons.near_me_outlined,
                            size: 13,
                            color: Colors.black45,
                          ),

                          const SizedBox(width: 4),

                          Text(
                            "${distance.toStringAsFixed(1)} km away",
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(width: 6),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 3,
                    ),

                    decoration: BoxDecoration(
                      color: lightSecondaryColor,

                      borderRadius: BorderRadius.circular(8),
                    ),

                    child: Text(
                      getPropertyType(property),

                      style: const TextStyle(
                        fontSize: 9,

                        color: primaryColor,

                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 5),

                  InkWell(
                    onTap: () {
                      openPropertyDetail(property);
                    },

                    borderRadius: BorderRadius.circular(20),

                    child: const Padding(
                      padding: EdgeInsets.all(5),

                      child: Icon(
                        Icons.arrow_forward_ios_rounded,

                        size: 14,

                        color: primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Property image
  Widget buildPropertyImage(Property property) {
    if (property.images.isEmpty) {
      return Container(
        width: 72,
        height: 60,

        decoration: BoxDecoration(
          color: lightSecondaryColor,

          borderRadius: BorderRadius.circular(10),
        ),

        child: const Icon(
          Icons.home_work_outlined,

          size: 27,

          color: primaryColor,
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),

      child: Image.network(
        property.images.first,

        width: 72,
        height: 60,

        fit: BoxFit.cover,

        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 72,
            height: 60,

            color: lightSecondaryColor,

            child: const Icon(
              Icons.home_work_outlined,

              size: 27,

              color: primaryColor,
            ),
          );
        },
      ),
    );
  }

  Widget buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,

        children: [
          Icon(Icons.location_off_outlined, size: 30, color: primaryColor),

          SizedBox(height: 5),

          Text(
            "No properties found",

            style: TextStyle(
              color: primaryColor,

              fontSize: 13,

              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 3),

          Text(
            "Try another search or property type.",

            style: TextStyle(color: Colors.black45, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
