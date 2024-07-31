import 'package:flutter/material.dart';
import 'home_page.dart';

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicle Services'),
        backgroundColor: Color(0xFF1A1A2E),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildButton(context, 'Car Insurance', Icons.directions_car, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              }),
              SizedBox(height: 20),
              _buildButton(context, 'Vignette', Icons.receipt_long, () {
                // TODO: Implement Vignette screen
              }),
              SizedBox(height: 20),
              _buildButton(context, 'Technical Service', Icons.build, () {
                // TODO: Implement Technical Service screen
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String title, IconData icon,
      VoidCallback onPressed) {
    return ElevatedButton.icon(
      icon: Icon(icon, color: Color(0xFF1A1A2E)),
      label: Text(title),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFE94560),
        foregroundColor: Color(0xFF1A1A2E),
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      onPressed: onPressed,
    );
  }
}
