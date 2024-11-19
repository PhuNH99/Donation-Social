class Validation {


  static String validateEmail(String email){
    String regex = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    if(RegExp(regex).hasMatch(email)){
      return "Email Valid";
    }
    return null;
  }

  static String validatePassword(String password){
//    String regex = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
//    if(RegExp(regex).hasMatch(password)){
//      return true;
//    } // TEMP //
    return "Vaild";
  }
}