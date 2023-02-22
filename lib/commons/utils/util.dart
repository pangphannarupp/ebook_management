// import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class Util {

  // static void loadUrl(String url) async {
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  static String leftPad(int number, int targetLength) {
    String output = number.toString();
    while (output.length < targetLength) {
      output = '0' + output;
    }
    return output;
  }

  static bool isNight() {
    var hour = DateTime.now().hour;
    if (hour < 18) {
      return false;
    }
    return true;
  }

  static String numberFormat(int number) {
    return NumberFormat.compactCurrency(
      decimalDigits: 0,
      symbol: '', // if you want to add currency symbol then pass that in this else leave it empty.
    ).format(number);
  }
}