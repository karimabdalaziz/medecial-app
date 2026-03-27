import 'package:flutter/material.dart';
import 'package:project/features/home/bookappointmrntscreen.dart';
import 'shared/appointment_manager.dart';


class Myappoimentscreen extends StatefulWidget {
  const Myappoimentscreen({Key? key}) : super(key: key);

  @override
  _AppointmentsScreenState createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<Myappoimentscreen> {
  @override
  Widget build(BuildContext context) {
    final upcoming = AppointmentManager.getUpcomingAppointments();
    final past = AppointmentManager.getPastAppointments();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text('My Appointments', 
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20)),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Color(0xFF4A6FFF),
            labelColor: Color(0xFF4A6FFF),
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'Upcoming (${upcoming.length})'),
              Tab(text: 'Past (${past.length})'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
           
            _buildAppointmentsList(upcoming),
            
            _buildAppointmentsList(past),
          ],
        ),

      ),
    );
  }

  Widget _buildAppointmentsList(List<Map<String, dynamic>> appointments) {
    if (appointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today, size: 80, color: Colors.grey[300]),
            SizedBox(height: 20),
            Text('No appointments yet', 
              style: TextStyle(color: Colors.grey[500], fontSize: 16)),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookAppointmentScreen(
                      doctorName: 'Select Doctor',
                      specialty: 'General',
                    ),
                  ),
                );
              },
              child: Text('Book your first appointment',
                style: TextStyle(color: Color(0xFF4A6FFF), fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        return Card(
          margin: EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Color(0xFF4A6FFF).withOpacity(0.1),
              child: Icon(Icons.person, color: Color(0xFF4A6FFF)),
            ),
            title: Text(appointment['doctorName'] ?? 'Doctor'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${appointment['date']} • ${appointment['time']}'),
                Text(appointment['clinic'] ?? 'Clinic', 
                  style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                if (appointment['reason'] != null && appointment['reason'].isNotEmpty)
                  Text('Reason: ${appointment['reason']}', 
                    style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              ],
            ),
            trailing: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: appointment['status'] == 'confirmed' 
                  ? Colors.green.withOpacity(0.1) 
                  : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                appointment['status']?.toUpperCase() ?? 'PENDING',
                style: TextStyle(
                  color: appointment['status'] == 'confirmed' ? Colors.green : Colors.red,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Appointment Details'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Doctor: ${appointment['doctorName']}'),
                      Text('Date: ${appointment['date']}'),
                      Text('Time: ${appointment['time']}'),
                      Text('Clinic: ${appointment['clinic']}'),
                      Text('Reason: ${appointment['reason'] ?? 'Not specified'}'),
                      Text('Status: ${appointment['status']?.toUpperCase()}'),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}