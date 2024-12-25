import 'package:car_rental/data/models/Car.dart';
import 'package:car_rental/presentation/widgets/car_card.dart';
import 'package:flutter/material.dart';

class CarListScreen extends StatelessWidget {

  final List<Car> cars = [
  Car (model: 'Fortuner GR', distance: 800, fuelCapacity: 50, pricePerHour: 45),
  Car (model:'Đức dua', distance: 100,fuelCapacity: 50, pricePerHour: 45),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Your Car'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: ListView.builder(
        itemCount: cars.length,
        itemBuilder: (context, index){
          return CarCard(car: cars[index]);
        },
      ),
    );
  }
}
