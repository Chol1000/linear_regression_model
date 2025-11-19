import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

void main() {
  runApp(const SalaryPredictionApp());
}

class SalaryPredictionApp extends StatelessWidget {
  const SalaryPredictionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Graduate Salary Predictor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const PredictionScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PredictionScreen extends StatefulWidget {
  const PredictionScreen({super.key});

  @override
  State<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _ageController = TextEditingController();
  final _yearsController = TextEditingController();

  String? _educationLevel;
  String? _fieldOfStudy;
  String? _languageProficiency;
  String? _visaType;
  String? _universityRanking;
  String? _regionOfStudy;

  String _result = '';
  bool _isLoading = false;

  final List<String> _educationLevels = [
    'Diploma',
    "Bachelor's",
    "Master's",
    'PhD'
  ];
  final List<String> _fieldsOfStudy = [
    'Engineering',
    'IT',
    'Business',
    'Health',
    'Arts',
    'Social Sciences'
  ];
  final List<String> _languageProficiencies = [
    'Basic',
    'Intermediate',
    'Fluent',
    'Advanced'
  ];
  final List<String> _visaTypes = [
    'Student',
    'Post-study',
    'Work Visa',
    'Permanent Residency'
  ];
  final List<String> _universityRankings = ['Low', 'Medium', 'High'];

  // CORRECTED: Using REGIONS instead of countries to match training data
  final List<String> _regionsOfStudy = ['UK', 'Canada', 'Australia', 'EU'];

  Future<void> _makePrediction() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _result = '';
    });

    try {
      // Use the live Render API URL
      const String apiUrl = 'https://international-graduates-salary-api.onrender.com/predict';
      
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'education_level': _educationLevel,
          'field_of_study': _fieldOfStudy,
          'language_proficiency': _languageProficiency,
          'visa_type': _visaType,
          'university_ranking': _universityRanking,
          'region_of_study': _regionOfStudy, // CORRECTED: Using region_of_study
          'age': int.parse(_ageController.text),
          'years_since_graduation': int.parse(_yearsController.text),
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _result = '\$${data['predicted_salary'].toStringAsFixed(0)}';
        });
      } else {
        setState(() {
          _result = 'Error: ${response.statusCode} - ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        _result = 'Network Error: Please check connection and API URL';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Graduate Salary Predictor'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(Icons.school, size: 40, color: Colors.blue),
                    SizedBox(height: 8),
                    Text(
                      'International Graduates Employment Prediction',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Empowering Youth Through Data-Driven Career Guidance',
                      style: TextStyle(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            _buildDropdown('Education Level', _educationLevel, _educationLevels,
                (v) => _educationLevel = v),
            _buildDropdown('Field of Study', _fieldOfStudy, _fieldsOfStudy,
                (v) => _fieldOfStudy = v),
            _buildDropdown('Language Proficiency', _languageProficiency,
                _languageProficiencies, (v) => _languageProficiency = v),
            _buildDropdown(
                'Visa Type', _visaType, _visaTypes, (v) => _visaType = v),
            _buildDropdown('University Ranking', _universityRanking,
                _universityRankings, (v) => _universityRanking = v),

            // CORRECTED: Changed from Country to Region to match training data
            _buildDropdown('Region of Study', _regionOfStudy, _regionsOfStudy,
                (v) => _regionOfStudy = v),

            _buildTextField('Age', _ageController, 'Enter age (18-65)'),
            _buildTextField('Years Since Graduation', _yearsController,
                'Enter years (0-40)'),

            const SizedBox(height: 20),

            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _makePrediction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  foregroundColor: Colors.white,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Predict Salary',
                        style: TextStyle(fontSize: 18)),
              ),
            ),

            const SizedBox(height: 20),

            if (_result.isNotEmpty)
              Card(
                color: _result.contains('Error')
                    ? Colors.red[50]
                    : Colors.green[50],
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Icon(
                        _result.contains('Error')
                            ? Icons.error
                            : Icons.attach_money,
                        size: 40,
                        color: _result.contains('Error')
                            ? Colors.red
                            : Colors.green,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _result.contains('Error')
                            ? 'Prediction Error'
                            : 'Predicted Annual Salary',
                        style: TextStyle(
                          fontSize: 16,
                          color: _result.contains('Error')
                              ? Colors.red
                              : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _result,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: _result.contains('Error')
                              ? Colors.red
                              : Colors.green,
                        ),
                      ),
                      if (!_result.contains('Error')) ...[
                        const SizedBox(height: 8),
                        const Text(
                          'Based on Linear Regression Model (88.8% R² Score)',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const Text(
                          'Best Performing Model - Lowest MSE',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, String? value, List<String> items,
      Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        items: [
          DropdownMenuItem(
            value: null,
            child: Text('Select $label',
                style: const TextStyle(color: Colors.grey)),
          ),
          ...items
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
        ],
        onChanged: onChanged,
        validator: (value) => value == null ? 'Please select $label' : null,
      ),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return 'Please enter $label';
          final intValue = int.tryParse(value);
          if (intValue == null) return 'Please enter a valid number';
          if (label == 'Age' && (intValue < 18 || intValue > 65))
            return 'Age must be between 18-65';
          if (label == 'Years Since Graduation' &&
              (intValue < 0 || intValue > 40))
            return 'Years must be between 0-40';
          return null;
        },
      ),
    );
  }
}
