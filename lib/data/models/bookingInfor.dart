class BookingInfo {
  final String customerName;
  final String phoneNumber;
  final String email;
  final DateTime deliveryTime;
  final double latitude;
  final double longitude;
  // Car information
  final String carModel;
  final double carDistance;
  final double carFuelCapacity;
  final double carPricePerHour;

  BookingInfo({
    required this.customerName,
    required this.phoneNumber,
    required this.email,
    required this.deliveryTime,
    required this.latitude,
    required this.longitude,
    required this.carModel,
    required this.carDistance,
    required this.carFuelCapacity,
    required this.carPricePerHour,
  });

  Map<String, dynamic> toMap() {
    return {
      'customerName': customerName,
      'phoneNumber': phoneNumber,
      'email': email,
      'deliveryTime': deliveryTime.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      // Car information
      'carModel': carModel,
      'carDistance': carDistance,
      'carFuelCapacity': carFuelCapacity,
      'carPricePerHour': carPricePerHour,
    };
  }

  factory BookingInfo.fromMap(Map<String, dynamic> map) {
    return BookingInfo(
      customerName: map['customerName'],
      phoneNumber: map['phoneNumber'],
      email: map['email'],
      deliveryTime: DateTime.parse(map['deliveryTime']),
      latitude: map['latitude'],
      longitude: map['longitude'],
      carModel: map['carModel'],
      carDistance: map['carDistance'],
      carFuelCapacity: map['carFuelCapacity'],
      carPricePerHour: map['carPricePerHour'],
    );
  }
}