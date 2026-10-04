import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'features/home/presentation/screens/home_screen.dart';
import 'features/inventory/logic/inventory_provider.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ChangeNotifierProvider(create:(_)=>InventoryProvider(),child:const AccountantProApp()));
}
class AccountantProApp extends StatelessWidget{
  const AccountantProApp({super.key});
  @override Widget build(BuildContext context)=>MaterialApp(
    title:'المحاسب برو',debugShowCheckedModeBanner:false,locale:const Locale('ar','SA'),
    supportedLocales:const[Locale('ar','SA')],
    localizationsDelegates:const[GlobalMaterialLocalizations.delegate,GlobalWidgetsLocalizations.delegate,GlobalCupertinoLocalizations.delegate],
    theme:AppTheme.light,home:const HomeScreen());
}