import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUtils {
  static String formatCurrency(num amount) {
    if (amount <= 0) return 'N/A';
    if (amount >= 1000000000) {
      return '\$${(amount / 1000000000).toStringAsFixed(1)}B';
    } else if (amount >= 1000000) {
      return '\$${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '\$${(amount / 1000).toStringAsFixed(1)}K';
    }
    final format = NumberFormat.currency(
      locale: 'en_US',
      symbol: '\$',
      decimalDigits: 0,
    );
    return format.format(amount);
  }

  static String formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'Release date unknown';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat.yMMMMd('en_US').format(date);
    } catch (_) {
      return dateStr;
    }
  }

  static Future<bool> launchUrlStringSafe(String urlString) async {
    final uri = Uri.tryParse(urlString);
    if (uri == null) return false;

    try {
      // 1. Try launching externally (e.g. YouTube app or default browser)
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (launched) return true;
    } catch (_) {
      // Fallback
    }

    try {
      // 2. Fallback to platform default
      return await launchUrl(uri, mode: LaunchMode.platformDefault);
    } catch (_) {
      return false;
    }
  }
}
