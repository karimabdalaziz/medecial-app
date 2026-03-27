import 'package:flutter/material.dart';
import 'shared/appointment_manager.dart';


class BookAppointmentScreen extends StatefulWidget {
  final String doctorName;
  final String specialty;
  final double rating;
  final int reviews;
  final String? hospital;

  BookAppointmentScreen({
    required this.doctorName,
    required this.specialty,
    this.rating = 4.8,
    this.reviews = 320,
    this.hospital = 'Seattle Medical',
  });

  @override
  _BookAppointmentScreenState createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  DateTime _selectedDate = DateTime.now().add(Duration(days: 7));
  int _selectedSlotIndex = -1;
  TextEditingController _reasonController = TextEditingController();

  List<Map<String, dynamic>> availableSlots = [
    {'date': 'Nov 02, 2026', 'time': '02:30 PM', 'clinic': 'Smile Clinic, 123 Main St'},
    {'date': 'Nov 03, 2026', 'time': '10:00 AM', 'clinic': 'Health Center, 456 Oak St'},
    {'date': 'Nov 04, 2026', 'time': '03:45 PM', 'clinic': 'Smile Clinic, 123 Main St'},
    {'date': 'Nov 05, 2026', 'time': '12:30 PM', 'clinic': 'Smile Clinic, 123 Main St'},
  ];

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2027, 12, 31),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF4A6FFF),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _selectedSlotIndex = -1;
      });
    }
  }

  void _showSlotDetails(Map<String, dynamic> slot) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(' Appointment Details', style: TextStyle(color: Color(0xFF4A6FFF))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date: ${slot['date']}', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Time: ${slot['time']}', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Clinic: ${slot['clinic']}'),
            SizedBox(height: 8),
            Text('Doctor: ${widget.doctorName}'),
            SizedBox(height: 8),
            Text('Specialty: ${widget.specialty}'),
            SizedBox(height: 8),
            Text('Hospital: ${widget.hospital}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: TextStyle(color: Color(0xFF4A6FFF))),
          ),
        ],
      ),
    );
  }

  void _cancelSlot(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(' Cancel Appointment', style: TextStyle(color: Colors.red)),
        content: Text('Are you sure you want to cancel this appointment slot?\n\n${availableSlots[index]['date']} • ${availableSlots[index]['time']}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('No', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                availableSlots.removeAt(index);
                if (_selectedSlotIndex == index) {
                  _selectedSlotIndex = -1;
                } else if (_selectedSlotIndex > index) {
                  _selectedSlotIndex--;
                }
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Appointment slot cancelled successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text('Yes, Cancel'),
          ),
        ],
      ),
    );
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
          'Book Appointment',
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
            //doctooooooor 
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.blue.withOpacity(0.1),
                      child: Icon(Icons.person, size: 35, color: Colors.blue),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.doctorName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            '${widget.specialty} • ${widget.hospital}',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber, size: 16),
                              SizedBox(width: 5),
                              Text('${widget.rating}'),
                              SizedBox(width: 5),
                              Text(
                                '| ${widget.reviews} reviews',
                                style: TextStyle(color: Colors.grey[600], fontSize: 13),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25),
//data selaction
              Text('Select Date', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              GestureDetector(
                onTap: _selectDate,
                child: Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                        style: TextStyle(fontSize: 16),
                      ),
                      Icon(Icons.calendar_today, color: Color(0xFF4A6FFF)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Selected: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                style: TextStyle(color: Color(0xFF4A6FFF), fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 25),

              Text('Available Slots', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 15),
              availableSlots.isEmpty
                  ? Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Center(
                        child: Text(
                          'No available slots for selected date',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    )
                  : Column(
                      children: availableSlots.asMap().entries.map((entry) {
                        int index = entry.key;
                        Map<String, dynamic> slot = entry.value;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedSlotIndex = index),
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10),
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: _selectedSlotIndex == index ? Color(0xFF4A6FFF).withOpacity(0.1) : Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: _selectedSlotIndex == index ? Color(0xFF4A6FFF) : Colors.grey[200]!,
                                width: _selectedSlotIndex == index ? 2 : 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('${slot['date']} • ${slot['time']}', 
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.green.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text('Available', 
                                        style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.w600)),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Text(slot['clinic'], style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                                SizedBox(height: 10),
                            
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    OutlinedButton.icon(
                                      onPressed: () {
                                        _showSlotDetails(slot);
                                      },
                                      icon: Icon(Icons.info_outline, size: 16),
                                      label: Text('Details'),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Color(0xFF4A6FFF),
                                        side: BorderSide(color: Color(0xFF4A6FFF)),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      ),
                                    ),
                                    OutlinedButton.icon(
                                      onPressed: () {
                                        _cancelSlot(index);
                                      },
                                      icon: Icon(Icons.cancel_outlined, size: 16),
                                      label: Text('Cancel'),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.red,
                                        side: BorderSide(color: Colors.red),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
              SizedBox(height: 25),

              // Reason for Visit
              Text('Reason for Visit', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: TextField(
                  controller: _reasonController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Describe your symptoms...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey[500]),
                  ),
                ),
              ),
              SizedBox(height: 30),

              // Confirm Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _confirmBooking,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4A6FFF),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    padding: EdgeInsets.symmetric(vertical: 18),
                  ),
                  child: Text('Confirm Booking', 
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmBooking() {
    if (_selectedSlotIndex == -1) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('⚠️ Warning'),
          content: Text('Please select an appointment slot'),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('OK'))],
        ),
      );
      return;
    }

    if (_reasonController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('⚠️ Warning'),
          content: Text('Please enter reason for visit'),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('OK'))],
        ),
      );
      return;
    }
// هحفط الميعاد في class appoiment manger 
    AppointmentManager.addAppointment(
      doctorName: widget.doctorName,
      specialty: widget.specialty,
      date: availableSlots[_selectedSlotIndex]['date'],
      time: availableSlots[_selectedSlotIndex]['time'],
      clinic: availableSlots[_selectedSlotIndex]['clinic'],
      reason: _reasonController.text,
    );

 
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('✅ Booking Confirmed!', style: TextStyle(color: Colors.green)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Appointment booked with:'),
            SizedBox(height: 5),
            Text(widget.doctorName, style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('Date: ${availableSlots[_selectedSlotIndex]['date']}'),
            Text('Time: ${availableSlots[_selectedSlotIndex]['time']}'),
            Text('Clinic: ${availableSlots[_selectedSlotIndex]['clinic']}'),
            SizedBox(height: 10),
            Text('Reason: ${_reasonController.text}'),
            SizedBox(height: 15),
            Text('You can view it in "My Appointments"'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); 
              Navigator.pop(context); 
            },
            child: Text('OK', style: TextStyle(color: Color(0xFF4A6FFF))),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }
}