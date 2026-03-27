
import 'package:flutter/material.dart';
import 'package:project/features/auth/loginscreen.dart';
import 'package:project/features/home/shared/appointment_manager.dart';
import '../models/user_model.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_stats.dart';
import '../widgets/profile_menu_item.dart';
import 'edit_profile_screen.dart';
import 'change_password_screen.dart';



class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserModel user;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }


  void _loadUserData() {
   
    UserModel baseUser = UserModel.demoUser;
  
    int realAppointmentsCount = AppointmentManager.getActiveAppointmentsCount();
    
    
    
    int realScansCount = 5;
    
    user = UserModel(
      id: baseUser.id,
      name: baseUser.name,
      email: baseUser.email,
      phone: baseUser.phone,
      profileImageUrl: baseUser.profileImageUrl,
      dateOfBirth: baseUser.dateOfBirth,
      gender: baseUser.gender,
      appointmentsCount: realAppointmentsCount,
      scansCount: realScansCount, 
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
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
             
              ProfileHeader(
                user: user,
                onEditPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfileScreen(user: user),
                    ),
                  );
                  
                  if (result != null) {
                    setState(() {
                      user = UserModel(
                        id: user.id,
                        name: result['name'] ?? user.name,
                        email: result['email'] ?? user.email,
                        phone: result['phone'] ?? user.phone,
                        profileImageUrl: user.profileImageUrl,
                        dateOfBirth: result['dob'] ?? user.dateOfBirth,
                        gender: result['gender'] ?? user.gender,
                        appointmentsCount: user.appointmentsCount, 
                        scansCount: user.scansCount, // 
                      );
                    });
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Profile updated successfully!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
              ),
              SizedBox(height: 20),

             
              ProfileStats(user: user),
              SizedBox(height: 25),

             
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
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
                
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Icon(Icons.settings, color: Colors.grey[700]),
                          SizedBox(width: 10),
                          const Text(
                            'Settings',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
     
                    ProfileMenuItem(
                      icon: Icons.person_outline,
                      title: 'Edit Profile',
                      subtitle: 'Change your personal information',
                      iconColor: Colors.blue,
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfileScreen(user: user),
                          ),
                        );
                        
                        if (result != null) {
                          setState(() {
                            user = UserModel(
                              id: user.id,
                              name: result['name'] ?? user.name,
                              email: result['email'] ?? user.email,
                              phone: result['phone'] ?? user.phone,
                              profileImageUrl: user.profileImageUrl,
                              dateOfBirth: result['dob'] ?? user.dateOfBirth,
                              gender: result['gender'] ?? user.gender,
                              appointmentsCount: user.appointmentsCount,
                              scansCount: user.scansCount,
                            );
                          });
                        }
                      },
                    ),

                    ProfileMenuItem(
                      icon: Icons.lock_outline,
                      title: 'Change Password',
                      subtitle: 'Update your password regularly',
                      iconColor: Colors.purple,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChangePasswordScreen(),
                          ),
                        );
                      },
                    ),

                  
                    ProfileMenuItem(
                      icon: Icons.language,
                      title: 'Language',
                      subtitle: 'English (US)',
                      iconColor: Colors.teal,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Language feature coming soon'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25),

          
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Logout'),
                        content: Text('Are you sure you want to logout?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'Cancel',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                                (route) => false,
                              );
                            },
                            child: Text(
                              'Logout',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.withOpacity(0.1),
                    foregroundColor: Colors.red,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 18),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout),
                      SizedBox(width: 10),
                      Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}