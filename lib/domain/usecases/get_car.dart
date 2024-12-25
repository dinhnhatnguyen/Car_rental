import 'package:car_rental/data/models/Car.dart';
import 'package:car_rental/domain/repo/car_repo.dart';

class GetCars {
  final CarRepository repository;

  GetCars(this.repository);

  Future<List<Car>> call() async {
    return await repository.fetchCars();
  }
}