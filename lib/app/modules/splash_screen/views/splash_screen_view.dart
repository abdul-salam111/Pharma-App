import 'package:flutter/material.dart';
import 'package:pharma_app/app/services/splash_services.dart';


class SplashScreenView extends StatefulWidget {
  const SplashScreenView({super.key});

  @override
  State<SplashScreenView> createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> {
  SplashServices splashServices = SplashServices();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    splashServices.isLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text(
          'SplashScreenView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
