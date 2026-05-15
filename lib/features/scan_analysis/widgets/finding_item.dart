import 'package:flutter/material.dart';

class FindingItem extends StatelessWidget {
  final String finding;

  const FindingItem({Key? key, required this.finding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Icon(Icons.check_circle, color: Colors.green, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(finding,
                style: TextStyle(
                    fontSize: 14, color: Colors.grey[700], height: 1.5)),
          ),
        ],
      ),
    );
  }
}
