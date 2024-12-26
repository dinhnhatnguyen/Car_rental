import 'package:car_rental/data/models/Car.dart';
import 'package:car_rental/data/models/bookingInfor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MapsDetailsPage extends StatefulWidget {
  final Car car;

  const MapsDetailsPage({super.key, required this.car});

  @override
  State<MapsDetailsPage> createState() => _MapsDetailsPageState();
}

class _MapsDetailsPageState extends State<MapsDetailsPage> {
  LatLng? selectedLocation;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  DateTime? _selectedTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(16.468380, 107.578626),
              initialZoom: 16,
              onTap: (tapPosition, point) {
                setState(() {
                  selectedLocation = point;
                });
              },
            ),
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
              ),
              if (selectedLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: selectedLocation!,
                      width: 40,
                      height: 40,
                      child: Icon(Icons.location_pin, color: Colors.red, size: 40),
                    ),
                  ],
                ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildCarDetailsCard(),
          )
        ],
      ),
    );
  }

  Widget _buildCarDetailsCard() {
    return SizedBox(
      height: 350,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10)
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Text(
                  '${widget.car.model}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.directions_car, color: Colors.white, size: 16),
                    SizedBox(width: 5),
                    Text(
                      '> ${widget.car.distance} km',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.battery_full, color: Colors.white, size: 14),
                    SizedBox(width: 5),
                    Text(
                      '${widget.car.fuelCapacity}',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                )
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Features",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  featureIcons(),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${widget.car.pricePerHour}/day',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                        onPressed: () => _showBookingForm(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                        child: Text(
                          'Book Now',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: 50,
            right: 20,
            child: Image.asset('assets/white_car.png'),
          )
        ],
      ),
    );
  }

  void _showBookingForm() {
    if (selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a delivery location on the map first')),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: 'Phone Number'),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                ListTile(
                  title: Text(_selectedTime == null
                      ? 'Select Delivery Time'
                      : 'Delivery Time: ${_selectedTime!.toString()}'),
                  trailing: Icon(Icons.calendar_today),
                  onTap: () async {
                    final DateTime? picked = await showDateTimePicker(context);
                    if (picked != null) {
                      setState(() {
                        _selectedTime = picked;
                      });
                    }
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitBooking,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text(
                    'Confirm Booking',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<DateTime?> showDateTimePicker(BuildContext context) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 30)),
    );
    if (date == null) return null;

    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null) return null;

    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  }

  void _submitBooking() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select a delivery time')),
        );
        return;
      }

      final booking = BookingInfo(
        customerName: _nameController.text,
        phoneNumber: _phoneController.text,
        deliveryTime: _selectedTime!,
        latitude: selectedLocation!.latitude,
        longitude: selectedLocation!.longitude,
        carModel: widget.car.model,
      );

      try {
        await FirebaseFirestore.instance
            .collection('booking_info')
            .add(booking.toMap());

        Navigator.pop(context); // Close the form
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Booking successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting booking. Please try again.')),
        );
      }
    }
  }
}

Widget featureIcons() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      featureIcon(Icons.local_gas_station, 'Diesel', 'Common Rail'),
      featureIcon(Icons.speed, 'Acceleration', '0 - 100km/s'),
      featureIcon(Icons.ac_unit, 'Cold', 'Temp Control'),
    ],
  );
}

Widget featureIcon(IconData icon, String title, String subtitle) {
  return Container(
    width: 100,
    height: 100,
    padding: EdgeInsets.all(5),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.grey, width: 1),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 28),
        Text(title),
        Text(
          subtitle,
          style: TextStyle(color: Colors.grey, fontSize: 10),
        ),
      ],
    ),
  );
}

