import 'package:car_rental/data/models/Car.dart';
import 'package:car_rental/presentation/widgets/car_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class CarListScreen extends StatelessWidget {

  final List<Car> cars = [
  Car (model: 'Fentuner GR', distance: 870, fuelCapacity: 50, pricePerHour: 45),
  Car (model:'Fantuner GR', distance: 870,fuelCapacity: 50, pricePerHour: 45),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Your Car'),
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
