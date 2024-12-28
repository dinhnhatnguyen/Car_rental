import 'package:car_rental/data/models/Car.dart';
import 'package:car_rental/data/models/User.dart';
import 'package:car_rental/data/models/bookingInfor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDataSource {
  final FirebaseFirestore firestore;
  FirebaseDataSource({required this.firestore});

  Future<List<Car>> getCars() async{
    var snapshot = await firestore.collection('cars').get();
    return snapshot.docs.map((doc) => Car.fromMap(doc.data())).toList();
  }

  Future<void> saveBooking(BookingInfo bookingInfo) async {
    await firestore.collection('booking_info').add(bookingInfo.toMap());
  }

  // // Add user methods
  // Future<void> saveUser(String uid, User user) async {
  //   await firestore.collection('users').doc(uid).set(user.toMap());
  // }
  //
  // Future<User?> getUser(String uid) async {
  //   final doc = await firestore.collection('users').doc(uid).get();
  //   if (doc.exists) {
  //     return User.fromMap(doc.data()!);
  //   }
  //   return null;
  // }
}