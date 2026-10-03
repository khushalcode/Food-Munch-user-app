import 'dart:convert';
import 'dart:developer';
import 'package:dart_pusher_channels/dart_pusher_channels.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/auth/controllers/auth_controller.dart';
import 'package:sixam_mart/util/app_constants.dart';
import '../features/ride_share_module/ride_location/screens/map_screen.dart';



class PusherHelper{

  static PusherChannelsClient?  pusherClient;

  static Future<void> initializePusher() async{
    PusherChannelsOptions testOptions = PusherChannelsOptions.fromHost(
      host: Get.find<SplashController>().configModel?.websocketUrl ?? '192.168.1.62',
      scheme: 'ws',
      key: '6ammart',
      port: 6001,
    );

    pusherClient = PusherChannelsClient.websocket(
      options: testOptions,
      connectionErrorHandler: (exception, trace, refresh) async {
        log('=================$exception');
        refresh();
      },
    );

    await pusherClient?.connect();


    String? pusherChannelId =  pusherClient?.channelsManager.channelsConnectionDelegate.socketId;
      if(pusherChannelId != null){
        log('=================Pusher Connected');
      }


     pusherClient?.lifecycleStream.listen((event) {
       log('=================Pusher DisConnected');
     });


  }

  // late PrivateChannel pusherDriverLocation;
  late PublicChannel? publicChannel;

  void pusherDriverStatus({required String deliverymanId, required Function(RecordLocationBodyModel) onLocationReceived}){

    String channel = 'dm_location_$deliverymanId';

    log('========channel is: $channel');

    // _publicChannel = pusherClient!.publicChannel('pusher:subscribe');
    publicChannel = pusherClient!.publicChannel(channel);

    // _publicChannel.subscribe();
    publicChannel?.subscribeIfNotUnsubscribed();
    // FIX: PublicChannel uses 'pusher:subscription_succeeded' event via bind()

    publicChannel?.bind('pusher:subscription_succeeded').listen((_) {
      log('=======Public Subscribed');
    });

    publicChannel?.bind('pusher:subscription_error').listen((error) {
      log('=======Public Subscription Failed: ${error.data}');
    });

    publicChannel?.bind(channel).listen((event) {
      log('===========pusherDriverStatus bind is: ${event.data}');
      onLocationReceived(RecordLocationBodyModel(
        latitude: jsonDecode(event.data)['latitude'],
        longitude: jsonDecode(event.data)['longitude'],
        location: jsonDecode(event.data)['location'],
      ));
    });


  }



  late PrivateChannel pusherDriverAccepted;
  late PrivateChannel driverTripStarted;
  late PrivateChannel driverTripCancelled;
  late PrivateChannel driverTripCompleted;
  late PrivateChannel driverPaymentReceived;

  void pusherRiderStatus(String tripId){

    if (Get.find<SplashController>().pusherConnectionStatus != null || Get.find<SplashController>().pusherConnectionStatus == 'Connected'){
      pusherDriverAccepted = pusherClient!.privateChannel("private-driver-trip-accepted.$tripId", authorizationDelegate:
      EndpointAuthorizableChannelTokenAuthorizationDelegate.forPrivateChannel(
        authorizationEndpoint: Uri.parse('${AppConstants.baseUrl}${AppConstants.pusherBroadcustUrl}'),
        headers:  {
          "Accept": "application/json",
          "Authorization": "Bearer ${Get.find<AuthController>().getUserToken()}",
          "Access-Control-Allow-Origin": "*",
          'Access-Control-Allow-Methods':"PUT, GET, POST, DELETE, OPTIONS"
        },
      ));

      if(pusherDriverAccepted.currentStatus ==  null){
        pusherDriverAccepted.subscribe();
        pusherDriverAccepted.bind("driver-trip-accepted.$tripId").listen((event) {
          print('======driver-trip-accepted');
          // Get.back();
          /* RideController removed */ null!.getRideDetails(jsonDecode(event.data!)['id']?.toString()??'').then((value){
            if(value.statusCode == 200){

              /* RideController removed */ null!.updateRideCurrentState(RideState.acceptingRider);
              /* RideController removed */ null!.startLocationRecord();
              /* RideController removed */ null!.updateRideController();
              // Get.find<MapController>().notifyMapController();
              print('----pusher--current route: ${Get.currentRoute}');
              if(Get.currentRoute == '/MapScreen'){
                Get.off(() => const MapScreen(fromScreen: MapScreenType.dashboard));
              } else {
                Get.to(() => const MapScreen(fromScreen: MapScreenType.dashboard));
              }
            }
          });
        });
      }



      driverTripStarted = pusherClient!.privateChannel("private-driver-trip-started.$tripId", authorizationDelegate:
      EndpointAuthorizableChannelTokenAuthorizationDelegate.forPrivateChannel(
        authorizationEndpoint: Uri.parse('${AppConstants.baseUrl}${AppConstants.pusherBroadcustUrl}'),
        headers:  {
          "Accept": "application/json",
          "Authorization": "Bearer ${Get.find<AuthController>().getUserToken()}",
          "Access-Control-Allow-Origin": "*",
          'Access-Control-Allow-Methods':"PUT, GET, POST, DELETE, OPTIONS"
        },
      ));

      if(driverTripStarted.currentStatus == null){
        driverTripStarted.subscribe();
        driverTripStarted.bind("driver-trip-started.$tripId").listen((event) {
          print('======driver-trip-started');
          /* RideController removed */ null!.remainingDistance(jsonDecode(event.data!)['id']?.toString()??'', mapBound: false);
          /* RideController removed */ null!.startLocationRecord();
          /* RideController removed */ null!.getRideDetails(jsonDecode(event.data!)['id']?.toString()??'');
          /* RideController removed */ null!.updateRideCurrentState(RideState.ongoingRide);
          /* SafetyAlertController removed */ null!.checkDriverNeedSafety();
          // /* RideController removed */ null!.updateRideController();
          if(Get.currentRoute != '/MapScreen') {
            Get.to(() => const MapScreen(fromScreen: MapScreenType.splash));
          }

        });
      }


      driverTripCancelled = pusherClient!.privateChannel("private-driver-trip-cancelled.$tripId", authorizationDelegate:
      EndpointAuthorizableChannelTokenAuthorizationDelegate.forPrivateChannel(
        authorizationEndpoint: Uri.parse('${AppConstants.baseUrl}${AppConstants.pusherBroadcustUrl}'),
        // authorizationEndpoint: Uri.parse('https://${Get.find<SplashController>().configModel!.webSocketUri}/broadcasting/auth'),
        headers:  {
          "Accept": "application/json",
          "Authorization": "Bearer ${Get.find<AuthController>().getUserToken()}",
          "Access-Control-Allow-Origin": "*",
          'Access-Control-Allow-Methods':"PUT, GET, POST, DELETE, OPTIONS"
        },
      ));

      if(driverTripCancelled.currentStatus == null){
        driverTripCancelled.subscribe();
        driverTripCancelled.bind("driver-trip-cancelled.$tripId").listen((event) async{
          print('======driver-trip-cancelled');
          /* RideController removed */ null!.getCurrentRide();
          /* RideController removed */ null!.stopLocationRecord();
          /* SafetyAlertController removed */ null!.cancelDriverNeedSafetyStream();

          if(Get.currentRoute == '/MapScreen') {
            Get.off(() => RideOrderCompleteScreen(tripId: jsonDecode(event.data!)['id']?.toString() ?? ''));
          } else {
            Get.to(() => RideOrderCompleteScreen(tripId: jsonDecode(event.data!)['id']?.toString() ?? ''));
          }
        });
      }



      driverTripCompleted = pusherClient!.privateChannel("private-driver-trip-completed.$tripId", authorizationDelegate:
      EndpointAuthorizableChannelTokenAuthorizationDelegate.forPrivateChannel(
        authorizationEndpoint: Uri.parse('${AppConstants.baseUrl}${AppConstants.pusherBroadcustUrl}'),
        // authorizationEndpoint: Uri.parse('https://${Get.find<SplashController>().configModel!.webSocketUri}/broadcasting/auth'),
        headers:  {
          "Accept": "application/json",
          "Authorization": "Bearer ${Get.find<AuthController>().getUserToken()}",
          "Access-Control-Allow-Origin": "*",
          'Access-Control-Allow-Methods':"PUT, GET, POST, DELETE, OPTIONS"
        },
      ));

      if(driverTripCompleted.currentStatus ==  null){
        driverTripCompleted.subscribe();
        driverTripCompleted.bind("driver-trip-completed.$tripId").listen((event) {

          print('======driver-trip-completed');
          /* SafetyAlertController removed */ null!.cancelDriverNeedSafetyStream();
          // /* RideController removed */ null!.getCurrentRide();
          Get.dialog(
            const ConfirmationTripDialog(isStartedTrip: false),
            barrierDismissible: false,
          );
          /* RideController removed */ null!.getFinalFare(jsonDecode(event.data!)['id']?.toString()??'').then((value) {
            if (value.statusCode == 200) {
              /* RideController removed */ null!.updateRideCurrentState(RideState.completeRide);
              Get.find<MapController>().notifyMapController();
              Get.back();
              Get.off(() => RidePaymentScreen(rideId: jsonDecode(event.data!)['id']?.toString()??''));
            }
          });

        });
      }



      driverPaymentReceived = pusherClient!.privateChannel("private-driver-payment-received.$tripId", authorizationDelegate:
      EndpointAuthorizableChannelTokenAuthorizationDelegate.forPrivateChannel(
        authorizationEndpoint: Uri.parse('${AppConstants.baseUrl}${AppConstants.pusherBroadcustUrl}'),
        // authorizationEndpoint: Uri.parse('https://${Get.find<SplashController>().configModel!.webSocketUri}/broadcasting/auth'),
        headers:  {
          "Accept": "application/json",
          "Authorization": "Bearer ${Get.find<AuthController>().getUserToken()}",
          "Access-Control-Allow-Origin": "*",
          'Access-Control-Allow-Methods':"PUT, GET, POST, DELETE, OPTIONS"
        },
      ));
      if(driverPaymentReceived.currentStatus == null){
        driverPaymentReceived.subscribe();
        driverPaymentReceived.bind("driver-payment-received.$tripId").listen((event) {
          if(Get.find<SplashController>().configModel!.reviewStatus?? false){
            if(jsonDecode(event.data!)['type']== 'ride_request' && Get.find<SplashController>().configModel!.reviewStatus!){
              Get.off(() => RidePaymentScreen(rideId: jsonDecode(event.data!)['id']?.toString()??''));

              // Get.off(()=> ReviewScreen(tripId: jsonDecode(event.data!)['id']));
            }
            /* RideController removed */ null!.tripDetails = null;
          }else{
            // Get.offAllNamed(RouteHelper.getInitialRoute());
            Get.offAll(() => RideOrderCompleteScreen(tripId: jsonDecode(event.data!)['id']?.toString()??''));
            /* RideController removed */ null!.tripDetails = null;
          }
        });
      }
    }

  }


  void pusherDisconnectPusher(){
    publicChannel?.unsubscribe();
    pusherClient?.disconnect();
  }


}

class RecordLocationBodyModel {
  String? latitude;
  String? longitude;
  String? location;

  RecordLocationBodyModel({this.latitude, this.longitude, this.location});
}