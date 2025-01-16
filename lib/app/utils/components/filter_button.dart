import 'package:flutter/material.dart';
import 'package:asset_tree/app/utils/colors.dart';

class FilterButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onPressed;

  const FilterButton({
    Key? key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: isSelected ? CustomColors.primary : CustomColors.primary,
        ),
        backgroundColor: isSelected ? CustomColors.primary : Colors.transparent,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.white : CustomColors.primary,
          ),
          SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : CustomColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
