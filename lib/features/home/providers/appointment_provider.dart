import 'package:flutter/foundation.dart';
import 'package:project/features/home/model/appointment_model.dart';

class AppointmentProvider with ChangeNotifier {
  List<Appointment> _appointments = [];

  List<Appointment> get appointments => _appointments;

  List<Appointment> get upcomingAppointments {
    return _appointments.where((app) => app.status == 'confirmed').toList();
  }

  List<Appointment> get pastAppointments {
    return _appointments.where((app) => app.status != 'confirmed').toList();
  }

  void addAppointment(Appointment appointment) {
    _appointments.insert(0, appointment);
    notifyListeners();
  }

  void cancelAppointment(String id) {
    final index = _appointments.indexWhere((app) => app.id == id);
    if (index != -1) {
      _appointments[index] = Appointment(
        id: _appointments[index].id,
        doctorName: _appointments[index].doctorName,
        specialty: _appointments[index].specialty,
        date: _appointments[index].date,
        time: _appointments[index].time,
        clinic: _appointments[index].clinic,
        reason: _appointments[index].reason,
        status: 'cancelled',
        createdAt: _appointments[index].createdAt,
      );
      notifyListeners();
    }
  }
}