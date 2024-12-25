import 'package:car_rental/data/models/Car.dart';

abstract class CarRepository {
  Future<List<Car>> fetchCars();
}