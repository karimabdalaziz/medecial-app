// lib/features/profile/widgets/profile_menu_item.dart

import 'package:flutter/material.dart';

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Color iconColor;
  final VoidCallback? onTap;
  final bool showDivider;
  final bool isSwitch;
  final bool? switchValue;
  final Function(bool)? onSwitchChanged;

  const ProfileMenuItem({
    Key? key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.iconColor = const Color(0xFF4A6FFF),
    this.onTap,
    this.showDivider = true,
    this.isSwitch = false,
    this.switchValue,
    this.onSwitchChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          title: Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          subtitle: subtitle != null
              ? Text(
                  subtitle!,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                )
              : null,
          trailing: isSwitch
              ? Switch(
                  value: switchValue ?? false,
                  onChanged: (newValue) {
                    if (onSwitchChanged != null) {
                      onSwitchChanged!(newValue);
                    }
                  },
                  activeColor: iconColor,
                  activeTrackColor: iconColor.withOpacity(0.3),
                )
              : Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey[400],
                ),
          onTap: isSwitch ? null : onTap,
        ),
        if (showDivider)
          Divider(height: 1, thickness: 1, indent: 60, color: Colors.grey[100]),
      ],
    );
  }
}
