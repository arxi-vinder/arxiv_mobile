class ErrorHandler {
  static String getErrorMessage(dynamic error) {
    final errorString = error.toString();

    if (errorString.contains('Connection refused')) {
      return 'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.';
    }

    if (errorString.contains('timeout') ||
        errorString.contains('TimeoutException')) {
      return 'Koneksi timeout. Server tidak merespons. Coba lagi dalam beberapa saat.';
    }

    if (errorString.contains('Connection refused') ||
        errorString.contains('refused')) {
      return 'Koneksi ditolak. Periksa koneksi internet Anda.';
    }

    if (errorString.contains('SocketException') ||
        errorString.contains('network')) {
      return 'Error jaringan. Periksa koneksi internet Anda.';
    }

    if (errorString.contains('Failed to fetch')) {
      return 'Gagal mengambil data. Silakan coba lagi.';
    }

    if (errorString.contains('Unauthorized')) {
      return 'Sesi Anda telah berakhir. Silakan login kembali.';
    }

    if (errorString.contains('Forbidden')) {
      return 'Akses ditolak. Anda tidak memiliki izin untuk mengakses resource ini.';
    }

    if (errorString.contains('Not found') || errorString.contains('404')) {
      return 'Data tidak ditemukan.';
    }

    if (errorString.contains('Server error') ||
        errorString.contains('500') ||
        errorString.contains('502') ||
        errorString.contains('503')) {
      return 'Server sedang mengalami masalah. Silakan coba lagi nanti.';
    }

    // Default message
    return 'Terjadi kesalahan. Silakan coba lagi.';
  }

  static bool isNetworkError(dynamic error) {
    final errorString = error.toString();
    return errorString.contains('SocketException') ||
        errorString.contains('timeout') ||
        errorString.contains('TimeoutException') ||
        errorString.contains('Connection refused') ||
        errorString.contains('network');
  }
}
