import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharma_app/app/core/core.dart';
import 'package:pharma_app/app/routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppImages.appLogo),
          fit: BoxFit.fill,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: padding16,
          child: Column(
            crossAxisAlignment: crossAxisStart,
            children: [
              heightBox(120),
              Text(
                "Welcome, Abdul Salam",
                style: context.headlineSmallStyle!.copyWith(
                  color: AppColors.blackTextColor,
                ),
              ),
              heightBox(20),
              GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.SELECT_CUSTOMER);
                },
                child: Container(
                  width: double.infinity,
                  height: context.screenHeight * 0.15,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xffFFE7D3).withAlpha((0.5 * 255).toInt()),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: mainAxisCenter,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white.withAlpha(
                            (0.7 * 255).toInt(),
                          ),
                          child: Image.asset(
                            "assets/icons/cart.png",
                            width: 30,
                            height: 30,
                          ),
                        ),
                        heightBox(5),
                        Text(
                          "Create New Order",
                          style: context.bodySmallStyle!.copyWith(
                            color: Color(0xffFE7A07),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              heightBox(12),
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: controller.cardList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    crossAxisCount: 2,
                    mainAxisExtent: context.screenHeight * 0.15,
                  ),
                  itemBuilder: (context, index) {
                    final card = controller.cardList[index];
                    return GestureDetector(
                      onTap: card.onTap,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: card.cardColor.withAlpha((0.3 * 255).toInt()),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: mainAxisCenter,
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.white.withAlpha(
                                  (0.7 * 255).toInt(),
                                ),
                                child: Image.asset(
                                  card.cardIcon,
                                  width: 30,
                                  height: 30,
                                ),
                              ),
                              heightBox(5),

                              Text(
                                card.cardName,
                                style: context.bodySmallStyle!.copyWith(
                                  color: card.textColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              Align(
                alignment: bottomRight,
                child: TextButton.icon(
                  onPressed: () {},
                  label: Text(
                    "Logout",
                    style: context.bodyMediumStyle!.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  icon: Image.asset(
                    "assets/icons/logout.png",
                    width: 20,
                    height: 20,
                  ),
                ),
              ),
              heightBox(20),
            ],
          ),
        ),
      ),
    );
  }
}
