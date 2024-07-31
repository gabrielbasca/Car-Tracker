import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'car_insurance_service.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CarInsuranceService>(
      builder: (context, service, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Car Insurance'),
            backgroundColor: Color.fromARGB(255, 211, 33, 16),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: service.isInitialized
              ? Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton(
                        child: Text('Set Expiration Date'),
                        onPressed: () => _selectDate(context),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFE94560)),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        child: Text('Get Expiration Date'),
                        onPressed: () => _getExpirationDate(context),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFE94560)),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        child: Text('Check if Expired'),
                        onPressed: () => _checkIfExpired(context),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFE94560)),
                      ),
                    ],
                  ),
                )
              : Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  void _selectDate(BuildContext context) async {
    final service = Provider.of<CarInsuranceService>(context, listen: false);
    if (!service.isInitialized) await service.initiateSetup();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      final msg = await service.setExpirationDate(picked);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
        ),
      );
    }
  }

  void _getExpirationDate(BuildContext context) async {
    final date = await Provider.of<CarInsuranceService>(context, listen: false)
        .getExpirationDate();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Expiration date: ${DateFormat('yyyy-MM-dd').format(date)}'),
      ),
    );
  }

  void _checkIfExpired(BuildContext context) async {
    final isExpired =
        await Provider.of<CarInsuranceService>(context, listen: false)
            .isInsuranceExpired();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            isExpired ? 'Insurance is expired' : 'Insurance is not expired'),
      ),
    );
  }
}
