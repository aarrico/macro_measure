import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Macro Measure',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MacroCalculatorScreen(),
    );
  }
}

class MacroCalculatorScreen extends StatefulWidget {
  const MacroCalculatorScreen({super.key});

  @override
  State<MacroCalculatorScreen> createState() => _MacroCalculatorScreenState();
}

class _MacroCalculatorScreenState extends State<MacroCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _proteinController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatController = TextEditingController();
  
  String? _selectedFood;
  double _calculatedWeight = 0.0;
  
  // Sample food database with macros per 100g
  final Map<String, Map<String, double>> _foodDatabase = {
    'Chicken Breast': {'protein': 31.0, 'carbs': 0.0, 'fat': 3.6},
    'Brown Rice': {'protein': 2.6, 'carbs': 77.2, 'fat': 0.9},
    'Oats': {'protein': 13.2, 'carbs': 67.0, 'fat': 6.5},
    'Salmon': {'protein': 25.4, 'carbs': 0.0, 'fat': 12.4},
    'Sweet Potato': {'protein': 2.0, 'carbs': 20.1, 'fat': 0.1},
    'Almonds': {'protein': 21.2, 'carbs': 9.5, 'fat': 49.9},
    'Egg': {'protein': 13.0, 'carbs': 1.1, 'fat': 11.0},
    'Banana': {'protein': 1.1, 'carbs': 22.8, 'fat': 0.3},
  };

  void _calculateFoodWeight() {
    if (_formKey.currentState!.validate() && _selectedFood != null) {
      final targetProtein = double.parse(_proteinController.text);
      final targetCarbs = double.parse(_carbsController.text);
      final targetFat = double.parse(_fatController.text);
      
      final foodMacros = _foodDatabase[_selectedFood!]!;
      
      // Calculate weight needed based on the macro that requires the most food
      double weightForProtein = targetProtein / foodMacros['protein']! * 100;
      double weightForCarbs = targetCarbs / foodMacros['carbs']! * 100;
      double weightForFat = targetFat / foodMacros['fat']! * 100;
      
      // Use the maximum weight needed (limiting factor)
      double maxWeight = [weightForProtein, weightForCarbs, weightForFat]
          .where((w) => w.isFinite)
          .reduce((a, b) => a > b ? a : b);
      
      setState(() {
        _calculatedWeight = maxWeight;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Macro Measure Calculator'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Target Macros (grams)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _proteinController,
                      decoration: const InputDecoration(
                        labelText: 'Protein (g)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter protein amount';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Enter valid number';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _carbsController,
                      decoration: const InputDecoration(
                        labelText: 'Carbs (g)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter carbs amount';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Enter valid number';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _fatController,
                      decoration: const InputDecoration(
                        labelText: 'Fat (g)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter fat amount';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Enter valid number';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Select Food',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedFood,
                decoration: const InputDecoration(
                  labelText: 'Choose a food item',
                  border: OutlineInputBorder(),
                ),
                items: _foodDatabase.keys.map((String food) {
                  return DropdownMenuItem<String>(
                    value: food,
                    child: Text(food),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedFood = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a food item';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _calculateFoodWeight,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Calculate Food Weight',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 24),
              if (_calculatedWeight > 0)
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Result',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'You need ${_calculatedWeight.toStringAsFixed(1)}g of $_selectedFood',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        if (_selectedFood != null)
                          Text(
                            'This will provide approximately:\n'
                            '• ${(_calculatedWeight * _foodDatabase[_selectedFood!]!['protein']! / 100).toStringAsFixed(1)}g protein\n'
                            '• ${(_calculatedWeight * _foodDatabase[_selectedFood!]!['carbs']! / 100).toStringAsFixed(1)}g carbs\n'
                            '• ${(_calculatedWeight * _foodDatabase[_selectedFood!]!['fat']! / 100).toStringAsFixed(1)}g fat',
                            style: const TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    super.dispose();
  }
}
