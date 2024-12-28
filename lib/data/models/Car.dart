class Car {
  final String model;
  final double distance;
  final double fuelCapacity;
  final double pricePerHour;
  final String imageUrl;

  Car({
    required this.model,
    required this.distance,
    required this.fuelCapacity,
    required this.pricePerHour,
    this.imageUrl = 'assets/car_image.png' // Default value for backward compatibility
  });

  factory Car.fromMap(Map<String, dynamic> map) {
    return Car(
        model: map['model'],
        distance: (map['distance'] is int)
            ? (map['distance'] as int).toDouble()
            : map['distance'],
        fuelCapacity: (map['fuelCapacity'] is int)
            ? (map['fuelCapacity'] as int).toDouble()
            : map['fuelCapacity'],
        pricePerHour: (map['pricePerHour'] is int)
            ? (map['pricePerHour'] as int).toDouble()
            : map['pricePerHour'],
        imageUrl: map['imageUrl'] ?? 'assets/car_image.png'
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'model': model,
      'distance': distance,
      'fuelCapacity': fuelCapacity,
      'pricePerHour': pricePerHour,
      'imageUrl': imageUrl,
    };
  }
}