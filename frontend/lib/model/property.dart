class Property {
  String title;
  double price;
  double distance;
  double matchPercent;
  String imageUrl;

  Property({
    required this.title,
    required this.price,
    required this.distance,
    required this.matchPercent,
    required this.imageUrl,
  });
}

final List<Property> propertyList = [
  Property(
    title: "Cozy Student Room",
    price: 150,
    distance: 0.8,
    matchPercent: 95,
    imageUrl:
        "https://i.pinimg.com/736x/7b/00/65/7b0065005f3c9b89ce90b9475edc0037.jpg",
  ),
  Property(
    title: "Modern Student Apartment",
    price: 180,
    distance: 1.2,
    matchPercent: 88,
    imageUrl:
        "https://i.pinimg.com/736x/7b/00/65/7b0065005f3c9b89ce90b9475edc0037.jpg",
  ),
  Property(
    title: "Affordable Private Room",
    price: 120,
    distance: 2.0,
    matchPercent: 82,
    imageUrl:
        "https://i.pinimg.com/736x/7b/00/65/7b0065005f3c9b89ce90b9475edc0037.jpg",
  ),
];