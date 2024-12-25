

import 'package:car_rental/data/datasrc/firebase_data_src.dart';
import 'package:car_rental/data/models/Car.dart';
import 'package:car_rental/domain/repo/car_repo.dart';

class CarRepositoryImpl implements CarRepository {
  final FirebaseDataSource dataSource;

  CarRepositoryImpl(this.dataSource);

  @override
  Future<List<Car>> fetchCars() {
    return dataSource.getCars();
  }
}
