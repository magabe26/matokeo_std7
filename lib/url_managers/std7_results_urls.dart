import 'package:matokeo_core/matokeo_core.dart' show Urls;

String getBaseUrl(String url, {bool isSd7PsleUrl = false}) {
  return Urls.getBaseUrl(url, baseUrlFinalizer: (baseUrl) {
    if (url.contains('necta.go.tz') && isSd7PsleUrl) {
      return '${baseUrl}results/';
    } else {
      return baseUrl;
    }
  });
}
