import 'package:shared_preferences/shared_preferences.dart';

class ChacheHelper {
  // SharedPreferences noteSharedPreferences =await SharedPreferences.getInstance();
  //

  Future<SharedPreferences> getPreferences() async {
    return await SharedPreferences.getInstance();
  }
}
