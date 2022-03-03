import 'package:gafamoney/model/balance_model.dart';
import 'package:kio/connection/param/void_param.dart';
import 'package:kio/external_auth_state.dart';

class AuthState extends ExternalAuthState {
  double balance = 0;
  int notifications = 0;
  String userId;
  String phoneNumber;
  String image;
  String fullName;
  String email;
  String referral;


  void addNotification(){
    notifications++;
    notifyListeners();
  }

  void clearNotifications(){
    notifications=0;
    notifyListeners();
  }

  Future<String> loadBalance() async {
    final resp = await requestBalance.send(
      parameters: VoidParam(),
      token: await super.token,
    );
    if (resp.isSuccess) {
      print("balance updated ${resp.response.balance}");
      balance = resp.response.balance;
      notifyListeners();
      return null;
    } else {
      return resp.error.errorMessage;
    }
  }

  @override
  Future<void> idTokenUpdated(Map<String, dynamic> idToken) {
    print(idToken);
    userId = idToken['userId'];
    phoneNumber = idToken['phoneNumber'];
    fullName = idToken['fullName'];
    image = idToken['image'];
    email = idToken['email'];
    referral = idToken['referral'];
    notifyListeners();
    return null;
  }
}
