import 'package:flutter/material.dart';
import '../models/user_model.dart';

class ProfileStats extends StatelessWidget {
  final UserModel user;

  const ProfileStats({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Statistics',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 15),

          Row(
            children: [
             
              Expanded(
                child: _buildStatItem(
                  icon: Icons.calendar_month,
                  value: '${user.appointmentsCount}',
                  label: 'Appointments',
                  color: Colors.blue,
                ),
              ),
              
          
              Expanded(
                child: _buildStatItem(
                  icon: Icons.analytics,
                  value: '${user.scansCount}',
                  label: 'Scans',
                  color: Colors.orange,
                ),
              ),

      
              Expanded(
                child: _buildStatItem(
                  icon: Icons.cake,
                  value: '${user.age}',
                  label: 'Years',
                  color: Colors.purple,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}