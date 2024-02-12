import 'package:flutter/material.dart';
import 'package:workout_routine/themes/colors.dart';

class MeasureUnits extends StatefulWidget {
  const MeasureUnits({super.key});

  @override
  State<MeasureUnits> createState() => _MeasureUnitsState();
}

class _MeasureUnitsState extends State<MeasureUnits> {
  final List<String> _measureUnits = ['Pounds', 'Kilograms'];

  late String _currentMeasureUnit = _measureUnits[0];

  void _setMeasureUnit(String value) => setState(() => _currentMeasureUnit = value);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: ThemeColor.primary,
          title: const Text(
            'Units of Measure',
            style: TextStyle(color: ThemeColor.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const CircleAvatar(
              backgroundColor: ThemeColor.tertiary,
              child: Icon(Icons.arrow_back, color: ThemeColor.white),
            ),
          ),
        ),
        body: Container(
          color: ThemeColor.primary,
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Divider(color: ThemeColor.tertiary, thickness: 1),
              ListTile(
                title: const Text(
                  'Pounds',
                  style: TextStyle(color: ThemeColor.white, fontSize: 20),
                ),
                trailing: Radio(
                  value: _measureUnits[0],
                  groupValue: _currentMeasureUnit,
                  onChanged: (value) => _setMeasureUnit(value.toString()),
                  activeColor: Colors.greenAccent,
                ),
              ),
              const Divider(color: ThemeColor.tertiary, thickness: 1),
              ListTile(
                title: const Text(
                  'Kilograms',
                  style: TextStyle(color: ThemeColor.white, fontSize: 20),
                ),
                trailing: Radio(
                  value: _measureUnits[1],
                  groupValue: _currentMeasureUnit,
                  onChanged: (value) => _setMeasureUnit(value.toString()),
                  activeColor: Colors.greenAccent,
                ),
              ),
              const Divider(color: ThemeColor.tertiary, thickness: 1),
            ],
          ),
        ),
      );
}
