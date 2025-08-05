import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharma_app/app/routes/app_pages.dart';

class HomeController extends GetxController {
  List<CardModel> cardList = [
    CardModel(
      cardColor: Color(0xffA2CDFF),
      cardIcon: "assets/icons/cloud_upload.png",
      cardName: "Sync Orders",
      onTap: () {
       Get.toNamed(Routes.SELECT_CUSTOMER);
      },
      textColor: Color(0xff0872EB),
    ),
    CardModel(
      cardColor: Color(0xffBEBAFD),
      cardIcon: "assets/icons/order_summary.png",
      cardName: "Order Summary",
      onTap: () {
        // Navigate to Pharmacy page
      },
      textColor: Color(0xff350BBF),
    ),
    CardModel(
      cardColor: Color(0xff90FDF0),
      cardIcon: "assets/icons/syncdata.png",
      cardName: "Sync Data",
      onTap: () {
        // Navigate to Healthcare page
      },
      textColor: Color(0xff09877A),
    ),
    CardModel(
      cardColor: Color(0xffFFA2A2),
      cardIcon: "assets/icons/recover.png",
      cardName: "Recover",
      onTap: () {
        // Navigate to Healthcare page
      },
      textColor: Color(0xffED1D16),
    ),
  ];
}

class CardModel {
  final Color cardColor;
  final String cardIcon;
  final String cardName;
  final VoidCallback onTap;
  final Color textColor;

  CardModel({
    required this.cardColor,
    required this.cardIcon,
    required this.cardName,
    required this.onTap,
    required this.textColor,
  });
}
