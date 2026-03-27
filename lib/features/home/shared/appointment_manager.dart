
class AppointmentManager {
  static List<Map<String, dynamic>> appointments = [];
  
  //  دالة لإضافة موعد جديد
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
  
  //  دالة تجيب  المواعيد القادمة
  static List<Map<String, dynamic>> getUpcomingAppointments() {
    return appointments.where((app) => app['status'] == 'confirmed').toList();
  }
  
  //  دالة تجيب المواعيد السابقة
  static List<Map<String, dynamic>> getPastAppointments() {
    return appointments.where((app) => app['status'] != 'confirmed').toList();
  }
  
  //  دالة جديدة: عدد المواعيد الكلي
  static int getTotalAppointmentsCount() {
    return appointments.length;
  }
  
  // دالة جديدة: عدد المواعيد النشطة (Confirmed)
  static int getActiveAppointmentsCount() {
    return appointments.where((app) => app['status'] == 'confirmed').length;
  }
  
  // دالة جديدة: عدد المواعيد الي اتلغت 
  static int getInactiveAppointmentsCount() {
    return appointments.where((app) => app['status'] != 'confirmed').length;
  }
}