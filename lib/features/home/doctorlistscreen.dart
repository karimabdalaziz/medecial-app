import 'package:flutter/material.dart';
import 'package:project/features/home/bookappointmrntscreen.dart';

class FindDoctorScreen extends StatefulWidget {
  @override
  _FindDoctorScreenState createState() => _FindDoctorScreenState();
}

class _FindDoctorScreenState extends State<FindDoctorScreen> {
  int _selectedCategory = 0;
  List<String> categories = [
    'All',
    'Brain tumor',
    'Skin Cancer',
    'Chest diseases',
    'Cardiologist',
    'General',
  ];

  List<Map<String, dynamic>> allDoctors = [
    {
      'name': 'Dr. Ahmed Refaat',
      'specialty': 'Skin Cancer',
      'hospital': 'St. Mary\'s Hospital',
      'icon': Icons.local_hospital,
      'category': 'Skin Cancer',
    },
    {
      'name': 'Dr. Rimaa Taha',
      'specialty': 'Brain Tumor',
      'hospital': 'Dental Care Clinic',
      'icon': Icons.medical_services,
      'category': 'Brain tumor',
    },
    {
      'name': 'Dr. Karim Abdelaziz',
      'specialty': 'Cardiologist',
      'hospital': 'Heart Center',
      'icon': Icons.favorite,
      'category': 'Cardiologist',
    },
    {
      'name': 'Dr. Sarah Refaat',
      'specialty': 'Chest diseases',
      'hospital': 'Healthy Life Clinic',
      'icon': Icons.health_and_safety,
      'category': 'Chest diseases',
    },
    {
      'name': 'Dr. Mohamed Yasser',
      'specialty': 'General Practitioner',
      'hospital': 'City Medical Center',
      'icon': Icons.person,
      'category': 'General',
    },
    {
      'name': 'Dr. Rahma omar',
      'specialty': 'Pediatrician',
      'hospital': 'Children\'s Hospital',
      'icon': Icons.child_care,
      'category': 'General',
    },
    {
      'name': 'Dr. Ali Ayman',
      'specialty': 'Orthopedic Surgeon',
      'hospital': 'Bone & Joint Center',
      'icon': Icons.accessible,
      'category': 'General',
    },
  ];

  // دالة ترجع الدكاترة بناء على التصنيف المختار
  List<Map<String, dynamic>> get filteredDoctors {
    if (_selectedCategory == 0) {
      return allDoctors; 
    } else {
      String selectedCategory = categories[_selectedCategory];
      return allDoctors
          .where((doctor) => doctor['category'] == selectedCategory)
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Find a Doctor',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey[500]),
                    SizedBox(width: 10),
                    Text(
                      'Search doctor, specialty...',
                      style: TextStyle(color: Colors.grey[500], fontSize: 16),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Categories
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: categories.map((category) {
                    int index = categories.indexOf(category);
                    return Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategory = index;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: _selectedCategory == index
                                ? Color(0xFF4A6FFF)
                                : Colors.grey[100],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            category,
                            style: TextStyle(
                              color: _selectedCategory == index
                                  ? Colors.white
                                  : Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 25),

              // Doctors Count
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  '${filteredDoctors.length} Doctors Found',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ),

              // Doctors List
              Column(
                children: filteredDoctors.map((doctor) {
                  return _buildDoctorCard(
                    doctor['name'],
                    doctor['specialty'],
                    doctor['hospital'],
                    doctor['icon'],
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorCard(
    String name,
    String specialty,
    String hospital,
    IconData icon,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DoctorProfileScreen(doctorName: name, specialty: specialty),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: Colors.blue, size: 30),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        specialty,
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        hospital,
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookAppointmentScreen(
                        doctorName: name,
                        specialty: specialty,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF4A6FFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(
                  'Book Appointment',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Doctor Profile Screen
class DoctorProfileScreen extends StatefulWidget {
  final String doctorName;
  final String specialty;

  DoctorProfileScreen({required this.doctorName, required this.specialty});

  @override
  _DoctorProfileScreenState createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  int _selectedDayIndex = 0;
  int _selectedTimeIndex = -1;

  List<String> days = ['Wed: 14', 'Thu: 15', 'Fri: 16', 'Sat: 17', 'Sun: 18'];
  List<String> morningTimes = ['09:00 AM', '10:00 AM', '11:30 AM'];
  List<String> afternoonTimes = ['02:00 PM', '03:30 PM', '04:00 PM'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Doctor Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Doctor Header Card
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey[300],
                          child: Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.doctorName,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                widget.specialty,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 18,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    '4.8',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    '| 320 Reviews',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildActionButton(Icons.phone, 'Call', Colors.blue),
                        _buildActionButton(
                          Icons.message,
                          'Message',
                          Colors.green,
                        ),
                        _buildActionButton(
                          Icons.location_on,
                          'Directions',
                          Colors.red,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25),

              // About Doctor
              Text(
                'About Doctor',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                '',// مستنيين نكتب ايه هنا عن الدكتور 
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Read More',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 25),

              // Schedules
              Text(
                'Schedules',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(days.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedDayIndex = index;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 10),
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: _selectedDayIndex == index
                              ? Color(0xFF4A6FFF)
                              : Colors.grey[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          days[index],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: _selectedDayIndex == index
                                ? Colors.white
                                : Colors.grey[700],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(height: 25),

              // Morning Times
              Text(
                'Morning',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: List.generate(morningTimes.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedTimeIndex = index;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: _selectedTimeIndex == index
                            ? Color(0xFF4A6FFF)
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: _selectedTimeIndex == index
                              ? Color(0xFF4A6FFF)
                              : Colors.grey[300]!,
                        ),
                      ),
                      child: Text(
                        morningTimes[index],
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: _selectedTimeIndex == index
                              ? Colors.white
                              : Colors.grey[700],
                        ),
                      ),
                    ),
                  );
                }),
              ),
              SizedBox(height: 20),

              // Afternoon Times
              Text(
                'Afternoon',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: List.generate(afternoonTimes.length, (index) {
                  int afternoonIndex = index + morningTimes.length;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedTimeIndex = afternoonIndex;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: _selectedTimeIndex == afternoonIndex
                            ? Color(0xFF4A6FFF)
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: _selectedTimeIndex == afternoonIndex
                              ? Color(0xFF4A6FFF)
                              : Colors.grey[300]!,
                        ),
                      ),
                      child: Text(
                        afternoonTimes[index],
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: _selectedTimeIndex == afternoonIndex
                              ? Colors.white
                              : Colors.grey[700],
                        ),
                      ),
                    ),
                  );
                }),
              ),
              SizedBox(height: 30),

              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Price',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            '200 EGP',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookAppointmentScreen(
                                doctorName: widget.doctorName,
                                specialty: widget.specialty,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF4A6FFF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 18),
                        ),
                        child: Text(
                          'Book Appointment',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}
