import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:sixam_mart/features/auth/controllers/auth_controller.dart';
import 'package:sixam_mart/features/cart/controllers/cart_controller.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/notification/domain/models/notification_body_model.dart';
import 'package:sixam_mart/helper/address_helper.dart';
import 'package:sixam_mart/helper/auth_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/common/widgets/no_internet_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  final NotificationBodyModel? body;
  final String? deeplinkUrl;
  const SplashScreen({super.key, required this.body, required this.deeplinkUrl});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  StreamSubscription<List<ConnectivityResult>>? _onConnectivityChanged;

  @override
  void initState() {
    super.initState();

    bool firstTime = true;
    _onConnectivityChanged = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
      bool isConnected = result.contains(ConnectivityResult.wifi) || result.contains(ConnectivityResult.mobile);

      if(!firstTime) {
        isConnected ? ScaffoldMessenger.of(Get.context!).hideCurrentSnackBar() : const SizedBox();
        ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
          backgroundColor: isConnected ? Colors.green : Colors.red,
          duration: Duration(seconds: isConnected ? 3 : 6000),
          content: Text(isConnected ? 'connected'.tr : 'no_connection'.tr, textAlign: TextAlign.center),
        ));
        if(isConnected) {
          print('=========here coming-----1-->> ${Get.find<SplashController>().deeplinkRoute}');
          if(Get.find<SplashController>().deeplinkRoute == null) {
            Get.find<SplashController>().getConfigData(notificationBody: widget.body);
          }
        }
      }

      firstTime = false;
    });

    Get.find<SplashController>().initSharedData();
    if((AuthHelper.getGuestId().isNotEmpty || AuthHelper.isLoggedIn()) && Get.find<SplashController>().cacheModule != null) {
      Get.find<CartController>().getAllCarts();
    }
    // _route();
    print('=========here coming-----2-->> ${Get.find<SplashController>().deeplinkRoute == null}');
    if(Get.find<SplashController>().deeplinkRoute == null) {
      Get.find<SplashController>().getConfigData(notificationBody: widget.body);
    }
    _route();
  }

  @override
  void dispose() {
    super.dispose();

    _onConnectivityChanged?.cancel();
  }

  void _route() {
    Get.find<SplashController>().getConfigData(handleMaintenanceMode: false, notificationBody: widget.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      body: GetBuilder<SplashController>(builder: (splashController) {
        if(!splashController.hasConnection) {
          return NoInternetScreen(child: SplashScreen(body: widget.body, deeplinkUrl: widget.deeplinkUrl));
        }
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFF5F7F8), Color(0xFFEFF4F1)],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.85, end: 1.0),
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeOutBack,
                    builder: (context, scale, child) => Transform.scale(scale: scale, child: child),
                    child: Container(
                      width: 130, height: 130,
                      decoration: BoxDecoration(
                        color: const Color(0xFF7ED321),
                        borderRadius: BorderRadius.circular(65),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF7ED321).withValues(alpha: 0.30),
                            blurRadius: 32,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.restaurant, color: Colors.white, size: 64),
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text('FOOD MUNCH',
                    style: TextStyle(fontFamily: 'Roboto', fontSize: 32, fontWeight: FontWeight.w800, color: Color(0xFF1F2937), letterSpacing: 2.0)),
                  const SizedBox(height: 6),
                  const Text('Good Food, Delivered',
                    style: TextStyle(fontFamily: 'Roboto', fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xFF9CA3AF), letterSpacing: 1.2)),
                  const SizedBox(height: 64),
                  const SizedBox(width: 28, height: 28,
                    child: CircularProgressIndicator(strokeWidth: 2.5, valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7ED321)))),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
