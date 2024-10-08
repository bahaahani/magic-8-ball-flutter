import 'package:flutter/material.dart';

class Laptop {
  String brand;
  String cpu;
  double ram;
  double weight;
  int screenSize;
  bool storage;
  bool os;
  DateTime manuDate;

  Laptop({
    required this.brand,
    required this.cpu,
    required this.ram,
    required this.weight,
    required this.screenSize,
    required this.storage,
    required this.os,
    required this.manuDate,
  });
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Laptops',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      home: LaptopForm(),
    );
  }
}

class LaptopForm extends StatefulWidget {
  @override
  _LaptopFormState createState() => _LaptopFormState();
}

class _LaptopFormState extends State<LaptopForm> {
  String brand = '';
  String cpu = 'intel i7';
  String gpu = 'M2 Pro';
  double ram = 8;
  double weight = 1.5;
  int screenSize = 14;
  bool storage = false;
  bool os = false;
  DateTime manuDate = DateTime.now();

  List<Laptop> laptops = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title:
            Text('Laptop Configurator', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LaptopList(laptops: laptops)),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildTextField('Brand Name', (value) => brand = value),
            SizedBox(height: 16),
            buildDropdown(
                'CPU',
                cpu,
                ['intel i7', 'intel i5', 'intel i3', 'AMD'],
                (value) => setState(() => cpu = value!)),
            SizedBox(height: 16),
            buildDropdown(
                'GPU',
                gpu,
                ['M2 Pro', 'Intel Iris', 'Nvidia GeForce', 'AMD Radeon'],
                (value) => setState(() => gpu = value!)),
            SizedBox(height: 16),
            buildSlider(
                'RAM (GB)', ram, 0, 64, (value) => setState(() => ram = value)),
            SizedBox(height: 16),
            buildSlider('Weight (kg)', weight, 0.5, 3,
                (value) => setState(() => weight = value)),
            SizedBox(height: 16),
            buildRadioButtons(),
            SizedBox(height: 16),
            buildSwitchListTile('Enable HDD', storage,
                (value) => setState(() => storage = value)),
            buildCheckboxListTile(
                'Enable OS', os, (value) => setState(() => os = value!)),
            SizedBox(height: 16),
            buildDatePicker(),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: addLaptop,
              child: Text('Add Laptop', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String label, Function(String) onChanged) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      onChanged: onChanged,
    );
  }

  Widget buildDropdown(String label, String value, List<String> items,
      Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: label),
      value: value,
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
    );
  }

  Widget buildSlider(String label, double value, double min, double max,
      Function(double) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: ${value.toStringAsFixed(1)}'),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: ((max - min) * 10).toInt(),
          label: value.toStringAsFixed(1),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget buildRadioButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Screen Size:'),
        ...['13 inch', '14 inch', '15 inch'].map((size) {
          int value = int.parse(size.split(' ')[0]);
          return RadioListTile(
            title: Text(size),
            value: value,
            groupValue: screenSize,
            onChanged: (int? value) => setState(() => screenSize = value!),
          );
        }).toList(),
      ],
    );
  }

  Widget buildSwitchListTile(
      String title, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget buildCheckboxListTile(
      String title, bool value, Function(bool?) onChanged) {
    return CheckboxListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget buildDatePicker() {
    return ListTile(
      title: Text('Manufacturing Date'),
      subtitle: Text('${manuDate.toLocal()}'.split(' ')[0]),
      trailing: Icon(Icons.calendar_today),
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: manuDate,
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
        );
        if (picked != null && picked != manuDate) {
          setState(() => manuDate = picked);
        }
      },
    );
  }

  void addLaptop() {
    if (brand.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a brand name')),
      );
      return;
    }

    Laptop newLaptop = Laptop(
      brand: brand,
      cpu: cpu,
      ram: ram,
      weight: weight,
      screenSize: screenSize,
      storage: storage,
      os: os,
      manuDate: manuDate,
    );

    setState(() => laptops.add(newLaptop));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Laptop added successfully!')),
    );
  }
}

class LaptopList extends StatelessWidget {
  final List<Laptop> laptops;

  LaptopList({required this.laptops});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Laptops List', style: TextStyle(color: Colors.white)),
      ),
      body: laptops.isEmpty
          ? Center(child: Text('No laptops added yet'))
          : ListView.builder(
              itemCount: laptops.length,
              itemBuilder: (ctx, index) {
                final laptop = laptops[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(laptop.brand,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('CPU: ${laptop.cpu}, RAM: ${laptop.ram}GB'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        laptops.removeAt(index);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Laptop removed')),
                        );
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
