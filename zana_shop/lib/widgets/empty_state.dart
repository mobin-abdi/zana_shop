import 'package:flutter/material.dart';
import 'package:zana_shop/theme/light_theme.dart';

class EmptyState extends StatelessWidget {
  final String message;
  final IconData icon;
  final VoidCallback? onRetry;

  const EmptyState({
    super.key,
    required this.message,
    this.icon = Icons.shopping_basket_outlined, // آیکون پیش‌فرض
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: AppColors.darkGrey),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(fontSize: 18, color: AppColors.textMain),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 24),
            TextButton(
              onPressed: onRetry,
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Try Again"),
                  SizedBox(width: 8),
                  Icon(Icons.refresh),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}