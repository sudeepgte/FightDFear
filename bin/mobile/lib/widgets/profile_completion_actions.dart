import 'package:flutter/material.dart';

/// Compact AppBar Skip + Save that stays visible on small phones and large text.
class ProfileCompletionActions {
  static List<Widget> appBar({
    required VoidCallback? onSkip,
    required VoidCallback? onSave,
    bool saving = false,
  }) {
    return [
      FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: onSkip,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: const Size(44, 40),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text('Skip for now', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
            TextButton(
              onPressed: onSave,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                minimumSize: const Size(44, 40),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save', style: TextStyle(fontWeight: FontWeight.w800)),
            ),
            const SizedBox(width: 4),
          ],
        ),
      ),
    ];
  }

  static void skip(BuildContext context, void Function(BuildContext context)? onFinished) {
    if (onFinished != null) {
      onFinished(context);
    } else if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop(false);
    }
  }
}
