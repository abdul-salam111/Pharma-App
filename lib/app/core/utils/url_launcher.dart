import 'package:url_launcher/url_launcher.dart';

void launchCaller(String phoneNumber) async {
  var _url = Uri.parse("tel:$phoneNumber");
  if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
    throw Exception('Could not launch $_url');
  }
}
