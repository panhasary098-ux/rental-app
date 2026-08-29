import 'package:final_project/view/renter/property_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class PropertiesfoundScreen extends StatefulWidget {
  const PropertiesfoundScreen({super.key});

  @override
  State<PropertiesfoundScreen> createState() => _PropertiesfoundScreenState();
}

class _PropertiesfoundScreenState extends State<PropertiesfoundScreen> {
  List<String> favorites = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 233, 235, 234),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 233, 235, 234),
        title: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: SizedBox(
            height: 50,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    spreadRadius: 1,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextFormField(
                style: TextStyle(fontSize: 15),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),

                  hintText: 'Search Property name....',

                  filled: true,
                  fillColor: Colors.white,

                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),

                  // Filter button
                ),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              customitemShow(
                image:
                    "https://i.pinimg.com/736x/ea/5c/43/ea5c43affdd542481ab2862014027f12.jpg",
                name: "bali - N3",
                location: "Chroy jongva, Phnom Penh",
                price: 150,
                distance: 1,
              ),
              SizedBox(height: 20),
              customitemShow(
                image:
                    "https://i.pinimg.com/736x/ea/5c/43/ea5c43affdd542481ab2862014027f12.jpg",
                name: "bali - N3",
                location: "Chroy jongva, Phnom Penh",
                price: 150,
                distance: 1,
              ),
              SizedBox(height: 20),
              customitemShow(
                image:
                    "https://i.pinimg.com/736x/ea/5c/43/ea5c43affdd542481ab2862014027f12.jpg",
                name: "bali - N3",
                location: "Chroy jongva, Phnom Penh",
                price: 150,
                distance: 1,
              ),
              SizedBox(height: 20),
              customitemShow(
                image:
                    "https://i.pinimg.com/736x/ea/5c/43/ea5c43affdd542481ab2862014027f12.jpg",
                name: "bali - N3",
                location: "Chroy jongva, Phnom Penh",
                price: 150,
                distance: 1,
              ),
              SizedBox(height: 20),
              customitemShow(
                image:
                    "https://i.pinimg.com/736x/ea/5c/43/ea5c43affdd542481ab2862014027f12.jpg",
                name: "bali - N3",
                location: "Chroy jongva, Phnom Penh",
                price: 150,
                distance: 1,
              ),
              SizedBox(height: 10),
              customitemShow(
                image:
                    "https://i.pinimg.com/736x/ea/5c/43/ea5c43affdd542481ab2862014027f12.jpg",
                name: "bali - N",
                location: "Chroy jongva, Phnom Penh",
                price: 150,
                distance: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget customitemShow({
    required String image,
    required String name,
    required String location,
    required double price,
    required double distance,
  }) {
    bool isFavorite = favorites.contains(name);
    return Container(
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),

        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(10),
              child: Stack(
                children: [
                  InkWell(
                    onTap: () {
                      Get.to(() => PropertyDetailScreen());
                    },
                    child: Image.network(
                      image,
                      height: 150,
                      width: 160,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 5,
                    left: 5,
                    child: Container(
                      height: 22,
                      decoration: BoxDecoration(
                        color: Colors.orange[700],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Center(
                          child: Text(
                            "Available",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 10,
                top: 10,
                bottom: 10,
                right: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                        ),
                      ),
                      //SizedBox(height: 5),
                      Text(
                        location,
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Text(
                        "\$$price",
                        style: TextStyle(
                          color: Colors.orange[700],
                          fontWeight: FontWeight.w900,
                          fontSize: 17,
                        ),
                      ),
                      Text(
                        '/Month',
                        style: TextStyle(
                          color: Color(0xFF35B64A),
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: const Color.fromARGB(255, 58, 58, 58),
                        size: 18,
                      ),
                      Text(
                        "${distance}Km",
                        style: TextStyle(color: Colors.black87),
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (isFavorite) {
                              favorites.remove(name);
                            } else {
                              //Icon(Icons.favorite, color: Colors.red, size: 20);
                              favorites.add(name);
                            }
                          });
                        },
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite
                              ? Colors.red
                              : const Color.fromARGB(255, 58, 58, 58),
                          size: 20,
                        ),
                      ),
                    ],
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
