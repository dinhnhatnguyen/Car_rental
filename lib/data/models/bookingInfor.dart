class BookingInfo {
  final String customerName;
  final String phoneNumber;
  final DateTime deliveryTime;
  final double latitude;
  final double longitude;
  final String carModel;

  BookingInfo({
    required this.customerName,
    required this.phoneNumber,
    required this.deliveryTime,
    required this.latitude,
    required this.longitude,
    required this.carModel,
  });

  Map<String, dynamic> toMap() {
    return {
      'customerName': customerName,
      'phoneNumber': phoneNumber,
      'deliveryTime': deliveryTime.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'carModel': carModel,
    };
  }

  factory BookingInfo.fromMap(Map<String, dynamic> map) {
    return BookingInfo(
      customerName: map['customerName'],
      phoneNumber: map['phoneNumber'],
      deliveryTime: DateTime.parse(map['deliveryTime']),
      latitude: map['latitude'],
      longitude: map['longitude'],
      carModel: map['carModel'],
    );
  }
}