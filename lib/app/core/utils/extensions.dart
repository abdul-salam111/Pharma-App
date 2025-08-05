import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
//////////////////////////////////// DATE EXTENSION/////////////////////////////////////////

  // Check if the date is today
  bool isToday() {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  // Check if the date is in the past
  bool isPast() => isBefore(DateTime.now());

  // Check if the date is in the future
  bool isFuture() => isAfter(DateTime.now());

  // Format the date as "dd-MM-yyyy"
  String formatDate() {
    return "${day.toString().padLeft(2, '0')}-${month.toString().padLeft(2, '0')}-$year";
  }

  // Format the date as "yyyy-MM-dd" (ISO format)
  String formatISODate() {
    return "$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}";
  }

  // Format the date and time as "dd-MM-yyyy HH:mm"
  String formatDateTime() {
    return "${day.toString().padLeft(2, '0')}-${month.toString().padLeft(2, '0')}-$year ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";
  }

  // Get the age based on the date
  int getAge() {
    final now = DateTime.now();
    int age = now.year - year;
    if (now.month < month || (now.month == month && now.day < day)) {
      age--;
    }
    return age;
  }

  // Get the difference in days between this date and another date
  int differenceInDays(DateTime other) {
    return DateTime(year, month, day)
        .difference(DateTime(other.year, other.month, other.day))
        .inDays;
  }

  // Get the difference in months between this date and another date
  int differenceInMonths(DateTime other) {
    return (year - other.year) * 12 + (month - other.month);
  }

  // Get the difference in years between this date and another date
  int differenceInYears(DateTime other) {
    return year - other.year;
  }

  // Add a specific number of days to the date
  DateTime addDays(int days) {
    return add(Duration(days: days));
  }

  // Subtract a specific number of days from the date
  DateTime subtractDays(int days) {
    return subtract(Duration(days: days));
  }

  // Get the start of the day (00:00:00)
  DateTime startOfDay() {
    return DateTime(year, month, day);
  }

  // Get the end of the day (23:59:59)
  DateTime endOfDay() {
    return DateTime(year, month, day, 23, 59, 59);
  }

  // Check if the date is a weekend
  bool isWeekend() {
    return weekday == DateTime.saturday || weekday == DateTime.sunday;
  }

  // Check if the date is a weekday
  bool isWeekday() {
    return !isWeekend();
  }

  // Get the name of the day (e.g., Monday, Tuesday)
  String get dayName {
    const days = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday"
    ];
    return days[weekday - 1];
  }

  // Get the name of the month (e.g., January, February)
  String get monthName {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    return months[month - 1];
  }
}

/////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////  WIDGETS EXTENSIONS ////////////////////////////////////////
extension WidgetExtensions on Widget {
  // Add padding to a widget
  Widget withPadding(EdgeInsets padding) {
    return Padding(padding: padding, child: this);
  }

  // Add margin to a widget
  Widget withMargin(EdgeInsets margin) {
    return Container(margin: margin, child: this);
  }

  // Conditionally show a widget
  Widget showIf(bool condition) {
    return condition ? this : const SizedBox.shrink();
  }

  // Add a gesture detector (e.g., onTap)
  Widget onTap(VoidCallback onTap, {bool opaque = true}) {
    return GestureDetector(
      onTap: onTap,
      behavior: opaque ? HitTestBehavior.opaque : HitTestBehavior.deferToChild,
      child: this,
    );
  }

  // Center a widget
  Widget center() {
    return Center(child: this);
  }

  // Add a border to a widget
  Widget withBorder(
      {Color color = Colors.black,
      double width = 1.0,
      BorderRadius? borderRadius}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: color, width: width),
        borderRadius: borderRadius,
      ),
      child: this,
    );
  }

  // Add a background color to a widget
  Widget withBackground(Color color, {BorderRadius? borderRadius}) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius,
      ),
      child: this,
    );
  }

  // Add a shadow to a widget
  Widget withShadow({
    Color color = Colors.black,
    double blurRadius = 5.0,
    Offset offset = Offset.zero,
    double spreadRadius = 0.0,
  }) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: blurRadius,
            offset: offset,
            spreadRadius: spreadRadius,
          ),
        ],
      ),
      child: this,
    );
  }

  // Add a tooltip to a widget
  Widget withTooltip(String message, {Decoration? decoration, double? height}) {
    return Tooltip(
      message: message,
      decoration: decoration, constraints: BoxConstraints(minHeight: height!),
      child: this,
    );
  }

  // Wrap a widget in a SizedBox with a specific width and height
  Widget withSize({double? width, double? height}) {
    return SizedBox(
      width: width,
      height: height,
      child: this,
    );
  }

  // Wrap a widget in an Expanded widget
  Widget expanded({int flex = 1}) {
    return Expanded(flex: flex, child: this);
  }

  // Wrap a widget in a Flexible widget
  Widget flexible({int flex = 1, FlexFit fit = FlexFit.loose}) {
    return Flexible(flex: flex, fit: fit, child: this);
  }

  // Add a hero animation to a widget
  Widget withHero({required String tag}) {
    return Hero(tag: tag, child: this);
  }

  // Add a rotation to a widget
  Widget withRotation(double angle, {Offset? origin}) {
    return Transform.rotate(
      angle: angle,
      origin: origin,
      child: this,
    );
  }

  // Add a scale transformation to a widget
  Widget withScale(double scale, {Offset? origin}) {
    return Transform.scale(
      scale: scale,
      origin: origin,
      child: this,
    );
  }

  // Add a translation transformation to a widget
  Widget withTranslation(Offset offset) {
    return Transform.translate(
      offset: offset,
      child: this,
    );
  }

  // Add a fade animation to a widget
  Widget withFadeAnimation(AnimationController controller) {
    return FadeTransition(
      opacity: controller,
      child: this,
    );
  }

  // Add a slide animation to a widget
  Widget withSlideAnimation(
      AnimationController controller, Offset begin, Offset end) {
    return SlideTransition(
      position: Tween<Offset>(begin: begin, end: end).animate(controller),
      child: this,
    );
  }
}

/////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////// BUILD CONTEXT /////////////////////////////////////////////////
extension ContextExtensions on BuildContext {
   String formatPrice(double price, {String? symbol}) {
    final formatter = NumberFormat('#,###');
    final formatted = formatter.format(price);
    return symbol != null ? '$symbol$formatted' : formatted;
  }
  // Get the theme data
  ThemeData get theme => Theme.of(this);

  // Get the text theme
  TextTheme get textTheme => theme.textTheme;

  double get screenWidth => MediaQuery.of(this).size.width;

  // Get the screen height
  double get screenHeight => MediaQuery.of(this).size.height;

 

  // Create a SizedBox with a percentage of the screen height
  SizedBox heightBoxPercent(double percent) {
    return SizedBox(height: screenHeight * (percent / 100));
  }

  // Create a SizedBox with a percentage of the screen width
  SizedBox widthBoxPercent(double percent) {
    return SizedBox(width: screenWidth * (percent / 100));
  }



  // Get the primary color
  Color get primaryColor => theme.primaryColor;

  // Get the accent color (or secondary color)
  Color get accentColor => theme.colorScheme.secondary;

  // Get the background color
  Color get backgroundColor => theme.colorScheme.surface;

  // Get the padding (safe area) from the top (e.g., status bar)
  double get paddingTop => MediaQuery.of(this).padding.top;

  // Get the padding (safe area) from the bottom (e.g., navigation bar)
  double get paddingBottom => MediaQuery.of(this).padding.bottom;

  // Get the device pixel ratio
  double get pixelRatio => MediaQuery.of(this).devicePixelRatio;

  // Get the platform brightness (light/dark mode)
  Brightness get platformBrightness => MediaQuery.of(this).platformBrightness;

  // Check if the device is in landscape orientation
  bool get isLandscape =>
      MediaQuery.of(this).orientation == Orientation.landscape;

  // Check if the device is in portrait orientation
  bool get isPortrait =>
      MediaQuery.of(this).orientation == Orientation.portrait;

  // Get the current locale
  Locale get locale => Localizations.localeOf(this);

  // Get the current navigator state
  NavigatorState get navigator => Navigator.of(this);

  // Get the current scaffold state
  ScaffoldState get scaffold => Scaffold.of(this);

  // Get the current overlay state
  OverlayState? get overlay => Overlay.of(this);

  // Show a snackbar
  void showSnackBar(String message,
      {Duration duration = const Duration(seconds: 2)}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
      ),
    );
  }

  // Push a new route
  Future<T?> push<T>(Widget page) {
    return Navigator.of(this).push(
      MaterialPageRoute(builder: (context) => page),
    );
  }

  // Push a replacement route
  Future<T?> pushReplacement<T>(Widget page) {
    return Navigator.of(this).pushReplacement(
      MaterialPageRoute(builder: (context) => page),
    );
  }

  // Pop the current route
  void pop<T>([T? result]) {
    Navigator.of(this).pop(result);
  }

  // Check if the current route can be popped
  bool get canPop => Navigator.of(this).canPop();

  // Get the arguments passed to the current route
  Object? get routeArguments => ModalRoute.of(this)?.settings.arguments;

  // Get the current focus scope
  FocusScopeNode get focusScope => FocusScope.of(this);

  // Get the current form state
  FormState? get formState => Form.of(this);

  // Get the current scroll controller
  ScrollController? get scrollController => PrimaryScrollController.of(this);

  TextStyle? get headlineLargeStyle => Theme.of(this).textTheme.headlineLarge;
  TextStyle? get headlineMediumStyle => Theme.of(this).textTheme.headlineMedium;
  TextStyle? get headlineSmallStyle => Theme.of(this).textTheme.headlineSmall;
  TextStyle? get bodyLargeStyle => Theme.of(this).textTheme.bodyLarge;
  TextStyle? get bodyMediumStyle => Theme.of(this).textTheme.bodyMedium;
  TextStyle? get bodySmallStyle => Theme.of(this).textTheme.bodySmall;
  TextStyle? get displayLargeStyle => Theme.of(this).textTheme.displayLarge;
  TextStyle? get displayMediumStyle => Theme.of(this).textTheme.displayMedium;
  TextStyle? get displaySmallStyle => Theme.of(this).textTheme.displaySmall;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////// SHADOWS ////////////////////////////////////////////////////////
extension Shadow on List<BoxShadow> {
  /// Small shadow (subtle, used for light elevation)
  static List<BoxShadow> small({Color color = Colors.black26}) => [
        BoxShadow(
          color: color,
          offset: const Offset(0, 1),
          blurRadius: 2,
        ),
      ];

  /// Medium shadow (moderate elevation)
  static List<BoxShadow> medium({Color color = Colors.black38}) => [
        BoxShadow(
          color: color,
          offset: const Offset(0, 4),
          blurRadius: 6,
        ),
      ];

  /// Large shadow (strong and deep)
  static List<BoxShadow> large({Color color = Colors.black45}) => [
        BoxShadow(
          color: color,
          offset: const Offset(0, 10),
          blurRadius: 15,
        ),
      ];

  /// Inner shadow (inset effect, used for pressed buttons or card depth)
  static List<BoxShadow> inner({Color color = Colors.black12}) => [
        BoxShadow(
          color: color,
          offset: const Offset(0, -1),
          blurRadius: 8,
          spreadRadius: -5,
        ),
      ];

  /// Double shadow (2X blur for heavy depth)
  static List<BoxShadow> doubleShadow({Color color = Colors.black26}) => [
        BoxShadow(
          color: color,
          offset: const Offset(0, 5),
          blurRadius: 10,
        ),
        BoxShadow(
          color: color.withOpacity(0.5),
          offset: const Offset(0, 10),
          blurRadius: 20,
        ),
      ];

  /// Glow effect (soft, glowing shadow)
  static List<BoxShadow> glow({Color color = Colors.blueAccent}) => [
        BoxShadow(
          color: color.withOpacity(0.5),
          blurRadius: 20,
          spreadRadius: 8,
        ),
      ];

  /// Soft shadow (natural, subtle effect)
  static List<BoxShadow> soft({Color color = Colors.black12}) => [
        BoxShadow(
          color: color,
          offset: const Offset(2, 2),
          blurRadius: 5,
          spreadRadius: 1,
        ),
      ];

  /// Hard shadow (sharp, less blur)
  static List<BoxShadow> hard({Color color = Colors.black54}) => [
        BoxShadow(
          color: color,
          offset: const Offset(0, 4),
          blurRadius: 1,
          spreadRadius: 0,
        ),
      ];

  /// Spread shadow (more spread for larger area coverage)
  static List<BoxShadow> spread({
    Color color = Colors.black26,
    double spreadRadius = 10,
  }) =>
      [
        BoxShadow(
          color: color,
          offset: const Offset(0, 4),
          blurRadius: 8,
          spreadRadius: spreadRadius,
        ),
      ];
}

/////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////// CHAINS ////////////////////////////////////////////////////////

extension WidgetModifiers on Widget {
  // Apply padding
  Widget padding(EdgeInsets padding) {
    return Padding(padding: padding, child: this);
  }

  // Apply margin
  Widget margin(EdgeInsets margin) {
    return Container(margin: margin, child: this);
  }

  // Add a border
  Widget border({
    Color color = Colors.black,
    double width = 1.0,
    BorderRadius borderRadius = BorderRadius.zero,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: color, width: width),
        borderRadius: borderRadius,
      ),
      child: this,
    );
  }

  // Add a shadow
  Widget shadow(List<BoxShadow> shadows) {
    return Container(
      decoration: BoxDecoration(boxShadow: shadows),
      child: this,
    );
  }

  // Add a background color
  Widget backgroundColor(Color color) {
    return Container(
      color: color,
      child: this,
    );
  }

  // Add rounded corners (small)
  Widget roundedSm() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4.0),
      child: this,
    );
  }

  // Add rounded corners (medium)
  Widget roundedMd() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: this,
    );
  }

  // Add rounded corners (large)
  Widget roundedLg() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: this,
    );
  }

  // Add fully rounded corners (circle)
  Widget roundedFull() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(
          1000.0), // A large value to make it fully rounded
      child: this,
    );
  }

  // Finalize the chain
  Widget make() {
    return this;
  }
}

/////////////////////////////////////////////////////////////////////////////////////////
extension StringExtensions on String {
  // Check if the string is empty or blank
  bool get isNullOrEmpty => trim().isEmpty;

  // Check if the string is a valid password (e.g., at least 6 characters)
  bool get isValidPassword => length >= 6;

  // Check if the string contains only numbers
  bool get isNumeric {
    final numericRegex = RegExp(r'^-?[0-9]+$');
    return numericRegex.hasMatch(this);
  }

  // Capitalize the first letter of the string
  String get capitalize {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }

  // Convert the string to a double (returns null if invalid)
  double? get toDoubleOrNull => double.tryParse(this);

  // Convert the string to an int (returns null if invalid)
  int? get toIntOrNull => int.tryParse(this);

  // Truncate the string to a specific length and add an ellipsis
  String truncate(int maxLength) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}...';
  }

  // Remove all whitespace from the string
  String get removeWhitespace => replaceAll(RegExp(r'\s+'), '');

  // Check if the string is a valid URL
  bool get isValidUrl {
    final urlRegex = RegExp(
      r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
    );
    return urlRegex.hasMatch(this);
  }

  // Reverse the string
  String get reverse => split('').reversed.join();

  // Check if the string is a palindrome
  bool get isPalindrome => this == reverse;

  // Wrap the string in a Text widget
  Text toText({TextStyle? style}) {
    return Text(this, style: style);
  }
}
 // Create a SizedBox with a specific height
  SizedBox heightBox(double height) {
    return SizedBox(height: height);
  }

  // Create a SizedBox with a specific width
  SizedBox widthBox(double width) {
    return SizedBox(width: width);
  }