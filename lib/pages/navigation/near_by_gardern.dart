import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:geocoder/geocoder.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:thuru_care_client/pages/navigation/auth.dart';
import 'package:thuru_care_client/pages/navigation/login_screen.dart';
import 'package:thuru_care_client/presentation/thuru_care_icons_icons.dart';
import 'package:thuru_care_client/widgets/layoutWidgets.dart';

/* class FourthScreenState extends StatelessWidget {
  FourthScreenState();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nearby',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green, fontFamily: 'Ubuntu'),
      home: Nearby(title: 'Nearby'),
    );
  }
}

/* class NearbyPage extends State<FourthScreenState> {
  
} */

class Nearby extends StatefulWidget {
  final String title;
  Nearby({Key key, this.title}) : super(key: key);
  @override
  _NearbyState createState() => _NearbyState();
}

class _NearbyState extends State<Nearby> {
  LocationData currentLocation;
  StreamSubscription<LocationData> streamSubscription;
  Location location = Location();

  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController controllerAddress = TextEditingController();
  double lati;
  double long;

  double zoomCamera;
  LatLng latLngCamera = new LatLng(0.0, 0.0);

  String cityText;
  String error;
  String addressLine = '';
  String countryCode = '';
  String countryName = '';
  String postalCode = '';
  String adminArea = '';
  String subLocality = '';
  String featureName = '';
  String locality = '';
  String latlng = '';
  String url = '';

  @override
  void initState() {
    super.initState();
    int load = 0;
    if (currentLocation == null) {
      lati = 6.927079;
      long = 79.861244;
    } else {
      lati = currentLocation.latitude;
      long = currentLocation.longitude;
    }

    initPlatform().then((value) {
      if (value != null) {
        _goToTheLake(lati, long).then((val) {});
      }
    });

    streamSubscription =
        location.onLocationChanged().listen((LocationData result) {
      setState(() {
        currentLocation = result;
      });
    });
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(7.93536, 80.4486423),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    if (currentLocation == null) {
      lati = 6.927079;
      long = 0.0;
    } else {
      lati = currentLocation.latitude;
      long = currentLocation.longitude;
    }
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          GoogleMap(
            mapType: MapType.normal,
            myLocationEnabled: false,
            zoomGesturesEnabled: true,
            scrollGesturesEnabled: true,
            rotateGesturesEnabled: true,
            tiltGesturesEnabled: true,
            markers: Set<Marker>.of(
              <Marker>[
                Marker(
                  onTap: () {
                    /* mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(, ))))*/
                  },
                  visible: true,
                  draggable: true,
                  markerId: MarkerId("1"),
                  position: new LatLng(
                      currentLocation.latitude, currentLocation.longitude),
                  icon: BitmapDescriptor.fromAsset(
                      "assets/icon/ic_my_garden.png"),
                  infoWindow: const InfoWindow(
                    title: 'My Garden',
                  ),
                )
              ],
            ),
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              mapController = controller;
            },
            onCameraMove: (value) {
              print("Camere Move: ${value.zoom}");
              setState(() {
                zoomCamera = value.zoom;
                latLngCamera = value.target;
              });
            },
          ),
          Positioned(
            top: 30.0,
            right: 10.0,
            left: 10.0,
            child: Container(
              child: Form(
                key: formKey,
                child: Card(
                  color: Colors.white,
                  elevation: 3.0,
                  child: TextFormField(
                    controller: controllerAddress,
                    style: TextStyle(fontSize: 20.0),
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      hintText: 'Find Home Gardens',
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                      suffixIcon: IconButton(
                          tooltip: "Show Password",
                          icon: Icon(
                            Icons.my_location,
                            color: Colors.blue,
                          ),
                          onPressed: () {
                            getLatLong(controllerAddress.text);
                            print(controllerAddress.text);
                          }),
                    ),
                    onSaved: (val) {
                      controllerAddress.text = val;
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.orange[600],
        foregroundColor: Colors.white,
        onPressed: () async {
          setState(() {
            _goToTheLake(lati, long);
          });
        },
        label: Text('My Garden!'),
        icon: Icon(ThuruCareIcons.heart),
        heroTag: null,
      ),
    );
  }

  Future<String> initPlatform() async {
    LocationData myCurrentLocation;
    try {
      myCurrentLocation = await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == "PERMISSION_DENIED") {
        error = "PERMISSION_DENIED";
      } else if (e.code == "PERMISSION_DENIED_NEVER_ASK") {
        error = "Never Ask";
      }
      myCurrentLocation = null;
    }
    setState(() {
      currentLocation = myCurrentLocation;
    });
    final coordinates =
        Coordinates(currentLocation.latitude, currentLocation.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;

    cityText = first.adminArea;
    return cityText;
  }

  Future<void> _goToTheLake(double lat, double lng) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(lat, lng),
      zoom: zoomCamera,
    )));

    setState(() {
      latlng = lat.toString() + ", " + lng.toString();
      url = "https://www.google.co.in/maps/@" +
          lat.toString() +
          "," +
          lng.toString() +
          ",19z";
      print(url);
    });

    final coordinates =
        Coordinates(latLngCamera.latitude, latLngCamera.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    print("Address Line: " + first.addressLine);
    print("Country Code: " + first.countryCode);
    print("Country Name: " + first.countryName);

    print("Postal Code: " + first.postalCode);
    print("Admin Area: " + first.adminArea);

    print("Feature Name: " + first.featureName);
    print("Locality: " + first.locality);
    print("Sub Locality: " + first.subLocality);
    setState(() {
      addressLine = first.addressLine;
      countryCode = first.countryCode;
      countryName = first.countryName;
      postalCode = first.postalCode;
      adminArea = first.adminArea;
      featureName = first.featureName;
      locality = first.locality;
      subLocality = first.subLocality;
    });
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            locationDialog(latLngCamera.latitude, latLngCamera.longitude));
  }

  void getLatLong(String address) async {
    var addresses = await Geocoder.local.findAddressesFromQuery(address);
    var first = addresses.first;
    print("${first.featureName} : ${first.coordinates}");
    _goToTheLake(first.coordinates.latitude, first.coordinates.longitude);
    LatLng latLng =
        new LatLng(first.coordinates.latitude, first.coordinates.longitude);
    //_addMyMarker(latLng);
  }

  Widget locationDialog(double lat, double long) {
    return CupertinoAlertDialog(
      title: new Text(
        "MY HOME GARDEN",
        style: TextStyle(
          fontSize: 22.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        children: [
          //Text('latitude : $lat'),
          //Text('longitude : $long'),
          SizedBox(
            height: 20,
          ),
          Text(
            "address line:- $addressLine \n countryName:- $countryName \n postalCode:- $postalCode \n adminArea:- $adminArea"
            "\n locality:- $locality \n subLocality:- $subLocality",
            style: TextStyle(fontSize: 18.0),
          )
        ],
      ),
      actions: <Widget>[
        new CupertinoDialogAction(
            child: const Text('Discard'),
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context, 'Discard');
            }),
        new CupertinoDialogAction(
            child: const Text('Cancel'),
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context, 'Cancel');
            }),
      ],
    );
  }
}
 */


class FourthScreenState extends StatelessWidget {
  UserRepository userRepository = UserRepository.instance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: layoutWidgets.appBarWidget(context),
      drawer: layoutWidgets.drawerWidget(context),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ChangeNotifierProvider(
                  builder: (_) => UserRepository.instance(),
                  child: Consumer(
                    builder: (context, UserRepository user, _) {
                      switch (user.status) {
                        case Status.Authenticated:
                          return Center(child: Text("This is the nearby Page"));
                          break;
                        case Status.Authenticating:
                          return CircularProgressIndicator();
                        case Status.Unauthenticated:
                        case Status.Uninitialized:
                          return notAuthenticated(context);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget notAuthenticated(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Image.asset(
                'assets/images/intro_page3.png',
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'NEARBY',
              style: TextStyle(
                  color: Colors.green,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Please Sign In or Sign Up to check out the nearby function',
              style: TextStyle(color: Colors.green, fontSize: 15),
              textAlign: TextAlign.center,
            ),
          ),
          MaterialButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
            color: Colors.green,
            child: Text(
              "Sign In / Sign Up",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}