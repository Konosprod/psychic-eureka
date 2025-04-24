import 'package:flutter/material.dart';

class CheckedButtonProgressWidget extends StatelessWidget {
  final bool isChecked;

  const CheckedButtonProgressWidget({
    required this.isChecked,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      margin: EdgeInsets.fromLTRB(0, 20, 20, 0),
      decoration: BoxDecoration(
        color: isChecked
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.secondaryContainer,
        shape: BoxShape.circle,
      ),
      child: isChecked
          ? Center(
              child: Icon(
                Icons.check,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            )
          : null,
    );
  }
}
