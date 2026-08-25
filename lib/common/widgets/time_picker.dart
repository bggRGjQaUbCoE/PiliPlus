import 'package:material_ui/material_ui.dart' as material;

Future<material.TimeOfDay?> showTimePicker({
  required material.BuildContext context,
  required material.TimeOfDay initialTime,
}) => material.showTimePicker(
  context: context,
  initialTime: initialTime,
  builder: (context, child) => material.DialogTheme(
    data: material.DialogTheme.of(
      context,
    ).copyWith(constraints: const material.BoxConstraints(minWidth: 280)),
    child: child,
  ),
);
