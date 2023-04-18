import 'package:flutter/material.dart' show BuildContext;
import 'package:url_launcher/url_launcher.dart'
    show launchUrl, LaunchMode, WebViewConfiguration;

void navigateToArticle(BuildContext context, String articleUrl) async {
  try {
    await launchUrl(
      Uri.parse(articleUrl),
      mode: LaunchMode.inAppWebView,
      webViewConfiguration: const WebViewConfiguration(
        enableDomStorage: true,
        enableJavaScript: true,
      ),
    );
  } catch (e) {
    rethrow;
  }
}
