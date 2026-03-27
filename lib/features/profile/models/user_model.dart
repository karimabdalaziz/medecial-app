
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

  static UserModel get demoUser {
    return UserModel(
      id: '1',
      name: 'Ahmed Magdy',
      email: 'ahmed.magdy@email.com',
      phone: '+20 123 456 7890',
      profileImageUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
      dateOfBirth: DateTime(1995, 5, 15),
      gender: 'Male',
      appointmentsCount: 12,
      scansCount: 8,
    );
  }

  static UserModel get demoUserFemale {
    return UserModel(
      id: '2',
      name: 'Sara Ahmed',
      email: 'sara.ahmed@email.com',
      phone: '+20 123 456 7891',
      profileImageUrl: 'https://randomuser.me/api/portraits/women/44.jpg',
      dateOfBirth: DateTime(1998, 8, 22),
      gender: 'Female',
      appointmentsCount: 8,
      scansCount: 5,
    );
  }
}
