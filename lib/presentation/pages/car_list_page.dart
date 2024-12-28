import 'package:car_rental/presentation/bloc/car_bloc.dart';
import 'package:car_rental/presentation/widgets/car_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../service/auth_service.dart';
import '../bloc/car_state.dart';
import 'booking_history_page.dart';
import 'login_page.dart';

class CarListScreen extends StatelessWidget {
  final AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Choose Your Car', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xff2C2B34),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  // User is logged in
                  return Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.person),
                        title: Text(snapshot.data?.email ?? 'User'),
                      ),
                      ListTile(
                        leading: Icon(Icons.logout),
                        title: Text('Logout'),
                        onTap: () async {
                          await _authService.signOut(context);
                          Navigator.pop(context); // Close drawer
                        },
                      ),
                    ],
                  );
                } else {
                  // User is not logged in
                  return ListTile(
                    leading: Icon(Icons.login),
                    title: Text('Login'),
                    onTap: () {
                      Navigator.pop(context); // Close drawer
                      Navigator.pushReplacement( // Use pushReplacement instead of push
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      );
                    },
                  );
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('Booking History'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingHistoryPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: BlocBuilder<CarBloc, CarState>(
        builder: (context, state) {
          if (state is CarsLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is CarsLoaded) {
            return ListView.builder(
              itemCount: state.cars.length,
              itemBuilder: (context, index) {
                return CarCard(car: state.cars[index]);
              },
            );
          } else if (state is CarsError) {
            return Center(
              child: Text('error : ${state.message}'),
            );
          }
          return Container();
        },
      ),
    );
  }
}
