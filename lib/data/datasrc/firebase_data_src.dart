import 'package:car_rental/data/models/Car.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDataSource {
  final FirebaseFirestore firestore;
  FirebaseDataSource({required this.firestore});

  Future<List<Car>> getCars() async{
    var snapshot = await firestore.collection('cars').get();
    return snapshot.docs.map((doc) => Car.fromMap(doc.data())).toList();
  }
}