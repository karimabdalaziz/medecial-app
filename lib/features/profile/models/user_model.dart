class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? profileImageUrl;
  final DateTime dateOfBirth;
  final String gender;
  final int appointmentsCount;
  final int scansCount;
  final String bloodType;
  final String address;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.profileImageUrl,
    required this.dateOfBirth,
    required this.gender,
    required this.appointmentsCount,
    required this.scansCount,
    this.bloodType = '',
    this.address = '',
  });

  int get age {
    final now = DateTime.now();
    int age = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }
}
