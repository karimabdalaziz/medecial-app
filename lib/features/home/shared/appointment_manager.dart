class AppointmentManager {
  static List<Map<String, dynamic>> appointments = [];

  // Function to add a new appointment
  static void addAppointment({
    required String doctorName,
    required String specialty,
    required String date,
    required String time,
    required String clinic,
    required String reason,
  }) {
    appointments.add({
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'doctorName': doctorName,
      'specialty': specialty,
      'date': date,
      'time': time,
      'clinic': clinic,
      'reason': reason,
      'status': 'confirmed',
    });

    print('📅 Appointment added. Total: ${appointments.length}'); // للتتبع
  }

  // Function that gets upcoming appointments
  static List<Map<String, dynamic>> getUpcomingAppointments() {
    return appointments.where((app) => app['status'] == 'confirmed').toList();
  }

  // Function that gets past appointments
  static List<Map<String, dynamic>> getPastAppointments() {
    return appointments.where((app) => app['status'] != 'confirmed').toList();
  }

  // New function: total appointments count
  static int getTotalAppointmentsCount() {
    return appointments.length;
  }

  // New function: number of active appointments (Confirmed)
  static int getActiveAppointmentsCount() {
    return appointments.where((app) => app['status'] == 'confirmed').length;
  }

  // New function: number of canceled appointments
  static int getInactiveAppointmentsCount() {
    return appointments.where((app) => app['status'] != 'confirmed').length;
  }
}
