import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingHistoryCard extends StatefulWidget {
  final Map<String, dynamic> bookingData;
  final String documentId;

  const BookingHistoryCard({
    required this.bookingData,
    required this.documentId,
  });

  @override
  State<BookingHistoryCard> createState() => _BookingHistoryCardState();
}

class _BookingHistoryCardState extends State<BookingHistoryCard> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  DateTime? _selectedTime;
  LatLng? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.bookingData['customerName']);
    _phoneController = TextEditingController(text: widget.bookingData['phoneNumber']);
    _selectedTime = DateTime.parse(widget.bookingData['deliveryTime']);
    _selectedLocation = LatLng(
      widget.bookingData['latitude'],
      widget.bookingData['longitude'],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deliveryTime = DateTime.parse(widget.bookingData['deliveryTime']);
    final formattedDate = DateFormat('MMM dd, yyyy - HH:mm').format(deliveryTime);

    return Dismissible(
      key: Key(widget.documentId),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Choose Action'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: Icon(Icons.edit),
                    title: Text('Edit Booking'),
                    onTap: () {
                      Navigator.pop(context, false);
                      _showEditDialog(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.delete, color: Colors.red),
                    title: Text('Delete Booking'),
                    onTap: () => _deleteBooking(context),
                  ),
                ],
              ),
            ),
          );
        }
        return false;
      },
      background: Container(
        color: Colors.orange,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.settings, color: Colors.white),
          ],
        ),
      ),
      child: Card(
        color: Color(0xff2C2B34),
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ExpansionTile(
          title: Text(
            widget.bookingData['carModel'],
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white
            ),
          ),
          subtitle: Text(
            formattedDate,
            style: TextStyle(color: Colors.white),
          ),
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow('Customer', widget.bookingData['customerName']),
                  _buildInfoRow('Phone', widget.bookingData['phoneNumber']),
                  _buildInfoRow('Price', '\$${widget.bookingData['carPricePerHour']}/h'),
                  SizedBox(height: 16),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: FlutterMap(
                        options: MapOptions(
                          initialCenter: LatLng(
                            widget.bookingData['latitude'],
                            widget.bookingData['longitude'],
                          ),
                          initialZoom: 15,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: LatLng(
                                  widget.bookingData['latitude'],
                                  widget.bookingData['longitude'],
                                ),
                                width: 40,
                                height: 40,
                                child: Icon(
                                  Icons.location_pin,
                                  color: Colors.red,
                                  size: 40,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    // Reset selected location to current booking location
    _selectedLocation = LatLng(
      widget.bookingData['latitude'],
      widget.bookingData['longitude'],
    );

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Dialog(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      FlutterMap(
                        options: MapOptions(
                          initialCenter: _selectedLocation!,
                          initialZoom: 15,
                          onTap: (tapPosition, point) {
                            setState(() {
                              _selectedLocation = point;
                            });
                          },
                        ),
                        children: [
                          TileLayer(
                            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          ),
                          MarkerLayer(
                            markers: [
                              if (_selectedLocation != null)
                                Marker(
                                  point: _selectedLocation!,
                                  width: 40,
                                  height: 40,
                                  child: Icon(Icons.location_pin, color: Colors.red, size: 40),
                                ),
                            ],
                          ),
                        ],
                      ),
                      Positioned(
                        top: 10,
                        left: 10,
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Tap to select new location',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16),
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
                              : 'Delivery Time: ${DateFormat('MMM dd, yyyy - HH:mm').format(_selectedTime!)}'),
                          trailing: Icon(Icons.calendar_today),
                          onTap: () => _selectDateTime(context),
                        ),
                        if (_selectedLocation != null)
                          Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Text(
                              'Selected Location: ${_selectedLocation!.latitude.toStringAsFixed(6)}, ${_selectedLocation!.longitude.toStringAsFixed(6)}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => Navigator.pop(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey,
                                ),
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => _updateBooking(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                ),
                                child: Text(
                                  'Update Booking',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: _selectedTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 30)),
    );
    if (date == null) return;

    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedTime ?? DateTime.now()),
    );
    if (time == null) return;

    setState(() {
      _selectedTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<void> _updateBooking(BuildContext context) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_selectedLocation == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select location and time')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('booking_info')
          .doc(widget.documentId)
          .update({
        'customerName': _nameController.text,
        'phoneNumber': _phoneController.text,
        'deliveryTime': _selectedTime!.toIso8601String(),
        'latitude': _selectedLocation!.latitude,
        'longitude': _selectedLocation!.longitude,
      });

      Navigator.of(context).pop(); // Close the edit dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking updated successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating booking: ${e.toString()}')),
      );
    }
  }

  Future<void> _deleteBooking(BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('booking_info')
          .doc(widget.documentId)
          .delete();

      Navigator.of(context).pop(); // Close the dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking deleted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting booking: ${e.toString()}')),
      );
    }
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}