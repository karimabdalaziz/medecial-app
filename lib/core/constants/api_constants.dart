class ApiConstants {
  static const String baseUrl = 'https://alivio2.vercel.app';

  // ─── Chatbot API ───────────────────────────────────────────────
  static const String chatBaseUrl = 'https://11amr-arevo-2.hf.space';
  static const String chatSend = '$chatBaseUrl/chat';
  static const String chatNewSession = '$chatBaseUrl/new_session';
  static String chatHistory(String id) => '$chatBaseUrl/history/$id';
  static String chatClear(String id) => '$chatBaseUrl/clear/$id';

  // Medical AI API
  static const String aiBaseUrl = 'https://morefaat69-medical-ai-api.hf.space';
  static const String aiSkin = '$aiBaseUrl/predict/skin';
  static const String aiBreast = '$aiBaseUrl/predict/breast';
  static const String aiEye = '$aiBaseUrl/predict/eye';
  static const String aiBrain = '$aiBaseUrl/predict/brain';
  static const String aiHeart = '$aiBaseUrl/predict/heart';
  static const String aiLung = '$aiBaseUrl/predict/lung';
  static const String aiKidney = '$aiBaseUrl/predict/kidney';

  // Auth
  static const String signupPatient = '$baseUrl/api/v1/users/signup/patient';
  static const String login = '$baseUrl/api/v1/users/login';
  static const String forgotPassword = '$baseUrl/api/v1/users/forgotPassword';
  static String resetPassword(String token) =>
      '$baseUrl/api/v1/users/resetPassword/$token';

  // Current user info
  static const String userMe = '$baseUrl/api/v1/users/me';

  // Update user info (name)
  static const String updateMe = '$baseUrl/api/v1/users/updateMe';

  // Patients
  static const String myProfile = '$baseUrl/api/v1/patients/me';
  static String updatePatient(String id) => '$baseUrl/api/v1/patients/$id';
  static const String medicalHistory =
      '$baseUrl/api/v1/patients/medical-history';

  // Appointments
  static const String myAppointments =
      '$baseUrl/api/v1/appointments/my-appointments';
  static const String bookAppointment = '$baseUrl/api/v1/appointments';
  static String cancelAppointment(String id) =>
      '$baseUrl/api/v1/appointments/$id/cancel';

  // Doctors
  static const String doctors = '$baseUrl/api/v1/doctors';
  static String doctorById(String id) => '$baseUrl/api/v1/doctors/$id';

  // Profile photo
  static const String updatePhoto = '$baseUrl/api/v1/users/updatePhoto';
}
