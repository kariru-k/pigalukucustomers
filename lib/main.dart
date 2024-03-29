import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mpesa_flutter_plugin/initializer.dart';
import 'package:piga_luku_customers/firebase_options.dart';
import 'package:piga_luku_customers/providers/auth_providers.dart';
import 'package:piga_luku_customers/providers/cart_provider.dart';
import 'package:piga_luku_customers/providers/coupon_provider.dart';
import 'package:piga_luku_customers/providers/location_provider.dart';
import 'package:piga_luku_customers/providers/order_provider.dart';
import 'package:piga_luku_customers/providers/store_provider.dart';
import 'package:piga_luku_customers/screens/cart_screen.dart';
import 'package:piga_luku_customers/screens/home_screen.dart';
import 'package:piga_luku_customers/screens/login_screen.dart';
import 'package:piga_luku_customers/screens/main_screen.dart';
import 'package:piga_luku_customers/screens/map_screen.dart';
import 'package:piga_luku_customers/screens/my_orders_screen.dart';
import 'package:piga_luku_customers/screens/onboard_screen.dart';
import 'package:piga_luku_customers/screens/product_details_screen.dart';
import 'package:piga_luku_customers/screens/product_list_screen.dart';
import 'package:piga_luku_customers/screens/profile_screen.dart';
import 'package:piga_luku_customers/screens/profile_update_screen.dart';
import 'package:piga_luku_customers/screens/register_screen.dart';
import 'package:piga_luku_customers/screens/splash_screen.dart';
import 'package:piga_luku_customers/screens/vendor_home_screen.dart';
import 'package:piga_luku_customers/screens/welcome_screen.dart';
import 'package:piga_luku_customers/secrets/secrets.dart';
import 'package:provider/provider.dart';

void main() async{

  Secrets secrets = Secrets();

  MpesaFlutterPlugin.setConsumerKey(secrets.consumerKey);
  MpesaFlutterPlugin.setConsumerSecret(secrets.consumerSecret);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_)=>AuthProvider(),
        ),
        ChangeNotifierProvider(
            create: (_)=> LocationProvider()
        ),
        ChangeNotifierProvider(
            create: (_)=> StoreProvider()
        ),
        ChangeNotifierProvider(
            create: (_)=> CartProvider()
        ),
        ChangeNotifierProvider(
            create: (_)=> CouponProvider()
        ),
        ChangeNotifierProvider(
            create: (_)=> OrderProvider()
        ),
      ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    User? user = FirebaseAuth.instance.currentUser;


    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.deepPurpleAccent,
        fontFamily: "Lato"
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.id,
      routes: {
        HomeScreen.id:(context)=>const HomeScreen(),
        WelcomeScreen.id:(context)=>const WelcomeScreen(),
        LoginScreen.id:(context)=>const LoginScreen(),
        SplashScreen.id:(context)=> const SplashScreen(),
        RegisterScreen.id:(context)=> const RegisterScreen(),
        OnBoardScreen.id:(context)=> const OnBoardScreen(),
        MapScreen.id:(context)=> const MapScreen(),
        MainScreen.id:(context)=> const MainScreen(),
        CartScreen.id:(context)=> const CartScreen(document: null,),
        VendorHomeScreen.id:(context) => VendorHomeScreen(documentid: user!.uid,),
        ProductListScreen.id:(context) => const ProductListScreen(),
        ProductDetailsScreen.id:(context) => const ProductDetailsScreen(document: null,),
        ProfileScreen.id:(context) => const ProfileScreen(),
        UpdateProfile.id:(context) => const UpdateProfile(),
        MyOrders.id:(context) => const MyOrders(),
      },
      builder: EasyLoading.init(),
    );
  }
}



