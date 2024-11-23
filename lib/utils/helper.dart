class Helper {
  static String formatCurrency(int amount) {
    // Format the number with colon as the thousands separator
    final formattedNumber = amount.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (Match match) => '${match[1]},',
        );

    // Append the VND currency symbol
    return '$formattedNumber ₫';
  }
}
