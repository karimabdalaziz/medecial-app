class Appointment {
  final String id;
  final String doctorName;
  final String specialty;
  final String date;
  final String time;
  final String clinic;
  final String reason;
  final String status;
  final DateTime createdAt;

  Appointment({
    required this.id,
    required this.doctorName,
    required this.specialty,
    required this.date,
    required this.time,
    required this.clinic,
    required this.reason,
    this.status = 'confirmed',
    required this.createdAt,
  });
}